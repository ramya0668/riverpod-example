import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_example/character_detail_page.dart';
import 'package:riverpod_example/characters_model.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RiverPod Demo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'RiverPod example',
      ),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  final getCharacters = FutureProvider((ref) async {
    final response =
        await http.get(Uri.parse('https://hp-api.onrender.com/api/characters'));

    List<dynamic> listOfCharacters = jsonDecode(response.body);

    List<CharactersModel> charactersModel =
        listOfCharacters.map((e) => CharactersModel.fromJson(e)).toList();

    print('-------------------------------------- $charactersModel');

    return charactersModel;
  });

  final searchInputProvider = StateProvider<String>(
    (ref) => ' ',
  );

  final searchControllerProvider =
      StateNotifierProvider<SearchController, List>(
    (ref) => SearchController(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchInput = ref.watch(searchInputProvider);
    final AsyncValue data = ref.watch(getCharacters);
    final searchController = ref.watch(searchControllerProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(getCharacters.future);
          print('-------------------------------------- onRefresh');
        },
        child: Center(
            child: data.hasError
                ? const Center(child: Text('Oopss!!! There\'s some error'))
                : data.hasValue
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  hintText: 'Search',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7))),
                              onChanged: (value) {
                                ref
                                    .read(searchInputProvider.notifier)
                                    .update((state) => state = value);
                              },
                              onEditingComplete: () {
                                print(
                                    '-------------------------------------- ');
                                ref
                                    .read(searchControllerProvider.notifier)
                                    .onSearch(
                                        searchInput.toString(), data.value);
                              },
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: searchController.isNotEmpty
                                      ? searchController.length
                                      : data.value.length,
                                  itemBuilder: (context, index) {
                                    final user = searchController.isNotEmpty
                                        ? searchController[index]
                                        : data.value[index];
                                    return SizedBox(
                                        height: 90,
                                        child: Row(
                                          children: [
                                            '${user.image}'.isNotEmpty
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 8.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                                PageRouteBuilder(
                                                          transitionDuration:
                                                              const Duration(
                                                                  seconds: 1),
                                                          pageBuilder: (context,
                                                                  animation,
                                                                  secondaryAnimation) =>
                                                              CharacterDetailPage(
                                                            index: index,
                                                            imageLink:
                                                                '${user.image}',
                                                            id: '${user.id}',
                                                          ),
                                                        ));
                                                      },
                                                      child: ClipOval(
                                                        child: Hero(
                                                          tag:
                                                              'imageHero$index',
                                                          child: Image.network(
                                                            // 'https://picsum.photos/250?image=9',
                                                            '${user.image}',
                                                            height: 70,
                                                            width: 70,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(width: 10),
                                            Text('${user.name}'),
                                          ],
                                        ));
                                  }),
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      )),
      ),
    );
  }
}

class SearchController extends StateNotifier<List> {
  SearchController() : super([]);

  void onSearch(String searchInput, List<dynamic> data) {
    state = [];
    print('-------------------------------------- ');
    if (searchInput.isNotEmpty) {
      // for (var element in data) {
      //   print(element.name);
      // }
      final result = data
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .contains(searchInput.toString().toLowerCase()))
          .toSet()
          .toList();

      state.addAll(result);
    }
  }
}
