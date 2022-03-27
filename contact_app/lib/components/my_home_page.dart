import 'package:flutter/material.dart';

import 'package:contact_app/components/contac_argument.dart';
import 'package:contact_app/services/DatabaseHandler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DatabaseHandler handler;

  void _navigateAddContactPage(BuildContext context) async {
    final result = await Navigator.pushNamed(
      context,
      'add_contact_page',
    ) as Contact;
    if (!result.isNull()) {
      handler = DatabaseHandler();
      handler.initializeDB().whenComplete(() async {
        await handler.insertContact(result);
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      await handler.retrieveContacts();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tran Kim Tien Dat"),
      ),
      body: FutureBuilder(
        future: handler.retrieveContacts(),
        builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: const Icon(Icons.delete_forever),
                  ),
                  key: ValueKey<int>(snapshot.data![index].id!),
                  onDismissed: (DismissDirection direction) async {
                    await handler.deleteContact(snapshot.data![index].id!);
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    });
                  },
                  child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8.0),
                      title: Text(snapshot.data![index].name),
                      subtitle: Text(snapshot.data![index].numphone),
                      leading: const Icon(Icons.person),
                      iconColor: Colors.blue,
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateAddContactPage(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
