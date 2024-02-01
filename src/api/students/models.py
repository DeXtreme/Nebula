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


class WeeklyAttendance(models.Model):
   """Model for weekly attendance"""
   
   student = models.ForeignKey(Student,on_delete=models.CASCADE,related_name='weekly_attendance')
   week = models.CharField(max_length=255)
   present = models.IntegerField()
   absent = models.IntegerField()
   
   
   def __str__(self):
       return f"Week|{self.week}|{self.student}"