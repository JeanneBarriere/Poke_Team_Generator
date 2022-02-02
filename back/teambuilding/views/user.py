from django.http import HttpResponse
from rest_framework.decorators import api_view, permission_classes
from rest_framework import permissions
from django.contrib.auth.models import User
import simplejson as json


@api_view(['POST'])
@permission_classes([permissions.AllowAny])
def create_user(request):
    user = User.objects.create_user(
        request.data["username"], password=request.data['password'])
    user.is_superuser = False
    user.is_staff = False
    user.save()
    return HttpResponse(json.dumps("User added successfuly"), status=200)
