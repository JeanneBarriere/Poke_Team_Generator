from turtle import title
from django.db import models

# Create your models here.


class Team(models.Model):
    title = models.CharField(max_length=200, unique=True)
    team = models.CharField(max_length=500, blank=True, null=True)

    def __str__(self):
        return self.title
