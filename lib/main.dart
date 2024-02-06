import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_example/characters_model.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final getCharacters = FutureProvider((ref) async {
  final response =
      await http.get(Uri.parse('https://hp-api.onrender.com/api/characters'));

  List<dynamic> listOfCharacters = jsonDecode(response.body);

  List<CharactersModel> charactersModel =
      listOfCharacters.map((e) => CharactersModel.fromJson(e)).toList();

  return charactersModel;
});

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            final AsyncValue data = ref.watch(getCharacters);

            return data.hasError
                ? const Center(child: Text('Oopss!!! There\'s some error'))
                : data.hasValue
                    ? ListView.builder(
                        itemCount: data.value.length,
                        itemBuilder: (context, index) =>
                            Text('${data.value[index].actor}'),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
          },
        ),
      ),
    );
  }
}
