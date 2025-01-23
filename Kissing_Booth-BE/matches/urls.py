from django.urls import path
from .views import MatchResultView, RegisterNicknameView, TotalRankingView, CurrentUserRankingView, TotalusersView

urlpatterns = [
    path('', MatchResultView.as_view(), name='match-result'),
    path('register-nickname/', RegisterNicknameView.as_view(), name='register-nickname'),  # 닉네임 등록
    path('current-ranking/', CurrentUserRankingView.as_view(), name='current-ranking'),  # 현재 사용자 랭킹 조회
    path('rankings/', TotalRankingView.as_view(), name='total-rankings'),  # 전체 랭킹 조회
    path('total-users/', TotalusersView.as_view(), name='total-users'), # 사용자수 조회
]