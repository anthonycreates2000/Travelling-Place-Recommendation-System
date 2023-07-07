import json
import os
from unittest import result
import numpy as np
from django.http import HttpResponse
from .templates.colab_based_filtering import ColabBasedFiltering
from .templates.pandas_data_loader import PandasDataLoader
from .templates.model_loader import ModelLoader
from rest_framework import status
from rest_framework.views import APIView
import pandas as pd

# Create your views here.
# News API
class PreprocessingTemplate():
    @staticmethod
    def convert_queryset_data_to_df(queryset_data):
        query_values = queryset_data.values()
        return pd.DataFrame.from_records(query_values)

class TravellingPlaceQueryAPI(APIView):
    def get(self, request):
        try:
            data = request.data
            query = data["query"]
            print(f"Query: {query}")
        except:
            query = request.GET.get('query', '')
            print(f"Query Result 2: {query}")

        pandas_data_loader = PandasDataLoader()
        travelling_place_df = pandas_data_loader.load_travelling_places_dataset()
        top_n_df = travelling_place_df[travelling_place_df["Place_Name"].str.contains(query)]

        top_n_df["Rating"] = top_n_df["Rating"].astype(float)
        top_n_df["Lat"] = top_n_df["Lat"].astype(float)
        top_n_df["Long"] = top_n_df["Long"].astype(float)
        
        json_result = top_n_df.to_json(orient = "records")

        return HttpResponse(
            json_result, 
            content_type = "application/json", 
            status = status.HTTP_200_OK
        )

# Colab Based Filtering
class ColabBasedRecommedationAPI(APIView):

    def _load_rating_df(self, query_result):
        request_json_rating_query = json.loads(query_result)
        request_rating_df = pd.DataFrame(request_json_rating_query)
        print(request_rating_df.info())
        return request_rating_df

    def get(self, request):
        try:
            data = request.data
            query_result = data["data"]
            print(f"Query Result 1: {query_result}")
        except:
            query_result = request.GET.get('data', '')
            print(f"Query Result 2: {query_result}")

        rating_with_request_rating_df = self._load_rating_df(query_result)

        pandas_data_loader = PandasDataLoader()
        travelling_place_df = pandas_data_loader.load_travelling_places_dataset()

        model_loader = ModelLoader()
        collaborative_filtering_model = model_loader.load_collaborative_filtering_model()
        
        colab_based_filtering = ColabBasedFiltering()
        top_n_predictions_df = colab_based_filtering.make_recommendations(
            rating_with_request_rating_df,
            travelling_place_df,
            collaborative_filtering_model
        )

        top_n_predictions_df["Rating"] = top_n_predictions_df["Rating"].astype(float)

        print(top_n_predictions_df.info())

        top_n_predictions_json = top_n_predictions_df.to_json(orient = "records")
 
        return HttpResponse(top_n_predictions_json, content_type = "application/json", status = status.HTTP_200_OK)