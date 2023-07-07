from django.contrib import admin
from .views import ColabBasedRecommedationAPI, TravellingPlaceQueryAPI
from rest_framework import routers
from django.urls import path, include

urlpatterns = [
    path(r'travelling_places_user_query_list', TravellingPlaceQueryAPI.as_view(), name = "list_of_travelling_places_by_query"),
    path(r'colab_filtering_travelling_places', ColabBasedRecommedationAPI.as_view(), name = "colab_filtering_travelling_places"),
]