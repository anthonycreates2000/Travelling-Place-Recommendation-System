import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget{
  MapWidget({
    Key? key,
    required this.latitude,
    required this.longitude,
    this.zoom = 15,
  }): super(key: key);

  double latitude;
  double longitude;
  double zoom;

  @override
  State<StatefulWidget> createState() => _MapSampleState();
}

class _MapSampleState extends State<MapWidget>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LatLng point = LatLng(
        widget.latitude, widget.longitude
    );
    return FlutterMap(
      options: MapOptions(
        center: point,
        zoom: widget.zoom,
      ),
      layers: [
        MarkerLayerOptions(
          markers: [
            Marker(
              point: point,
              builder: (ctx) => const Icon(
                Icons.fmd_good,
                color: Colors.redAccent,
                size: 20.0,
              ),
            )
          ]
        ),
      ],
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap contributors',
          onSourceTapped: null,
        ),
      ],
      children: [
        TileLayerWidget(
          options: TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
        ),
      ],
    );
  }}