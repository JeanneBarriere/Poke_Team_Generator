from turtle import title
from django.db import models
from django.contrib.auth.models import User

# Create your models here.


class Team(models.Model):
    title = models.CharField(max_length=200, unique=False)
    # team = models.CharField(max_length=500, blank=True, null=True)
    update = models.DateTimeField('date_published', auto_now=True)
    author = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return self.title


class Iv(models.Model):
    HP = models.FloatField(blank=True)
    Atk = models.FloatField(blank=True)
    Def = models.FloatField(blank=True)
    SpA = models.FloatField(blank=True)
    SpD = models.FloatField(blank=True)
    Spe = models.FloatField(blank=True)


class Ev(models.Model):
    HP = models.FloatField(blank=True)
    Atk = models.FloatField(blank=True)
    Def = models.FloatField(blank=True)
    SpA = models.FloatField(blank=True)
    SpD = models.FloatField(blank=True)
    Spe = models.FloatField(blank=True)


class Pokemon(models.Model):
    name = models.CharField(max_length=200, blank=True, null=True)
    nickName = models.CharField(max_length=200, blank=True, null=True)
    shiny = models.BooleanField(blank=True, null=True)
    gender = models.CharField(max_length=200, blank=True, null=True)
    item = models.CharField(max_length=200, blank=True, null=True)
    ability = models.CharField(max_length=200, blank=True, null=True)
    level = models.IntegerField(blank=True, null=True)
    nature = models.CharField(max_length=200, blank=True, null=True)
    moves1 = models.CharField(max_length=200, blank=True, null=True)
    moves2 = models.CharField(max_length=200, blank=True, null=True)
    moves3 = models.CharField(max_length=200, blank=True, null=True)
    moves4 = models.CharField(max_length=200, blank=True, null=True)
    ivs = models.ForeignKey(Iv, on_delete=models.CASCADE)
    evs = models.ForeignKey(Ev, on_delete=models.CASCADE)
    team = models.ForeignKey(Team, on_delete=models.CASCADE)

    def __str__(self):
        return self.title
