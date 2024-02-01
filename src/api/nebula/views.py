from django.contrib.auth.models import User
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status



@api_view(['GET'])
def healthcheck(request, *args, **kwargs):
        """View check if the server is healthy"""
        return Response(status=status.HTTP_200_OK)

@api_view(['POST'])
def test_db_connection(request, *args, **kwargs):
    try:
        User.objects.count()
        return Response(status=status.HTTP_200_OK)
    except:
        return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)
