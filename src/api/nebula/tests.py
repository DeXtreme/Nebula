from rest_framework.test import APITestCase
from rest_framework import status
from django.urls import reverse


class StudentsTestCase(APITestCase):

    def test_healthcheck(self):
        url = reverse("healthcheck")
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_db_connection(self):
        url = reverse('test-db-connection')
        response = self.client.post(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
