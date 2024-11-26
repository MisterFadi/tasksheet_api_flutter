import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

const dummyFacts = "https://dummyjson.com/products";
Future<String> magicFacts() async {
  final http.Response response = await http.get(Uri.parse(dummyFacts));
  if (response.statusCode == 200) {
    final String data = response.body;

    final Map<String, dynamic> decodedJson = jsonDecode(data);

    final String dummyProducts = decodedJson["products"][4]["title"];

    return dummyProducts;
  } else {
    return Future.error("Error");
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Future<String>? _magicFactsFuture;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange.shade200,
          title: const Text(
            "API Flutter",
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              SizedBox(
                height: 350,
                child: FutureBuilder<String>(
                  future: _magicFactsFuture,
                  builder: (context, snapshot) {
                    String newDummyFacts = "";
                    if (snapshot.hasError) {
                      newDummyFacts =
                          "Es ist ein Fehler aufgetreten : ${snapshot.error}";
                      return Text(newDummyFacts);
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      newDummyFacts = snapshot.data!;
                      return Text(newDummyFacts);
                    }
                    return const Text("Noch keine Daten vorhanden");
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _magicFactsFuture = magicFacts();
                  });
                },
                child: const Text(
                  "Press Button",
                  style: TextStyle(fontSize: 25),
                ),
              )
            ],
          ),
        ),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}
