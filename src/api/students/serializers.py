from rest_framework import serializers
from students.models import Student,WeeklyAttendance


class WeeklyAttendanceSerializer(serializers.ModelSerializer):
    class Meta:
        model = WeeklyAttendance
        fields = ['week', 'present', 'absent']

class StudentSerializer(serializers.ModelSerializer):
    weeklyAttendance = WeeklyAttendanceSerializer(source='weekly_attendance',many=True)
    class Meta:
        model = Student
        fields = '__all__'
