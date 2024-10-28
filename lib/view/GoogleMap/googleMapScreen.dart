import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prestige_vender/utils/widget.dart';

class GoogleMapScreen extends StatefulWidget {
  List<double> coordinates;
  String shopName;
  GoogleMapScreen({required this.coordinates,required this.shopName, Key? key}) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}
class _GoogleMapScreenState extends State<GoogleMapScreen> {
  @override
  void initState() {
    currentmarker();
    // TODO: implement initState
    super.initState();
  }
  
  Set<Marker> markersList = {};
  currentmarker() {
    markersList.clear(); // Clear existing markers
    markersList.add(Marker(
      markerId: const MarkerId("0"),
      position: LatLng(widget.coordinates[0], widget.coordinates[1]),
      infoWindow:  InfoWindow(title: widget.shopName),

    ));
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("coordinates: ${widget.coordinates} ${widget.shopName}");
    }
    return Scaffold(
      appBar: AppBar(title:  text(widget.shopName),),
      body: Stack(
        children: [
          // GoogleMap widget to display the map
          GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(widget.coordinates[0], widget.coordinates[1]),
                zoom: 15.0,
                ),
                mapType: MapType.normal,
            markers: markersList,
            onMapCreated: (GoogleMapController controller) {},
          ),
        ],
      ),
    );
  }
}
