import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_forecast/common/theme_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late LocationPermission permission;
  late Position _position;

  @override
  void initState() {
    super.initState();
    getUserPermission();
    getCurrentLocation();
  }

  getUserPermission() async {
    permission = await Geolocator.requestPermission();
    print(permission);
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      _position = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sunny.jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: Column(children: [
          _location(),
          _temperature(),
          _decription(),
          _rangeTemperature(),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            height: 200,
            width: MediaQuery.of(context).size.width - 20,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            decoration: ThemeHelper().informationBoxDecoration(),
            child: Text(_position.latitude.toString() +
                ', ' +
                _position.longitude.toString()),
          ),
        ]),
      ),
    );
  }
}

_location() {
  return const Text(
    'Da Nang',
    style: TextStyle(fontSize: 28),
  );
}

_temperature() {
  return const Text(
    '31',
    style: TextStyle(fontSize: 100),
  );
}

_decription() {
  return const Text(
    'Troi nang',
    style: TextStyle(fontSize: 22),
  );
}

_rangeTemperature() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      Text(
        'C: 34',
        style: TextStyle(fontSize: 18),
      ),
      Text(
        'T: 26',
        style: TextStyle(fontSize: 18),
      ),
    ],
  );
}

// _hourlyForecast(BuildContext context) {
//   return Container(
//     margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//     height: 200,
//     width: MediaQuery.of(context).size.width - 20,
//     padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
//     decoration: ThemeHelper().informationBoxDecoration(),
//     child: Text(
//         _position.latitude.toString() + ', ' + _position.longitude.toString()),
//   );
// }
