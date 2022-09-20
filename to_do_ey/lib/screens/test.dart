import 'package:flutter/material.dart';

class TestAnimatedContainer extends StatefulWidget {
  const TestAnimatedContainer({Key? key}) : super(key: key);

  @override
  State<TestAnimatedContainer> createState() => _TestAnimatedContainerState();
}

class _TestAnimatedContainerState extends State<TestAnimatedContainer> {
  final double _height = 220;
  double _width = 275;
  bool isAnimated = false;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Test'),
        centerTitle: true,
        backgroundColor: Colors.yellow,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        width: MediaQuery.of(context).size.width,
        child: Row(children: [
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: screenSize.width - _width,
            height: _height,
            child: Column(children: [
              Container(
                color: Colors.red[100],
                height: 100,
              ),
              Container(
                color: Colors.red[500],
                height: 120,
              )
            ]),
          ),
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: _width,
            height: _height,
            child: Column(children: [
              Container(
                color: Colors.green[300],
                height: 100,
              ),
              Container(
                color: Colors.green[900],
                height: 120,
              )
            ]),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isAnimated ? _width = 275 : _width = screenSize.width;
            isAnimated = !isAnimated;
          });
        },
      ),
    );
  }
}
