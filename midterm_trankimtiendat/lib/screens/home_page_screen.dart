import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:midterm_trankimtiendat/components/location_model.dart';
import 'package:midterm_trankimtiendat/screens/custom_search_delegate.dart';
import 'package:midterm_trankimtiendat/screens/location_detail_page.dart';

Future<List<Locations>> fetchPost() async {
  final response = await http
      .get(Uri.parse('http://staff.vnuk.edu.vn:5000/static/data/data.json'));

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body).cast<Map<String?, dynamic>>();
    print("Parsed");
    print(parsed);
    final locations =
        parsed.map<Locations>((json) => Locations.fromJson(json)).toList();
    print("Parsed");
    print(parsed);
    return locations;
  } else {
    throw Exception('Failed to load Locations');
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Locations>> futurePost;

  void remove_item(futurePost, index) {
    setState(() {
      futurePost.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Tran Kim Tien Dat'),
        actions: [
          IconButton(
            onPressed: () async {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(locations: await futurePost),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: FutureBuilder<List<Locations>>(
        future: futurePost,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shadowColor: Colors.black87,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onLongPress: () => {remove_item(snapshot.data, index)},
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationDetailPage(
                          location: snapshot.data![index],
                        ),
                      ),
                    ),
                  },
                  child: Table(
                    columnWidths: const {1: FractionColumnWidth(.7)},
                    children: [
                      TableRow(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text('Title: '),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              snapshot.data![index].title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text('Desc: '),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              snapshot.data![index].desc,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text('Timestamp: '),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              snapshot.data![index].timeStamp,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
