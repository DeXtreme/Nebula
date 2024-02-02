from django.db.models import Avg,Count,F,ExpressionWrapper,FloatField
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.exceptions import NotFound
from students.models import Student,WeeklyAttendance
from students.serializers import StudentSerializer,CohortStatsSerializer,CohortAttendanceSerializer


@api_view(['GET'])
def students(request, *args, **kwargs):
    students = Student.objects.all()
    serializer = StudentSerializer(students, many=True)

    return Response(serializer.data)


@api_view(['POST'])
def get_student(request, email, *args, **kwargs):
    try:
        student = Student.objects.get(email=email)
    except Student.DoesNotExist:
        raise NotFound()
    serializer = StudentSerializer(student)

    return Response(serializer.data)


@api_view(['GET'])
def get_cohort(request, cohort_name, *args, **kwargs):
    students = Student.objects.filter(cohort__iexact=cohort_name)
    
    stats = students.aggregate(attendance_average=Avg("attendance_average"),
                               assignment_completion=Avg("assignment_completion"),
                               total_students=Count("id"))

    serializer = CohortStatsSerializer(data=stats)
    serializer.is_valid(raise_exception=True)

    return Response(serializer.data)

@api_view(['GET'])
def get_cohort_attendance(request, cohort_name, *args, **kwargs):
    
    cohort_weeks = WeeklyAttendance.objects.filter(student__cohort__iexact=cohort_name)\
                                           .annotate(attendance=F('present') * 100.0/(F('present')+F('absent')))\
                                           .values('week')\
                                           .annotate(attendanceAverage=Avg('attendance'))
    
    serializer = CohortAttendanceSerializer(data=list(cohort_weeks),many=True)
    serializer.is_valid(raise_exception=True)

    return Response(serializer.data)
