from rest_framework.test import APITestCase
from rest_framework import status
from django.urls import reverse

from students.models import Student,WeeklyAttendance


class StudentsTestCase(APITestCase):

    @classmethod
    def setUpTestData(cls):
        cls.student_1 = Student.objects.create(name="test",
                                               email="test@gmail.com",
                                               attendance_average=1,
                                               assignment_completion=3,
                                               ranking=1,
                                               cohort="Cohort1")

        cls.student_2 = Student.objects.create(name="test2",
                                               email="test2@gmail.com",
                                               attendance_average=1,
                                               assignment_completion=3,
                                               ranking=1,
                                               cohort="Cohort2")

        cls.week_1 = WeeklyAttendance.objects.create(student=cls.student_1,
                                                     week="Week 1",
                                                     present=10,
                                                     absent=2)


        cls.week_2 = WeeklyAttendance.objects.create(student=cls.student_2,
                                                     week="Week 1",
                                                     present=10,
                                                     absent=0)

    def test_students(self):
        url = reverse("students-list")

        response = self.client.get(url)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        json = response.json()

        self.assertEqual(len(json), 2)
        self.assertIn("email", json[0])
        self.assertIn("attendance_average", json[0])
        self.assertIn("assignment_completion", json[0])
        self.assertIn("ranking", json[0])
        self.assertIn("cohort", json[0])
        self.assertIn("weeklyAttendance", json[0])
    

    def test_get_student(self):
        url = reverse("students-detail", args=["test@gmail.com"])

        response = self.client.post(url)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        json = response.json()

        self.assertIn("email", json)
        self.assertIn("attendance_average", json)
        self.assertIn("assignment_completion", json)
        self.assertIn("ranking", json)
        self.assertIn("cohort", json)
        self.assertIn("weeklyAttendance", json)

    
    def test_get_cohort(self):
        url = reverse("cohort-detail", args=["Cohort1"])

        response = self.client.get(url)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        json = response.json()
        
        self.assertIn("attendance_average", json)
        self.assertIn("assignment_completion", json)
        self.assertIn("total_students", json)