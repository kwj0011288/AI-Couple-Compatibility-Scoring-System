from django.db import models

class Match(models.Model):
    """
    매칭 데이터를 저장하는 데이터베이스 모델.
    """
    # user_id를 문자열로 수동 입력받도록 설정
    user_id = models.CharField(
        max_length=100,  # 문자열의 최대 길이 (필요에 따라 조정 가능)
        unique=True,    # 고유 값으로 설정
        primary_key=True  # user_id를 primary key로 설정
    )
    nickname = models.CharField(
        max_length=100,  # 닉네임 최대 길이
        null=True,       # NULL 값 허용
        blank=True,      # 빈 값 허용 (폼에서 사용 가능)
        unique=True      # 닉네임 중복 방지
    )
    photo1_url = models.URLField()  # 첫 번째 사진 URL
    photo2_url = models.URLField()  # 두 번째 사진 URL
    score = models.FloatField()  # AI 매칭 점수
    ranking = models.PositiveIntegerField(
        null=True,  # NULL 값 허용 (닉네임이 없으면 랭킹 값 없음)
        blank=True  # 빈 값 허용
    )


    def __str__(self):
        return f"{self.user_id} - {self.nickname or 'No Nickname'} - {self.score} - {self.ranking or 'Unranked'}"