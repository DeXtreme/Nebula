"""nebula URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, re_path

from nebula.views import healthcheck, test_db_connection
from students.views import students, get_student

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/health-check', healthcheck, name="healthcheck"),
    path('api/test-db-connection', test_db_connection, name="test-db-connection"),
    path('api/students', students, name="students-list"),
    re_path(
        r'api/student/(?P<email>.+@.+\.[a-z]{3})', get_student, name="students-detail")

]
