# Generated by Django 5.0.1 on 2024-02-01 14:44

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('students', '0002_weeklyattendance'),
    ]

    operations = [
        migrations.AlterField(
            model_name='student',
            name='cohort',
            field=models.CharField(choices=[('Cohort1', 'Cohort1'), ('Cohort2', 'Cohort2')]),
        ),
    ]