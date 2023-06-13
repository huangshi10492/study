from django.db import models
from django.contrib.auth.models import User


# Create your models here.


class Activity(models.Model):
    name = models.CharField(max_length=100)
    credit = models.CharField(max_length=5)


class Student(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    student_name = models.CharField(max_length=10)
    activity = models.ManyToManyField(Activity, blank=True, through='ActivityStudent')

    def __str__(self):
        # return self.user.__str__()
        return "{}".format(self.user.__str__())


class ActivityStudent(models.Model):
    activity = models.ForeignKey(Activity, on_delete=models.CASCADE)
    student = models.ForeignKey(Student, on_delete=models.CASCADE)
    status = models.IntegerField(default=0)
