from django.db import models


class Student(models.Model):
    """Model for student data"""

    cohorts = [("Cohort 1", "Cohort 1"),
               ("Cohort 2", "Cohort 2")]

    name = models.CharField(max_length=255)
    email = models.EmailField()
    attendance_average = models.FloatField()
    assignment_completion = models.IntegerField()
    ranking = models.IntegerField()
    cohort = models.CharField(choices=cohorts)

    def __str__(self):
        return f"Student|{self.id}|{self.name}"
