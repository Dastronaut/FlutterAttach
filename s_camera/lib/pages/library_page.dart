import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:s_camera/pages/image_page.dart';
import 'package:s_camera/utils/firebase_api.dart';
import 'package:s_camera/utils/firebase_file.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseApi.listAll("StorageData/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<FirebaseFile>>(
      future: futureFiles,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final files = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    return buildFile(context, file);
                  },
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              buildHeader(files.length),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    ));
  }

  Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
        contentPadding: const EdgeInsets.all(2.0),
        leading: Image.network(
          file.url,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        title: Text(
          file.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            color: Colors.blue,
          ),
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ImagePage(file: file),
        )),
        onLongPress: () async{
          await Delete(file);
          //file.ref.delete();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image deleted Successfully")));

        }

  );
  Future<void> Delete(FirebaseFile file)async{
    await file.ref.delete();
    setState(() {

    });
  }
  Widget buildHeader(int length) => ListTile(
        tileColor: Colors.white,
        leading: const SizedBox(
          width: 52,
          height: 52,
          child: Icon(
            Icons.file_copy,
            color: Colors.black54,
          ),
        ),
        title: Center(
          child: Text(
            "$length Images",
            style: const TextStyle(
              // fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black54,
            ),
          ),
        ),
      );
}
