import 'package:hive/hive.dart';

part "travelling_place.g.dart";

@HiveType(typeId: 1)
class TravellingPlace{
  @HiveField(0)
  int placeId;

  @HiveField(1)
  String placeName;

  @HiveField(2)
  String description;

  @HiveField(3)
  String category;

  @HiveField(4)
  String city;

  @HiveField(5)
  int? price;

  @HiveField(6)
  double? rating;

  @HiveField(7)
  double? latitude;

  @HiveField(8)
  double? longitude;

  @HiveField(9)
  String imageURL;

  TravellingPlace({
    required this.placeId,
    required this.placeName,
    required this.description,
    required this.category,
    required this.city,
    required this.imageURL,
    this.price,
    this.rating,
    this.latitude,
    this.longitude,
  });

  String getRating(){
    if (rating == null){
      return "Unknown";
    }
    else{
      return rating.toString();
    }
  }

  String getPrice(){
    if (price == null){
      return "Unknown";
    }
    else if (price == 0){
      return "Gratis";
    }
    else{
      return price.toString();
    }
  }

  factory TravellingPlace.setFromJSON(Map<String, dynamic> jsonDatum){
    int price = 0;
    if (jsonDatum["Price"] == null){
      price = 0;
    }
    else{
      price = jsonDatum["Price"];
    }
    return TravellingPlace(
      placeId: jsonDatum["Place_Id"],
      placeName: jsonDatum["Place_Name"],
      description: jsonDatum["Description"],
      category: jsonDatum["Category"],
      city: jsonDatum["City"],
      imageURL: jsonDatum["Image_URL"],
      rating: jsonDatum["Rating"],
      price: price,
      latitude: jsonDatum['Lat'],
      longitude: jsonDatum['Long'],
    );
  }
}