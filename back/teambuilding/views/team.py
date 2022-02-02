from django.http import HttpResponse, JsonResponse
from rest_framework.decorators import api_view, permission_classes
from rest_framework import permissions
from teambuilding.models import Team
from django.contrib.auth.models import User
import simplejson as json


# Create your views here.
@api_view(['GET'])
@permission_classes((permissions.IsAuthenticated,))
def get_teams(request):
    author = User.objects.get(id=request.user.id)
    team_list = Team.objects.filter(author=author)
    table_result = []
    for team in team_list:
        table_result.append(team.title)
    current = {'list': table_result}
    return HttpResponse(json.dumps(current), status=200)


@api_view(['POST'])
@permission_classes([permissions.AllowAny])
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
@permission_classes((permissions.IsAuthenticated,))
def add_team(request):
    team = Team.objects.create(
        title=request.data["title"],
        team=request.data["team"],
        author=User.objects.get(id=request.user.id)
    )
    team.save()
    return HttpResponse(json.dumps("Team added successfuly"), status=200)


@api_view(['POST'])
@permission_classes([permissions.AllowAny])
def edit_team(request):
    team = Team.objects.get(title=request.data['title'])
    team.title = request.data['newTitle']
    team.team = request.data['team']

    team.save()
    return HttpResponse(json.dumps("Team added successfuly"), status=200)
