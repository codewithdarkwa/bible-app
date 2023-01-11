import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: BibleVerseWidget(),
        ),
      ),
    );
  }
}

class BibleVerseWidget extends StatefulWidget {
  @override
  _BibleVerseWidgetState createState() => _BibleVerseWidgetState();
}

class _BibleVerseWidgetState extends State<BibleVerseWidget> {
  // Declare the variables that will hold the user's input
  String _book = '';
  String _chapter = '';
  String _verse = '';
  String _translation = 'kjv';
  late Future<String?> _verseFuture = Future.value(null);
  Future<String?> fetchBibleVerse() async {
    final url = 'https://bible-api.com/$_book $_chapter:$_verse';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['text'];
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Book'),
              onChanged: (value) {
                setState(() {
                  _book = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Chapter'),
              onChanged: (value) {
                setState(() {
                  _chapter = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Verse'),
              onChanged: (value) {
                setState(() {
                  _verse = value;
                });
              },
            ),
          ),
          DropdownButton<String>(
            value: _translation,
            items: const [
              DropdownMenuItem(
                value: 'kjv',
                child: Text('KJV'),
              ),
              DropdownMenuItem(
                value: 'esv',
                child: Text('ESV'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _translation = value!;
              });
            },
          ),
          ElevatedButton(
            child: const Text('Fetch verse'),
            onPressed: () {
              final future = fetchBibleVerse();
              setState(() {
                _verseFuture = future;
              });
            },
          ),
          FutureBuilder(
            future: _verseFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Text(
                snapshot.data!,
                style: const TextStyle(
                  fontSize: 20,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
