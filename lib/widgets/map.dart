import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/api/places_api.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final Marker _kGooglePlexMarker = const Marker(
      infoWindow: InfoWindow(title: "My Marker"),
      position: LatLng(37.42796133580664, -122.085749655962),
      markerId: MarkerId('_KGooglePlexMarker'));

  static const CameraPosition _kLake = CameraPosition(
      bearing: 210.8334901395799,
      target: LatLng(33.651592, 73.156456),
      tilt: 70.440717697143555,
      zoom: 19.151926040649414);

  final Marker _kLakeMarker = Marker(
      infoWindow: const InfoWindow(title: "Lake"),
      position: const LatLng(33.651592, 73.156456),
      markerId: const MarkerId('LakeMarker'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));

  static const Polyline _kPolyLine = Polyline(
      polylineId: PolylineId('MyPolyLine'),
      points: [
        LatLng(37.42796133580664, -122.085749655962),
        LatLng(33.651592, 73.156456)
      ],
      width: 5);

  late TextEditingController current;
  @override
  void initState() {
    current = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map App"),
      ),
      body: Column(
        children: [
          Container(
            height: 175,
            child: Column(
              children: [
                TextFormField(
                  controller: current,
                  decoration: const InputDecoration(
                    hintText: "Enter location",
                    labelText: "Enter current location",
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter location",
                    labelText: "Enter Destination",
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      var place =
                          await Places().getPlace(current.text.toString());
                    },
                    icon: Icon(CupertinoIcons.search))
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              markers: {_kLakeMarker, _kGooglePlexMarker},
              initialCameraPosition: _kGooglePlex,
              polylines: {_kPolyLine},
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To COMSATS!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
