from storages.backends.s3boto3 import S3Boto3Storage
from django.conf import settings


class MediaStorage(S3Boto3Storage):
    bucket_name = settings.AWS_STORAGE_BUCKET_NAME
    location = 'files'  # 미디어 파일 저장 위치
    file_overwrite = False  # 동일한 파일 이름일 경우 덮어쓰지 않음


class StaticStorage(S3Boto3Storage):
    bucket_name = settings.AWS_STORAGE_BUCKET_NAME
    location = 'static'  # 정적 파일 저장 위치
    file_overwrite = True  # 정적 파일은 항상 덮어씀