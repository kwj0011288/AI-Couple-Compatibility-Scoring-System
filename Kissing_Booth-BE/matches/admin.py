from django.contrib import admin
from .models import Match

@admin.register(Match)
class MatchAdmin(admin.ModelAdmin):
    list_display = ('user_id', 'nickname', 'photo1_url', 'photo2_url', 'score', 'ranking')  # 표시할 필드
    search_fields = ('user_id', 'nickname')  # 검색 가능 필드
    list_filter = ('score',)  # 필터 추가
    ordering = ('-score',)  # 기본 정렬: 점수 내림차순