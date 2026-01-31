from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),  # Django 관리자 페이지
    path('matches/', include('matches.urls')),  # matches 앱의 URL 라우팅
]