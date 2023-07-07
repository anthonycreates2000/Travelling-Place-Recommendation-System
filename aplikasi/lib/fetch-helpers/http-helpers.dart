import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:travelling_app/classes/user/bookmarked_travelling_place.dart';
import 'package:travelling_app/fetch-helpers/api-endpoint.dart';

class HttpHelpers{
  static Map <String, String> getUrlHeader(){
    return {
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
    };
  }
  static Future<http.Response> fetchTravellingPlacesUserQueryList(
      String query,
    ){
    var jsonRequestBody = {
      "query": query,
    };

    Uri uri = Uri.http(
        ApiEndpoint.getBaseAPIUrl(),
        ApiEndpoint.getTravellingPlacesUserQueryLink(),
        jsonRequestBody
    );

    return http.get(
      uri,
      headers: getUrlHeader(),
    );
  }

  static Future<http.Response> fetchColabTravellingPlaces(
    List<BookmarkedTravellingPlace> bookmarkedTravellingPlaces
  ) async {

    List<dynamic> userRatingJSON = [];
    userRatingJSON = bookmarkedTravellingPlaces.map(
            (bookmarkedTravellingPlace) => bookmarkedTravellingPlace.convertForColabJSON()
    ).toList();

    var jsonRequestBody = {
      "data": jsonEncode(userRatingJSON),
    };

    Uri uri = Uri.http(
      ApiEndpoint.getBaseAPIUrl(),
      ApiEndpoint.getColabTravellingPlacesLink(),
      jsonRequestBody,
    );

    return http.get(
      uri,
      headers: getUrlHeader(),
    );
  }
}