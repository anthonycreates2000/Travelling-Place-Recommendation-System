import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:travelling_app/classes/travelling_place.dart';
import 'package:travelling_app/classes/user/bookmarked_travelling_place.dart';
import 'package:travelling_app/fetch-helpers/http-helpers.dart';

class DataFetcher{
  static Future<List<TravellingPlace>> getTravellingPlacesByQuery(
      String query,) async {
    final response = await HttpHelpers.fetchTravellingPlacesUserQueryList(
      query,
    );
    dynamic jsonDecoded = jsonDecode(response.body);
    List<TravellingPlace> travellingPlaces = [];
    jsonDecoded.forEach((element) {
      TravellingPlace travellingPlace = TravellingPlace.setFromJSON(element);
      travellingPlaces.add(travellingPlace);
    });
    return travellingPlaces;
  }

  static Future<List<TravellingPlace>> getColabTravellingPlaces(
    List<BookmarkedTravellingPlace> bookmarkedTravellingPlace,
  ) async{

    final response = await HttpHelpers.fetchColabTravellingPlaces(
      bookmarkedTravellingPlace,
    );

    dynamic jsonDecoded = jsonDecode(response.body);

    List<TravellingPlace> recommendedTravellingPlaces = [];

    jsonDecoded.forEach((element){
      TravellingPlace recommendedTravellingPlace = TravellingPlace.setFromJSON(element);
      recommendedTravellingPlaces.add(recommendedTravellingPlace);
    });

    return recommendedTravellingPlaces;
  }
}