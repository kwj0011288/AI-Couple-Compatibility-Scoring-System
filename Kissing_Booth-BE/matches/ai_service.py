
import cv2
import numpy as np
import mediapipe as mp
import tensorflow as tf
import os
import logging

logger = logging.getLogger(__name__)
        
def remove_background_and_make_transparent(image_bgr, threshold=0.5):
    mp_selfie_seg = mp.solutions.selfie_segmentation
    image_rgb = cv2.cvtColor(image_bgr, cv2.COLOR_BGR2RGB)
    with mp_selfie_seg.SelfieSegmentation(model_selection=1) as seg:
        results = seg.process(image_rgb)
    mask = results.segmentation_mask
    fg_condition = (mask > threshold).astype(np.uint8)
    image_rgba = cv2.cvtColor(image_bgr, cv2.COLOR_BGR2BGRA)
    image_rgba[:, :, 3] = fg_condition * 255
    image_rgba[fg_condition == 0, 0:3] = 0
    return image_rgba
  
# Model1: Mediapipe Face Detection (model_selection=1)로 단일 인물 확인
def model1_check_for_one_person(image_bgr):
    mp_face_detection = mp.solutions.face_detection
    image_rgb = cv2.cvtColor(image_bgr, cv2.COLOR_BGR2RGB)
    with mp_face_detection.FaceDetection(model_selection=1, min_detection_confidence=0.5) as face_detector:
        results = face_detector.process(image_rgb)
    num_faces = len(results.detections) if results.detections else 0
    return num_faces == 1
# Model2: Mediapipe Face Detection (model_selection=0)로 단일 인물 확인
def model2_check_for_one_person(image_bgr):
    mp_face_detection = mp.solutions.face_detection
    image_rgb = cv2.cvtColor(image_bgr, cv2.COLOR_BGR2RGB)
    with mp_face_detection.FaceDetection(model_selection=0, min_detection_confidence=0.5) as face_detector:
        results = face_detector.process(image_rgb)
    num_faces = len(results.detections) if results.detections else 0
    return num_faces == 1

def process_single_image(image_bgr):
    single_person = False
    if model1_check_for_one_person(image_bgr):
        print("Model1: 단일 인물 감지됨.")
        single_person = True
    elif model2_check_for_one_person(image_bgr):
        print("Model2: 단일 인물 감지됨.")
        single_person = True
    else:
        print("Error: 어느 모델에서도 단일 인물로 감지되지 않음.")
        return
    
    # 단일 인물이 감지된 경우 처리
    image_rgba = remove_background_and_make_transparent(image_bgr, threshold=0.5)

    # RGBA를 RGB로 변환
    image_rgb = cv2.cvtColor(image_rgba, cv2.COLOR_BGRA2BGR)

    # Mediapipe Face Detection을 이용해 얼굴 영역 감지
    mp_face_detection = mp.solutions.face_detection
    image_rgb_for_detection = cv2.cvtColor(image_rgb, cv2.COLOR_BGR2RGB)
    with mp_face_detection.FaceDetection(model_selection=1, min_detection_confidence=0.5) as face_detector:
        results = face_detector.process(image_rgb_for_detection)
    if not results.detections:
        print("얼굴을 감지하지 못했습니다.")
        return
    
    # 첫 번째 얼굴 감지 결과 사용
    detection = results.detections[0]
    h_img, w_img = image_rgb.shape[:2]
    bbox = detection.location_data.relative_bounding_box
    x_min = int(bbox.xmin * w_img)
    y_min = int(bbox.ymin * h_img)
    w_box = int(bbox.width * w_img)
    h_box = int(bbox.height * h_img)
    x1 = max(0, x_min)
    y1 = max(0, y_min)
    x2 = min(w_img, x1 + w_box)
    y2 = min(h_img, y1 + h_box)
    cropped_face_rgb = image_rgb[y1:y2, x1:x2, :]
    return cropped_face_rgb

def display_image(cropped_face_rgba):
    cv2.imshow("Cropped Face", cropped_face_rgba)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
##############################################################################
# 0. 설정 (학습 시 사용한 것과 동일해야 함)
##############################################################################
IMG_HEIGHT = 224
IMG_WIDTH = 224
base_dir = os.path.dirname(__file__)  # 스크립트의 디렉터리
MODEL_PATH = os.path.join(base_dir, "saved_model_format")    
print("base url: ", base_dir)
print(f"모델 경로: {MODEL_PATH}")

# 테스트할 새로운 이미지 경로 (기존 사용 예시용)
##############################################################################
# 1. 모델 및 임베딩 데이터 로드
##############################################################################
try:
    embedding_model = tf.keras.layers.TFSMLayer(MODEL_PATH, call_endpoint='serving_default')
    print(f"임베딩 모델이 '{MODEL_PATH}' 에서 성공적으로 로드되었습니다.")
except Exception as e:
    print(f"모델 로드 중 오류 발생: {e}")
    exit(1)
print("모델 로드 완료")
##############################################################################
# 2. 이미지 전처리 함수
##############################################################################
def load_and_preprocess_image(input_data):
    if isinstance(input_data, str):  # 파일 경로인 경우
        image = tf.io.read_file(input_data)
        image = tf.image.decode_jpeg(image, channels=3)  # 항상 3 채널로 로드
    elif isinstance(input_data, np.ndarray):  # NumPy 배열인 경우
        # NumPy 배열을 Tensor로 변환
        image = tf.convert_to_tensor(input_data, dtype=tf.float32)
        if image.shape[-1] == 4:  # 4 채널인 경우
            image = image[..., :3]  # 알파 채널 제거
    elif tf.is_tensor(input_data):  # 이미 TensorFlow 텐서인 경우
        image = input_data
    else:
        raise ValueError("입력 데이터는 파일 경로(str), NumPy 배열(np.ndarray), 또는 텐서(tf.Tensor)이어야 합니다.")
    
    # 이미지 크기 조정 및 정규화
    image = tf.image.resize(image, [IMG_HEIGHT, IMG_WIDTH])
    image = image / 255.0
    return image

def model_main_with_combined(sample_img):
    # 전처리: float32 변환, 3채널 맞춤, 리사이즈(224x224), 정규화(0~1)
    sample_img = load_and_preprocess_image(sample_img)

    # 배치 차원 추가: (H, W, C) -> (1, H, W, C)
    sample_img = tf.expand_dims(sample_img, axis=0)

    # forward pass
    outputs = embedding_model(sample_img)

    # 딕셔너리 구조 확인 (이미 확인하셨듯이 keys: dict_keys(['classification_head']))
    print("keys:", outputs.keys())
    print("values:", outputs)

    # 'classification_head' 키에 우리가 원하는 텐서가 들어 있음
    prob_tensor = outputs["classification_head"]  # shape=(1, 1), dtype=float32

    # 텐서를 numpy로 변환해 실제 값을 추출
    prob = prob_tensor.numpy()[0][0]
    print("prob:", prob)

    return prob

def handle_uploaded_file(file_bytes):
    # 파일 내용을 바이트 배열에서 NumPy 배열로 변환
    np_arr = np.frombuffer(file_bytes, np.uint8)
    img_bgr = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)
    if img_bgr is None:
        raise ValueError("Invalid image format. Could not decode image.")
    return img_bgr

def get_image(photo1, photo2):
    image_bgr1 = handle_uploaded_file(photo1)
    image_bgr2 = handle_uploaded_file(photo2)
    return image_bgr1, image_bgr2

def calculate_match_score(photo1_bytes, photo2_bytes):
    try:
        # bytes 데이터를 이미지로 디코딩
        image_bgr1 = handle_uploaded_file(photo1_bytes)
        image_bgr2 = handle_uploaded_file(photo2_bytes)

        # 이미지 처리
        cropped1 = process_single_image(image_bgr1)
        cropped2 = process_single_image(image_bgr2)

        if cropped1 is None or cropped2 is None:
            logger.error("Error: 단일 인물 검출 실패.")
            return -1.0

        # 두 크롭 이미지를 동일한 높이로 조정 후 병합
        h1, w1 = cropped1.shape[:2]
        h2, w2 = cropped2.shape[:2]
        target_height = min(h1, h2)

        cropped1_resized = cv2.resize(cropped1, (int(w1 * target_height / h1), target_height))
        cropped2_resized = cv2.resize(cropped2, (int(w2 * target_height / h2), target_height))

        combined_image = np.hstack((cropped1_resized, cropped2_resized))

        # 모델 전처리 및 유사도 계산
        combined_image_tensor = tf.convert_to_tensor(combined_image, dtype=tf.float32)  # Tensor로 변환
        combined_image = load_and_preprocess_image(combined_image_tensor)  # 수정된 전처리 함수 호출
        sim_score = model_main_with_combined(combined_image)

        if sim_score is not None:
            logger.info(f"병합된 이미지의 유사도 점수: {sim_score}")
        else:
            logger.error("유사도 계산에 실패했습니다.")
            sim_score = -1.0

        return sim_score
    except Exception as e:
        logger.error(f"calculate_match_score 처리 중 오류 발생: {e}")
        return -1.0
