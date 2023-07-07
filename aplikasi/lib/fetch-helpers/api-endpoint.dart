class ApiEndpoint{

  static String getBaseAPIUrl(){
    return "10.0.2.2:8000"; // For Testing
  }
  static String getTravellingPlacesUserQueryLink(){
    return "/travelling_api/travelling_places_user_query_list";
  }
  static String getColabTravellingPlacesLink(){
    return "/travelling_api/colab_filtering_travelling_places";
  }
}