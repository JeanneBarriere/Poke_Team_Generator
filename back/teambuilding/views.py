from turtle import title
from django.shortcuts import render
from django.http import HttpResponse
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from teambuilding.models import Team
import simplejson as json


# Create your views here.
@api_view(['GET'])
@permission_classes([AllowAny])
def get_teams(request):
    team_list = Team.objects.all()
    table_result = []
    for team in team_list:
        table_result.append(team.title)
    current = {'list': table_result}
    return HttpResponse(json.dumps(current), status=200)


@api_view(['POST'])
@permission_classes([AllowAny])
def get_teams_title(request):
    team = Team.objects.get(title=request.data['title'])
    current_team = {}
    current_team['title'] = team.title
    team_list = team.team.replace("[", "")
    team_list = team_list.replace("]", "")
    team_list = team_list.replace("'", "")
    team_list = team_list.replace(" ", "")
    team_list = team_list.split(",")
    team_result = []
    for t in team_list:
        team_result.append(t.lower())

    current_team['team'] = team_result

    current = {'team': current_team}
    return HttpResponse(json.dumps(current), status=200)


@api_view(['POST'])
@permission_classes([AllowAny])
def add_team(request):
    team = Team.objects.create(
        title=request.data["title"],
        team=request.data["team"]
    )
    team.save()
    return HttpResponse(json.dumps("Team added successfuly"), status=200)


@api_view(['POST'])
@permission_classes([AllowAny])
def edit_team(request):
    team = Team.objects.get(title=request.data['title'])
    team.title = request.data['newTitle']
    team.team = request.data['team']

    team.save()
    return HttpResponse(json.dumps("Team added successfuly"), status=200)
