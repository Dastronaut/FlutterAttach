import 'package:doggies_api/screens/custom_search_delegate.dart';
import 'package:doggies_api/screens/dog_detail_page.dart';
import 'package:doggies_api/services/dog_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<List<Dog>> fetchPost() async {
  final response = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/DevTides/DogsApi/master/dogs.json'));

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

    return parsed.map<Dog>((json) => Dog.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load album');
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Dog>> futurePost;
  List<bool> data = List.filled(500, false, growable: true);

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
                delegate: CustomSearchDelegate(doggies: await futurePost),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: FutureBuilder<List<Dog>>(
        future: futurePost,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => Card(
                clipBehavior: Clip.antiAlias,
                shadowColor: Colors.black87,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: InkWell(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DogDetailPage(
                          dog: snapshot.data![index],
                        ),
                      ),
                    ),
                  },
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Ink.image(
                          image: NetworkImage(snapshot.data![index].url!),
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
                                child: Text(snapshot.data![index].name!),
                                flex: 9,
                              ),
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.favorite_sharp,
                                    color: !data[index]
                                        ? Colors.black54
                                        : Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      data[index] = !data[index];
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                          subtitle: Text(snapshot.data![index].bredFor != null
                              ? snapshot.data![index].bredFor!
                              : ''),
                        ),
                      )
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
