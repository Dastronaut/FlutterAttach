import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CurrentLocation(),
    );
  }
}

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({Key? key}) : super(key: key);
  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  late String currentLocation;
  @override
  void initState() {
    super.initState();
  }

  late Position position;
  void _getCurrentLocation() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          currentLocation = "Permission Denied";
        });
      } else {
        var position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          currentLocation = "latitude: ${position.latitude}" +
              " , " +
              "Logitude: ${position.longitude}";
        });
      }
    } else {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentLocation = "latitude: ${position.latitude}" +
            " , " +
            "Logitude: ${position.longitude}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                decoration: BoxDecoration(color: Colors.teal[50]),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(Icons.location_on),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Location',
                              ),
                              (currentLocation != null)
                                  ? Text(currentLocation)
                                  : Container(),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ],
                )),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Get Location"),
            )
          ],
        ),
      ),
    );
  }
}
