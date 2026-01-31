import boto3
import logging

# 로깅 설정
logger = logging.getLogger(__name__)

def upload_photo_to_s3(file, user_id, folder_name="uploads"):
    """
    파일을 AWS S3에 업로드하고 URL을 반환하는 함수.
    파일 이름은 user_id만 사용.
    """
    s3 = boto3.client('s3')  # S3 클라이언트 생성
    bucket_name = "kissing-booth-bucket"  # S3 버킷 이름

    # 파일 이름 생성 (user_id만 사용)
    file_name = f"{folder_name}/{user_id}.jpg"
    logger.info(f"Generated file name: {file_name}")

    # S3에 파일 업로드
    try:
        logger.info(f"Starting upload to S3: Bucket={bucket_name}, FileName={file_name}")
        s3.upload_fileobj(
            file,  # 파일 객체
            bucket_name,  # 버킷 이름
            file_name,  # 업로드할 경로
            ExtraArgs={"ContentType": "image/jpeg"}  # 퍼블릭 읽기 권한 및 파일 형식 지정
        )
        logger.info(f"File successfully uploaded to S3: {file_name}")
    except Exception as e:
        logger.error(f"Failed to upload file to S3: {str(e)}")
        raise Exception(f"Failed to upload file to S3: {str(e)}")

    # 업로드된 파일의 퍼블릭 URL 반환
    region = "us-east-1"
    file_url = f"https://{bucket_name}.s3.{region}.amazonaws.com/{file_name}"
    logger.info(f"Generated file URL: {file_url}")

    return file_url