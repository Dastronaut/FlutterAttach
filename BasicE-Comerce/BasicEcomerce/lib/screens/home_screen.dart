import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<WordPair> _words = <WordPair>[];
  final Set<WordPair> _favList = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  void _pushSaved() {
    Navigator.of(context)
        .push(new MaterialPageRoute<void>(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _favList.map((WordPair pair) {
        return new ListTile(
          title: new Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });
      final List<Widget> divided =
          ListTile.divideTiles(tiles: tiles, context: context).toList();

      return new Scaffold(
        appBar: new AppBar(
          title: const Text("Fovorite List"),
        ),
        body: new ListView(
          children: divided,
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example with Stateful'),
        leading: IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Navigation menu',
            onPressed: () {}),
        actions: [
          IconButton(
              tooltip: 'Favorite List',
              icon: const Icon(Icons.favorite),
              onPressed: _pushSaved),
          IconButton(
            onPressed: null,
            icon: const Icon(Icons.search),
            tooltip: 'Search',
          ),
          PopupMenuButton<Text>(itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text("1st"),
              ),
              PopupMenuItem(
                child: Text("2nd"),
              ),
              PopupMenuItem(
                child: Text("3rd"),
              ),
            ];
          })
        ],
      ),
      body: Center(child: ListView.builder(itemBuilder: (context, index) {
        if (index.isOdd) return Divider();
        if (index >= _words.length) {
          _words.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_words[index]);
      })),
      floatingActionButton: const FloatingActionButton(
        tooltip: 'Add',
        child: Icon(Icons.arrow_upward),
        onPressed: null,
      ),
    );
  }

  Widget _buildRow(WordPair wordPair) {
    final bool alreadySaved = _favList.contains(wordPair);
    return ListTile(
      title: Text(
        wordPair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new IconButton(
        icon: alreadySaved ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
        color: alreadySaved ? Colors.red : null,
        onPressed: () {
          setState(() {
            if (alreadySaved) {
              _favList.remove(wordPair);
            } else {
              _favList.add(wordPair);
            }
          });
        },
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _favList.remove(wordPair);
          } else {
            _favList.add(wordPair);
          }
        });
      },
    );
  }
}
