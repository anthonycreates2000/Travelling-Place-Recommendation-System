import 'package:flutter/material.dart';

class HorizontalItemWidget extends StatelessWidget{
  final String titleText;
  final String subtitleText;
  final double width;
  final double height;
  final Function onClickCard;
  final Widget additionalWidget;
  final Widget? topRightWidget;
  final int maxLines;

  const HorizontalItemWidget({
    Key? key,
    required this.titleText,
    required this.subtitleText,
    this.width = double.infinity,
    this.topRightWidget,
    required this.height,
    required this.onClickCard,
    required this.additionalWidget,
    this.maxLines = 1,
  }) : super(key: key);

   Widget getSummaryWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
          ),
          child: Text(
            titleText,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
          ),
          child: Text(
            subtitleText,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            maxLines: maxLines,
          ),
        ),
        additionalWidget
      ],
    );
  }

  Widget _getChildCardWidget(Widget childWidget){
     if (topRightWidget != null){
       return Row(
         children: [
           Expanded(
             flex: 2,
             child: childWidget
           ),
           Expanded(
             flex: 1,
             child: topRightWidget!,
           ),
         ]
       );
     }
     return childWidget;
  }

  Widget getCardWidget(Widget childWidget){
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0)
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Colors.black12,
            spreadRadius: 0,
            blurRadius: 5
          )
        ]
      ),
      child: Column(
        children: [
          _getChildCardWidget(childWidget),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getCardWidget(
      TextButton(
        onPressed: (){
          onClickCard();
        },
        style: TextButton.styleFrom(
            primary: Colors.black
        ),
        child: getSummaryWidget()
      )
    );
  }
}