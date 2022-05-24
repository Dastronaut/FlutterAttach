import 'package:flutter/material.dart';
import 'package:test_thi_gk/components/dog_model.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<Dog> doggies;
  CustomSearchDelegate({
    required this.doggies,
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
    List<Dog> matchQuery = [];
    for (Dog dog in doggies) {
      if (dog.name!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(dog);
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => DogDetailPage(
              //       dog: matchQuery[index],
              //     ),
              //   ),
              // ),
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
                  Expanded(
                    flex: 2,
                    child: Ink.image(
                      image: NetworkImage(matchQuery[index].url!),
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(matchQuery[index].name!),
                            flex: 9,
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: const Icon(
                                Icons.favorite_sharp,
                                color: Colors.black54,
                              ),
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                      subtitle: Text(matchQuery[index].bredFor != null
                          ? matchQuery[index].bredFor!
                          : ''),
                    ),
                  )
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
    List<Dog> matchQuery = [];
    for (Dog dog in doggies) {
      if (dog.name!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(dog);
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => DogDetailPage(
              //       dog: matchQuery[index],
              //     ),
              //   ),
              // ),
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
                  Expanded(
                    flex: 2,
                    child: Ink.image(
                      image: NetworkImage(matchQuery[index].url!),
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(matchQuery[index].name!),
                            flex: 9,
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: const Icon(
                                Icons.favorite_sharp,
                                color: Colors.black54,
                              ),
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                      subtitle: Text(matchQuery[index].bredFor != null
                          ? matchQuery[index].bredFor!
                          : ''),
                    ),
                  )
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
