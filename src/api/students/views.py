from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.exceptions import NotFound
from students.models import Student
from students.serializers import StudentSerializer


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
