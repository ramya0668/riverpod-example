import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_example/characters_model.dart';

class CharacterDetailPage extends ConsumerStatefulWidget {
  int index;
  String imageLink;
  String id;
  CharacterDetailPage(
      {super.key,
      required this.index,
      required this.imageLink,
      required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CharacterDetailPageState();
}

class _CharacterDetailPageState extends ConsumerState<CharacterDetailPage> {
  final characterDetailsProvider = FutureProvider.family
      .autoDispose<CharactersModel, String>((ref, type) async {
    final response = await http
        .get(Uri.parse('https://hp-api.onrender.com/api/character/$type'));

    ref.onDispose(http.Client().close);

    print(response.body);

    return CharactersModel.fromJson(jsonDecode(response.body)[0]);
  });

  @override
  Widget build(BuildContext context) {
    final AsyncValue<CharactersModel> characterDetail =
        ref.watch(characterDetailsProvider(widget.id));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Column(children: [
          Hero(
            tag: 'imageHero${widget.index}',
            child: Image.network(
              widget.imageLink,
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
            ),
          ),
          Expanded(
            child: characterDetail.hasError
                ? const Center(child: Text("Oopss!! Something is wrong"))
                : characterDetail.hasValue
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Name: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${characterDetail.value?.name}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "DOB: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${characterDetail.value?.dateOfBirth}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "House: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${characterDetail.value?.house}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
          ),
        ]));
  }
}
