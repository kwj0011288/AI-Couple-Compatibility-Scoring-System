from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Match
from .ai_service import calculate_match_score
from .s3_service import upload_photo_to_s3
import logging
from io import BytesIO

import cv2
import numpy as np

        
# 로깅 설정
logger = logging.getLogger(__name__)

class MatchResultView(APIView):
    """
    사용자로부터 업로드된 두 사진을 처리하고 매칭 점수를 반환하는 API 뷰.
    """
    def post(self, request):

        # debug
        logger.info("MatchResultView POST request received.")

        # 1. 사용자 입력 처리
        try:
            user_id = request.data.get("user_id")  # 사용자 ID (string)
            photo1 = request.FILES.get("photo1")  # 첫 번째 사진 파일
            photo2 = request.FILES.get("photo2")  # 두 번째 사진 파일

            # debug
            logger.info(f"user_id: {user_id}, photo1: {photo1}, photo2: {photo2}")
        
        except Exception as e:
            # debug
            logger.error(f"Failed to parse input data: {str(e)}")
            return Response({"error": f"Failed to parse input data: {str(e)}"}, status=status.HTTP_400_BAD_REQUEST)

        
        # 2. 필수 입력값 확인
        if not user_id or not photo1 or not photo2:
            # debug
            logger.warning("Missing required fields.")
            return Response({"error": "Missing required fields."}, status=status.HTTP_400_BAD_REQUEST)
        
        # 3. AI 모델에 사진 전달 및 점수 계산
        try:
            logger.info("Starting AI model processing...")

            # photo1_copy = BytesIO(photo1.read())  # 파일 데이터를 바로 읽어 BytesIO로 저장 
            # photo2_copy = BytesIO(photo2.read())

            # score = calculate_match_score(photo1_copy.read(), photo2_copy.read())

            # photo1_copy.seek(0)
            # photo2_copy.seek(0)

            photo1_bytes = photo1.read()
            photo2_bytes = photo2.read()
        
            # 점수 계산
            score = calculate_match_score(photo1_bytes, photo2_bytes)
            logger.info(f"Calculated score: {score}")
        except Exception as e:
            logger.error(f"Failed to calculate match score: {str(e)}")
            return Response({"error": f"Failed to calculate match score: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        # 4. S3에 파일 업로드
        try:
            logger.info("Uploading files to S3...")
            photo1.seek(0)  # 파일 포인터 초기화
            photo2.seek(0)

            photo1_url = upload_photo_to_s3(photo1, user_id=user_id, folder_name="photos/1")
            photo2_url = upload_photo_to_s3(photo2, user_id=user_id, folder_name="photos/2")


            # photo1_url = upload_photo_to_s3(photo1_copy, user_id=user_id, folder_name="photos/1")
            # photo2_url = upload_photo_to_s3(photo2_copy, user_id=user_id, folder_name="photos/2")

            logger.info(f"Uploaded photos: photo1_url={photo1_url}, photo2_url={photo2_url}")
        except Exception as e:
            logger.error(f"Failed to upload photos to S3: {str(e)}")
            return Response({"error": f"Failed to upload photos to S3: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        

        # 5. 데이터베이스에 저장
        try:
            match = Match.objects.create(
                user_id=user_id,
                photo1_url=photo1_url,
                photo2_url=photo2_url,
                score=score
            )
            #debug
            logger.info(f"Match object created: {match}")
        except Exception as e:
            #debug
            logger.error(f"Failed to save match to database: {str(e)}")
            return Response({"error": f"Failed to save match to database: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        # 6. 결과 반환
        #debug
        logger.info(f"Returning response: photo1_url={photo1_url}, photo2_url={photo2_url}, score={score}")
        return Response({
            "photo1_url": photo1_url,
            "photo2_url": photo2_url,
            "score": score
        }, status=status.HTTP_201_CREATED)

        
    
class RegisterNicknameView(APIView):
    """
    닉네임을 등록하고 모든 사용자의 랭킹 데이터를 갱신하는 API.
    """
    def post(self, request):
        user_id = request.data.get("user_id")
        nickname = request.data.get("nickname")

        if not user_id or not nickname:
            logger.warning("Missing user_id or nickname.")
            return Response({"error": "Missing required fields."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            # 사용자의 Match 데이터 가져오기
            match = Match.objects.get(user_id=user_id)

            # 닉네임 등록
            match.nickname = nickname
            match.save()

            # 모든 사용자 랭킹 업데이트
            users = Match.objects.filter(nickname__isnull=False).order_by('-score')
            for idx, user in enumerate(users):
                user.ranking = idx + 1  # 순위 업데이트
                user.save()
                
            # 최신 데이터 가져오기
            match.refresh_from_db()


            logger.info(f"Nickname '{nickname}' registered and all rankings updated for user_id {user_id}.")
            return Response({
                "user_id": match.user_id,
                "nickname": match.nickname,
                "ranking": match.ranking,
                "score": match.score
            }, status=status.HTTP_200_OK)
        except Match.DoesNotExist:
            logger.error(f"User with user_id {user_id} not found.")
            return Response({"error": "User not found."}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            logger.error(f"Unexpected error: {str(e)}")
            return Response({"error": "An unexpected error occurred."}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)             
        

class CurrentUserRankingView(APIView):
    """
    현재 사용자의 랭킹 정보를 닉네임을 기반으로 반환하는 API.
    """
    def post(self, request):
        # Body에서 nickname 가져오기
        nickname = request.data.get("nickname")

        if not nickname:
            return Response({"error": "Missing nickname."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            # 현재 사용자의 데이터 가져오기
            current_user = Match.objects.filter(nickname=nickname).first()

            if not current_user:
                logger.warning(f"User with nickname '{nickname}' not found.")
                return Response({"error": "User not found in rankings."}, status=status.HTTP_404_NOT_FOUND)

            # 응답 데이터 구성 (랭킹은 이미 계산된 값을 사용)
            response_data = {
                "user_id": current_user.user_id,
                "nickname": current_user.nickname,
                "score": current_user.score,
                "photo1_url": current_user.photo1_url,
                "photo2_url": current_user.photo2_url,
                "ranking": current_user.ranking  # 이미 데이터베이스에 저장된 랭킹 값
            }

            logger.info(f"Current user rank retrieved for nickname '{nickname}': {response_data}")
            return Response(response_data, status=status.HTTP_200_OK)
        except Exception as e:
            logger.error(f"Error retrieving user rank: {str(e)}")
            return Response({"error": "An error occurred while retrieving user rank."}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


# 랭킹을 10개씩 나눠서 보냄
class TotalRankingView(APIView):
    """
    닉네임이 있는 사용자만 포함한 전체 랭킹 데이터를 offset과 limit 기반으로 반환하는 API.
    """
    def get(self, request):
        try:
            # 닉네임이 있는 사용자만 필터링하고 점수 내림차순 정렬
            rankings = Match.objects.filter(nickname__isnull=False).order_by('-score')

            # offset과 limit 파라미터 필수 확인
            if 'offset' not in request.query_params or 'limit' not in request.query_params:
                return Response(
                    {"error": "Both 'offset' and 'limit' query parameters are required."},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            try:
                offset = int(request.query_params.get('offset'))
                limit = int(request.query_params.get('limit'))

                # offset과 limit 값 유효성 검사
                if offset < 0 or limit <= 0:
                    return Response(
                        {"error": "'offset' must be >= 0 and 'limit' must be > 0."},
                        status=status.HTTP_400_BAD_REQUEST,
                    )
            except ValueError:
                return Response(
                    {"error": "'offset' and 'limit' must be valid integers."},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            # 쿼리셋 슬라이싱
            total_entries = rankings.count()
            paginated_rankings = rankings[offset:offset + limit]

            # 결과 데이터 생성
            results = [
                {
                    "ranking": offset + idx + 1,  # 순위 계산
                    "user_id": match.user_id,
                    "nickname": match.nickname,
                    "score": match.score,
                    "photo1_url": match.photo1_url,
                    "photo2_url": match.photo2_url,
                }
                for idx, match in enumerate(paginated_rankings)
            ]

            # 다음 offset 계산
            next_offset = offset + limit if offset + limit < total_entries else None

            # 응답 데이터 구성
            response_data = {
                "offset": offset,
                "limit": limit,
                "total_entries": total_entries,
                "next_offset": next_offset,
                "results": results,
            }

            # 로그 기록
            logger.info(f"TotalRankingView Response: {response_data}")

            return Response(response_data, status=status.HTTP_200_OK)

        except Exception as e:
            logger.error(f"An error occurred in TotalRankingView: {str(e)}")
            return Response(
                {"error": "An error occurred while retrieving rankings."},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )

class TotalusersView(APIView):
    def get(self, request):
        try:
            # 닉네임이 있는 사용자 수
            total_nickname = Match.objects.filter(nickname__isnull=False).count()
            
            # 닉네임이 없는 사용자 수
            total_no_nickname = Match.objects.filter(nickname__isnull=True).count() + total_nickname

            response_data = {
                "total_nickname": total_nickname,
                "total_no_nickname": total_no_nickname,
            }

            logger.info(f"TotalusersView Response: {response_data}")

            return Response(response_data, status=status.HTTP_200_OK)

        except Exception as e:
            logger.error(f"An error occurred in TotalusersView: {str(e)}")
            return Response(
                {"error": "An error occurred while retrieving user counts."},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )