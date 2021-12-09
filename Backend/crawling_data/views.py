# Create your views here.
from django.shortcuts import render
from rest_framework.response import Response
from .models import ReviewData
from .models import BuildingData
from rest_framework.views import APIView
from .serializers import ReviewSerializer
from .serializers import BuildingSerializer
from django.shortcuts import render, get_object_or_404

class BuildingInfoAPI(APIView):
    def get(self, request):
        queryset = BuildingData.objects.all()
        serializer = BuildingSerializer(queryset, many=True)
        return Response(serializer.data)
class ReviewListAPI(APIView): 
    def get(self, request, slug): 
        building_name = BuildingData.objects.filter(slug=slug).values_list('building_name',flat=True)[0] 
        queryset = ReviewData.objects.filter(building_name=building_name) 
        serializer = ReviewSerializer(queryset, many=True) 
        return Response(serializer.data)