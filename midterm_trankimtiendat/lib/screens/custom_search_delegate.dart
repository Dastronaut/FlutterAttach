import 'package:flutter/material.dart';
import 'package:midterm_trankimtiendat/components/location_model.dart';
import 'package:midterm_trankimtiendat/screens/location_detail_page.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<Locations> locations;
  CustomSearchDelegate({
    required this.locations,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Locations> matchQuery = [];
    for (Locations location in locations) {
      if (location.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(location);
      }
    }

    if (matchQuery.isNotEmpty) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationDetailPage(
                    location: matchQuery[index],
                  ),
                ),
              ),
            },
            child: Card(
              clipBehavior: Clip.antiAlias,
              shadowColor: Colors.black87,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Table(
                    columnWidths: const {1: FractionColumnWidth(.7)},
                    children: [
                      TableRow(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              matchQuery[index].title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              matchQuery[index].desc,
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
                              matchQuery[index].desc,
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
                              matchQuery[index].timeStamp,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Locations> matchQuery = [];
    for (Locations location in locations) {
      if (location.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(location);
      }
    }

    if (matchQuery.isNotEmpty) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationDetailPage(
                    location: matchQuery[index],
                  ),
                ),
              ),
            },
            child: Card(
              clipBehavior: Clip.antiAlias,
              shadowColor: Colors.black87,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Table(
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
                              matchQuery[index].title,
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
                              matchQuery[index].desc,
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
                              matchQuery[index].timeStamp,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
