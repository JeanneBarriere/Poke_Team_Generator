from xml.etree.ElementTree import tostring
from django.http import HttpResponse, JsonResponse
from rest_framework.decorators import api_view, permission_classes
from rest_framework import permissions
from teambuilding.models import Ev, Iv, Pokemon, Team
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
    team_result = []
    pokes = Pokemon.objects.select_related('ivs', 'evs').filter(team=team)
    for poke in pokes:
        team_result.append(get_poke(poke))
    current_team['team'] = team_result

    return HttpResponse(json.dumps(current_team), status=200)


@api_view(['POST'])
@permission_classes((permissions.IsAuthenticated,))
def add_team(request):
    team = Team.objects.create(
        title=request.data["title"],
        author=User.objects.get(id=request.user.id)
    )
    for poke in json_team["team"]:
        save_poke(poke, team)
    team.save()
    return HttpResponse(json.dumps("Team added successfuly"), status=200)


def get_poke(poke):
    moves = []
    if poke.moves1:
        moves.append(poke.moves1)
    if poke.moves2:
        moves.append(poke.moves2)
    if poke.moves3:
        moves.append(poke.moves3)
    if poke.moves4:
        moves.append(poke.moves4)
    return {
        'name': poke.name if poke.name else "",
        'nickName': poke.nickName if poke.nickName else "",
        'shiny': poke.shiny if poke.shiny else "",
        'gender': poke.gender if poke.gender else "",
        'item': poke.item if poke.item else "",
        'ability': poke.ability if poke.ability else "",
        'level': poke.level if poke.level else 50,
        'nature': poke.nature if poke.nature else "",
        'moves': moves,
        'ivs': get_ivs(poke.ivs),
        'evs': get_evs(poke.evs),
    }


def get_ivs(ivs):
    return [ivs.HP, ivs.Atk, ivs.Def, ivs.SpA, ivs.SpD, ivs.Spe]


def get_evs(evs):
    return [evs.HP, evs.Atk, evs.Def, evs.SpA, evs.SpD, evs.Spe]


@api_view(['POST'])
@permission_classes([permissions.AllowAny])
def edit_team(request):
    json_team = request.data
    print(request.data)
    team = Team.objects.get(title=request.data['title'])
    team.title = request.data['newTitle']
    Pokemon.objects.filter(team=team).delete()
    for poke in json_team["team"]:
        save_poke(poke, team)
    team.save()
    return HttpResponse(json.dumps("Team added successfuly"), status=200)


def save_poke(poke_data, team):

    ivs = Iv.objects.create(
        HP=poke_data["ivs"][0],
        Atk=poke_data["ivs"][1],
        Def=poke_data["ivs"][2],
        SpA=poke_data["ivs"][3],
        SpD=poke_data["ivs"][4],
        Spe=poke_data["ivs"][5]
    )
    ivs.save()
    evs = Ev.objects.create(
        HP=poke_data["evs"][0],
        Atk=poke_data["evs"][1],
        Def=poke_data["evs"][2],
        SpA=poke_data["evs"][3],
        SpD=poke_data["evs"][4],
        Spe=poke_data["evs"][5]
    )
    evs.save()

    poke = Pokemon.objects.create(
        team=team,
        name=poke_data["name"],
        nickName=poke_data["nickName"],
        shiny=poke_data["shiny"],
        gender=poke_data["gender"],
        item=poke_data["item"],
        ability=poke_data["ability"],
        level=poke_data["level"],
        evs=evs,
        nature=poke_data["nature"],
        ivs=ivs,
    )
    for index, move in enumerate(poke_data["moves"]):
        print(index)
        poke.__setattr__("moves"+str(index+1), move)

    poke.ivs = ivs
    poke.evs = evs

    poke.save()
