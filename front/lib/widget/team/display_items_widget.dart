// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/config/palette.dart';
import 'package:front/model/item_model.dart';
import 'package:front/model/items_model.dart';
import 'package:front/model/poke_strat_model.dart';
import 'package:http/http.dart' as http;

import '../display_loader.dart';

class DisplayItemWidgets extends StatefulWidget {
  final PokeStrat poke;
  const DisplayItemWidgets({Key? key, required this.poke}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<DisplayItemWidgets> createState() => _DisplayItemWidgetsState(poke);
}

class _DisplayItemWidgetsState extends State<DisplayItemWidgets> {
  Item _item = Item(name: "null", description: "null");

  _DisplayItemWidgetsState(PokeStrat poke) {
    if (poke.item != "") {
      _item.name = poke.item!;
    }
  }

  Future<Items> _dataItems() async {
    final response = await rootBundle.loadString('assets/json/items.json');
    final jsonResponse = json.decode(response);
    Items items = Items.fromJson(jsonResponse);
    var responseApi = await http
        .get(Uri.parse("https://pokeapi.co/api/v2/item/?limit=10000"));
    if (responseApi.statusCode == 200) {
      final jsonResponseApi = jsonDecode(responseApi.body);
      items.addSprites(jsonResponseApi);
    }
    return items;
  }

  Future<Item> _getItem(String name) async {
    final response = await rootBundle.loadString('assets/json/items.json');
    final jsonResponse = json.decode(response);
    Item item = Item.fromJson(jsonResponse, name);
    var responseApi = await http
        .get(Uri.parse("https://pokeapi.co/api/v2/item/?limit=10000"));
    if (responseApi.statusCode == 200) {
      final jsonResponseApi = jsonDecode(responseApi.body);
      item.addUrlFromJSon(jsonResponseApi);
      var responseApi2 = await http.get(Uri.parse(item.url!));
      final jsonResponseApiUrl = jsonDecode(responseApi2.body);
      item.addSprites(jsonResponseApiUrl);
    }
    return item;
  }

  Future<Item> _addSprites(Item item) async {
    var responseApi = await http.get(Uri.parse(item.url!));
    final jsonResponseApiUrl = jsonDecode(responseApi.body);
    item.addSprites(jsonResponseApiUrl);
    return item;
  }

  ListTile listTileitem(Item item) {
    return ListTile(
      leading: Image.network(
        item.sprites!,
      ),
      title: Text(
        item.name,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      subtitle: Text(item.description,
          style: const TextStyle(color: Colors.white, fontSize: 15)),
    );
  }

  late TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          const BoxConstraints(minHeight: 500, minWidth: double.infinity),
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder<Items>(
              future: _dataItems(),
              builder: (BuildContext context, AsyncSnapshot<Items> snapshot) {
                Items? items = snapshot.data;
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: DisplayLoader(size: 40));
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text(
                        '${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      );
                    } else {
                      return Column(
                        children: [
                          if (_item.name != "null")
                            Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    color: Palette.kToDark.shade600,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FutureBuilder<Item>(
                                        future: _getItem(_item.name),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<Item> snapshot) {
                                          Item? item = snapshot.data;
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return const Center(
                                                  child:
                                                      DisplayLoader(size: 40));
                                            case ConnectionState.done:
                                              if (snapshot.hasError) {
                                                return Text(
                                                  '${snapshot.error}',
                                                  style: const TextStyle(
                                                      color: Colors.red),
                                                );
                                              } else {
                                                return listTileitem(item!);
                                              }

                                            default:
                                              return const Text("");
                                          }
                                        }),
                                  ),
                                )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Autocomplete<Item>(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                List<Item> listItems =
                                    items!.items!.where((Item option) {
                                  return option.name.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase());
                                }).toList();
                                if (listItems.length > 3) {
                                  return listItems.sublist(0, 3);
                                }
                                return listItems;
                              },
                              displayStringForOption: (Item option) =>
                                  option.name,
                              onSelected: (value) => {
                                setState(() {
                                  _item = value;
                                }),
                                _getItem(value.name),
                                widget.poke.item = value.name
                              },
                              optionsViewBuilder: (context,
                                  Function(Item) onSelected, options) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    elevation: 4,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height: 300,
                                      color: Palette.kToDark.shade500,
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          Item option =
                                              options.elementAt(index);
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: FutureBuilder<Item>(
                                                  future: _addSprites(option),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<Item>
                                                              snapshot) {
                                                    switch (snapshot
                                                        .connectionState) {
                                                      case ConnectionState
                                                          .waiting:
                                                        return const Center(
                                                            child:
                                                                DisplayLoader(
                                                                    size: 40));
                                                      case ConnectionState.done:
                                                        if (snapshot.hasError) {
                                                          return Text(
                                                            '${snapshot.error}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                          );
                                                        } else {
                                                          return ListTile(
                                                            leading:
                                                                Image.network(
                                                              option.sprites!,
                                                            ),
                                                            title: Text(
                                                              option.name,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20),
                                                            ),
                                                            subtitle: Text(
                                                                option
                                                                    .description,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15)),
                                                            onTap: () {
                                                              onSelected(
                                                                  option);
                                                            },
                                                          );
                                                        }

                                                      default:
                                                        return const Text("");
                                                    }
                                                  }));
                                        },
                                        separatorBuilder: (context, index) =>
                                            const Divider(),
                                        itemCount: options.length,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              fieldViewBuilder: (context, controller, focusNode,
                                  onFieldSubmitted) {
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  onEditingComplete: onFieldSubmitted,
                                  autofocus: false,
                                  style: const TextStyle(
                                      color: Color(0xFFFAFAFAf)),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.search),
                                    labelText: 'Item name',
                                    labelStyle:
                                        TextStyle(color: Color(0xFFFAFAFAf)),
                                    fillColor: Color(0xFF333333f),
                                    filled: true,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFCF1B1B)),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  default:
                    return const Text('');
                }
              })),
    );
  }
}
