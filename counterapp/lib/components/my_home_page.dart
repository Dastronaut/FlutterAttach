import 'package:flutter/material.dart';
import 'item_arguments.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _count = 0;
  final List<int> items = [];

  void _setCountUp() {
    setState(() {
      _count++;
      items.add(_count);
    });
  }

  void _setCountDown() {
    setState(() {
      _count--;
      items.add(_count);
    });
  }

  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _navigateDetailScreen(BuildContext context, int index) async {
    final result = await Navigator.pushNamed(
      context,
      '/detail_screen',
      arguments: ItemArguments(index, items[index]),
    ) as ItemArguments;
    setState(() {
      items[index] = result.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Counter App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Ban da bam so lan:'),
                Text(
                  '$_count',
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.green[300],
                  shadowColor: Colors.pink,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.filter),
                        title: Text(items[index].toString()),
                        subtitle: Text(index.toString()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _navigateDetailScreen(context, index);
                            },
                            child: const Text('Edit'),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              removeItem(index);
                            },
                            child: const Text('Delete'),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
                // return OutlinedButton(
                //   onPressed: () async {
                //     _navigateDetailScreen(context, index);
                //   },
                //   child: Center(child: Text(items[index].toString())),
                // );
              },
              itemCount: items.length,
              padding: const EdgeInsets.all(8),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: _setCountDown,
                child: const Icon(Icons.horizontal_rule),
              ),
              FloatingActionButton(
                onPressed: _setCountUp,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
