from django.shortcuts import render
from django.http import Http404, HttpResponse
from rest_framework.views import APIView
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.http import JsonResponse
from django.core import serializers
from django.conf import settings
import json
from PIL import Image
import pytesseract
from .models import UploadImageTest
import os
# Create your views here.
@api_view(["POST"])
def calc(request):
    #img=request.FILES['url']
    #print(type(img),"((*(*(*(*(*(*(((((")
    try:
    	if(request.method=='POST'):
            fileName = str(request.POST.get('filename'))
            img=request.FILES[fileName]
            m=UploadImageTest()
            m.image=img
            m.save()
            print(os.getcwd())
            img=Image.open('media/'+m.image.name)
            x=pytesseract.image_to_string(img)
            print(x,type(x),"((*(*(*(*(*(*(((((")
            return JsonResponse({"result":x})
    except Exception as e:
        print(e)
    return JsonResponse({'this': 'value'})
def home(request):
    return HttpResponse("<h1> Go To <a href=\"calc\">adityayadav800.pythonanywhere.com/calc</a><h1>")