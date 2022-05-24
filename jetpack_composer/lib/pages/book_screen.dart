import 'package:flutter/material.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({Key? key}) : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  TextEditingController totalController = TextEditingController(text: '');
  double _total = 0.0;
  int _person = 1;
  double _tip = 0;

  bool _showTip = false;
  final TextStyle _style =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          color: Colors.pink[200],
          child: Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Total Per Person',
                style: _style,
              ),
              Text(
                '\$ ' + _total.toStringAsFixed(2),
                style: _style,
              )
            ]),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black12,
              width: 4,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: Column(children: [
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20),
                labelText: 'Enter Bill',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              controller: totalController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _total =
                        (double.parse(totalController.text) / _person) + _tip;
                  });
                } else {
                  setState(() {
                    _total += _tip;
                  });
                }
              },
              onTap: () {
                setState(() {
                  _showTip = true;
                });
              },
              onFieldSubmitted: (value) {
                setState(() {
                  _showTip = false;
                });
              },
            ),
            const SizedBox(
              height: 8,
            ),
            Visibility(
              child: Column(
                children: [
                  Table(
                    defaultColumnWidth: FixedColumnWidth(
                        (MediaQuery.of(context).size.width - 40) / 4),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        Text(
                          'Split',
                          style: _style,
                        ),
                        ElevatedButton(
                          child: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              _person += 1;
                            });
                            if (_total > 0) {
                              setState(() {
                                _total = (double.parse(totalController.text) /
                                        _person) +
                                    _tip;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(20, 20),
                            shape: const CircleBorder(),
                          ),
                        ),
                        Text(
                          _person.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                        ElevatedButton(
                          child: const Icon(Icons.horizontal_rule_rounded),
                          onPressed: () {
                            if (_person > 1) {
                              setState(() {
                                _person -= 1;
                              });
                            }
                            if (_total > 0) {
                              setState(() {
                                _total = (double.parse(totalController.text) /
                                        _person) +
                                    _tip;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(20, 20),
                            shape: const CircleBorder(),
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Text(
                          'Tip',
                          style: _style,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          _tip.toStringAsFixed(1) + ' \$',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                      ]),
                    ],
                  ),
                  Slider(
                    value: _tip,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: _tip.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _tip = value;
                        _total =
                            (double.parse(totalController.text) / _person) +
                                _tip;
                      });
                    },
                  ),
                ],
              ),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: _showTip,
            ),
          ]),
        )
      ],
    );
  }
}
