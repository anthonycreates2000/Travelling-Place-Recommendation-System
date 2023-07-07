import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelling_app/classes/travelling_place.dart';
import 'package:travelling_app/classes/user/bookmarked_travelling_place.dart';
import 'package:travelling_app/fetch-helpers/data-fetcher.dart';
import 'package:travelling_app/globals/colors.dart';
import 'package:travelling_app/globals/route.dart';
import 'package:travelling_app/templates/card_template.dart';
import 'package:travelling_app/templates/circular_loading_element.dart';
import 'package:travelling_app/templates/top_image_horizontal_item_view.dart';
import 'package:travelling_app/templates/information_widget.dart';
import 'package:travelling_app/templates/rating_widget.dart';

class RecommendationColabWidget extends StatefulWidget{

  final List<BookmarkedTravellingPlace> bookmarkedTravellingPlaces;
  final Function parentFunction;

  const RecommendationColabWidget({
    Key? key,
    required this.bookmarkedTravellingPlaces,
    required this.parentFunction,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecommendationState();

}

class _RecommendationState extends State<RecommendationColabWidget>{

  Widget _getLoadingWidget(){
    return const CircularLoadingElement(
      message: "Sedang memproses rekomendasi untuk Anda...",
    );
  }

  List<BookmarkedTravellingPlace> getGoodRatedTravellingPlacesOnly(){
    int goodRatingTravellingPlace = 4;
    return widget.bookmarkedTravellingPlaces.where((bookmarkedTravellingPlace) {
      return bookmarkedTravellingPlace.rating >= goodRatingTravellingPlace;
    }).toList();
  }

  Widget _getRecommendationsWidget(List<TravellingPlace> recommendedTravellingPlaces){
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: recommendedTravellingPlaces.length,
          itemBuilder: (context, index) {
            TravellingPlace recommendedTravellingPlace = recommendedTravellingPlaces[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: TopImageHorizontalItemWidget(
                imageURL: recommendedTravellingPlace.imageURL,
                titleText: recommendedTravellingPlace.placeName,
                subtitleText: recommendedTravellingPlace.city,
                width: 300,
                height: 220,
                additionalWidget: Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 15.0,
                    bottom: 10.0,
                  ),
                  child: RatingWidget(
                    rating: recommendedTravellingPlace.rating.toString(),
                  ),
                ),
                onClickCard: (){
                  Navigator.pushNamed(
                      context,
                      detailRouteName,
                      arguments: recommendedTravellingPlace
                  ).then((value) => {
                    widget.parentFunction()
                  });
                },
              ),
            );
          },
      ),
    );
  }

  Widget _getNotEnoughRatingCountWidget(){
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: InformationWidget(
        iconData: Icons.star,
        information: "Anda memerlukan minimal satu tempat wisata yang memiliki nilai rating 4 ke atas.",
        widgetWidth: 300,
      ),
    );
  }

  Widget _getRecommendationsContent(){
    List<BookmarkedTravellingPlace> goodRatedTravellingPlaces = getGoodRatedTravellingPlacesOnly();

    if (goodRatedTravellingPlaces.isEmpty){
      return _getNotEnoughRatingCountWidget();
    }

    return FutureBuilder(
      future: DataFetcher.getColabTravellingPlaces(
        goodRatedTravellingPlaces,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done){
          return _getLoadingWidget();
        }
        if (snapshot.hasError){
          return const Text(
            "Unknown Error Occured!",
          );
        }
        print("Error: ${snapshot.error}");
        List<TravellingPlace> recommendedTravellingPlaces = snapshot.data as List<TravellingPlace>;
        return _getRecommendationsWidget(
            recommendedTravellingPlaces,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      height: 320,
      title: "Rekomendasi berdasarkan rating Anda",
      contentWidget: _getRecommendationsContent(),
    );
  }
}