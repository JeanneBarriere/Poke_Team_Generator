from turtle import title
from django.db import models
from django.contrib.auth.models import User

# Create your models here.


class Team(models.Model):
    title = models.CharField(max_length=200, unique=True)
    team = models.CharField(max_length=500, blank=True, null=True)
    update = models.DateTimeField('date_published', auto_now=True)
    author = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return self.title


class Pokemon(models.Model):
    name = models.CharField(max_length=200, blank=True)
    nickName = models.CharField(max_length=200, blank=True)
    shiny = models.BooleanField(blank=True)
    gender = models.CharField(max_length=200, blank=True)
    item = models.CharField(max_length=200, blank=True)
    ability = models.CharField(max_length=200, blank=True)
    level = models.IntegerField(blank=True)
    nature = models.CharField(max_length=200, blank=True)
    moves1 = models.CharField(max_length=200, blank=True)
    moves2 = models.CharField(max_length=200, blank=True)
    moves3 = models.CharField(max_length=200, blank=True)
    moves4 = models.CharField(max_length=200, blank=True)
    team = models.ForeignKey(Team, on_delete=models.CASCADE)

    def __str__(self):
        return self.title


class Stat(models.Model):
    pokemon = models.ForeignKey(Pokemon, on_delete=models.CASCADE)
    HP = models.IntegerField(blank=True)
    Atk = models.IntegerField(blank=True)
    Def = models.IntegerField(blank=True)
    SpA = models.IntegerField(blank=True)
    SpD = models.IntegerField(blank=True)
    Spe = models.IntegerField(blank=True)
