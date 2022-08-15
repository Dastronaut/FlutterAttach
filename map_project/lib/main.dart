import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_project/location_model.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Position? _currentPosition;
  final DatabaseReference positionRef =
      FirebaseDatabase.instance.ref('position');

  void _getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    setState(() {
      _currentPosition = position;
      print(_currentPosition);
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _initialView = CameraPosition(
    target: LatLng(16.049640, 108.202757),
    zoom: 11.1,
  );
  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: positionRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.snapshot.value;
            final Location _targetPosition =
                Location(lon: (data as Map)['lon'], lat: (data)['lat']);

            return GoogleMap(
              mapType: MapType.hybrid,
              markers: {
                _currentPosition != null
                    ? Marker(
                        markerId: const MarkerId('start'),
                        icon: BitmapDescriptor.defaultMarker,
                        position: LatLng(_currentPosition!.latitude,
                            _currentPosition!.longitude),
                      )
                    : const Marker(markerId: MarkerId('start')),
                Marker(
                  markerId: const MarkerId('end'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
                  position: LatLng(_targetPosition.lat, _targetPosition.lon),
                )
              },
              initialCameraPosition: _initialView,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'My location',
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.my_location_outlined,
          color: Colors.black,
        ),
        onPressed: _getCurrentPosition,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }
}
