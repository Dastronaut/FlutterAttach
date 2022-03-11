import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

import 'package:calculator_app/widgets/my_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'TRAN KIM TIEN DAT'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String inp = '';
  String result = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.black,
      body: Column(children: [
        Container(
          alignment: Alignment.centerRight,
          height: 200,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: Text(
                  inp,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 102, 99, 99),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: Text(
                  result,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Mybutton(
              bgcolor: const Color.fromARGB(255, 85, 81, 83),
              label: 'AC',
              forcecolor: Colors.black,
              onTap: () {
                setState(() {
                  inp = '';
                  result = '';
                });
              },
            ),
            Mybutton(
              bgcolor: const Color.fromARGB(255, 85, 81, 83),
              label: '+/-',
              forcecolor: Colors.black,
              onTap: () {
                setState(() {
                  result = '-' + result;
                });
              },
            ),
            Mybutton(
              bgcolor: const Color.fromARGB(255, 85, 81, 83),
              label: '%',
              forcecolor: Colors.black,
              onTap: () {
                if (result != '') {
                  setState(() {
                    result = (double.parse(result) / 100).toString();
                    inp = result;
                  });
                }
              },
            ),
            Mybutton(
              bgcolor: Colors.orange,
              label: '/',
              forcecolor: Colors.black,
              onTap: () {
                setState(() {
                  inp += '/';
                });
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Mybutton(
              bgcolor: const Color.fromARGB(255, 48, 47, 47),
              label: '7',
              forcecolor: Colors.black,
              onTap: () {
                setState(() {
                  inp += '7';
                });
              },
            ),
            Mybutton(
              bgcolor: const Color.fromARGB(255, 48, 47, 47),
              label: '8',
              forcecolor: Colors.black,
              onTap: () {
                setState(() {
                  inp += '8';
                });
              },
            ),
            Mybutton(
              bgcolor: const Color.fromARGB(255, 48, 47, 47),
              label: '9',
              forcecolor: Colors.black,
              onTap: () {
                setState(() {
                  inp += '9';
                });
              },
            ),
            Mybutton(
              bgcolor: Colors.orange,
              label: 'x',
              forcecolor: Colors.black,
              onTap: () {
                setState(() {
                  inp += 'x';
                });
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Mybutton(
              bgcolor: const Color.fromARGB(255, 48, 47, 47),
              label: '4',
              forcecolor: Colors.black,
              onTap: () {
                setState(() {
                  inp += '4';
                });
              },
            ),
            Mybutton(
              bgcolor: const Color.fromARGB(255, 48, 47, 47),
              label: '5',
              forcecolor: Colors.black,
              onTap: () {
                setState(() {
                  inp += '5';
                });
              },
            ),
            Mybutton(
              bgcolor: const Color.fromARGB(255, 48, 47, 47),
              label: '6',
              forcecolor: Colors.black,
              onTap: () {
                setState(() {
                  inp += '6';
                });
              },
            ),
            Mybutton(
              bgcolor: Colors.orange,
              label: '-',
              forcecolor: Colors.black,
              onTap: () {
                setState(() {
                  inp += '-';
                });
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Mybutton(
              bgcolor: const Color.fromARGB(255, 48, 47, 47),
              label: '1',
              forcecolor: Colors.black,
              onTap: () {
                setState(() {
                  inp += '1';
                });
              },
            ),
            Mybutton(
              bgcolor: const Color.fromARGB(255, 48, 47, 47),
              label: '2',
              forcecolor: Colors.black,
              onTap: () {
                setState(() {
                  inp += '2';
                });
              },
            ),
            Mybutton(
              bgcolor: const Color.fromARGB(255, 48, 47, 47),
              label: '3',
              forcecolor: Colors.black,
              onTap: () {
                setState(() {
                  inp += '3';
                });
              },
            ),
            Mybutton(
              bgcolor: Colors.orange,
              label: '+',
              forcecolor: Colors.black,
              onTap: () {
                setState(() {
                  inp += '+';
                });
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Mybutton(
              bgcolor: const Color.fromARGB(255, 48, 47, 47),
              label: '0',
              forcecolor: Colors.black,
              onTap: () {
                setState(() {
                  inp += '0';
                });
              },
            ),
            Mybutton(
              bgcolor: const Color.fromARGB(255, 48, 47, 47),
              label: '00',
              forcecolor: Colors.black,
              onTap: () {
                setState(() {
                  inp += '00';
                });
              },
            ),
            Mybutton(
              bgcolor: const Color.fromARGB(255, 48, 47, 47),
              label: '.',
              forcecolor: Colors.black,
              onTap: () {
                setState(() {
                  inp += '.';
                });
              },
            ),
            Mybutton(
              bgcolor: Colors.orange,
              label: '=',
              forcecolor: Colors.black,
              onTap: () {
                String finalinput = inp.replaceAll('x', '*');

                Parser p = Parser();
                Expression exp = p.parse(finalinput);
                ContextModel cm = ContextModel();
                double eval = exp.evaluate(EvaluationType.REAL, cm);
                setState(() {
                  result = eval.toString();
                });
              },
            ),
          ],
        ),
      ], mainAxisAlignment: MainAxisAlignment.spaceAround),
    );
  }
}
