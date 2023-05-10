import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokemon/controllers/poke_controller.dart';
import 'package:pokemon/model/poke_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:pokemon/screens/home/pokemon_detail_screen.dart';

class Home extends StatelessWidget {
  Home({super.key});
  static String routeName = "/Home";
  final _pageController = PageController(initialPage: 2);

  int maxCount = 5;

  /// widget list
  final List<Widget> bottomBarPages = [
    const Page1(),
    const Page2(),
    const Page3(),
    const Page4(),
    const Page5(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barra de navegación lateral'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menú de opciones'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Opción 1'),
              onTap: () {
                // acción al presionar la opción 1
              },
            ),
            ListTile(
              title: Text('Opción 2'),
              onTap: () {
                // acción al presionar la opción 2
              },
            ),
            ListTile(
              title: Text('Opción 3'),
              onTap: () {
                // acción al presionar la opción 3
              },
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              pageController: _pageController,
              color: Colors.white,
              showLabel: false,
              notchColor: Colors.black87,
              bottomBarItems: [
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 1',
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.star,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.star,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 2',
                ),

                ///svg example
                BottomBarItem(
                  inActiveItem: SvgPicture.asset(
                    'assets/search_icon.svg',
                    color: Colors.blueGrey,
                  ),
                  activeItem: SvgPicture.asset(
                    'assets/search_icon.svg',
                    color: Colors.white,
                  ),
                  itemLabel: 'Page 3',
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.settings,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.settings,
                    color: Colors.pink,
                  ),
                  itemLabel: 'Page 4',
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.person,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.person,
                    color: Colors.yellow,
                  ),
                  itemLabel: 'Page 5',
                ),
              ],
              onTap: (index) {
                /// control your animation using page controller
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                );
              },
            )
          : null,
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.yellow, child: const Center(child: Text('Page 1')));
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green, child: const Center(child: Text('Page 2')));
  }
}

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  late Future<PokeModel> _pokeDataModel;

  @override
  void initState() {
    super.initState();
    _pokeDataModel = PokeController().getData();
    fetchPokemonData();
  }

  var pokeApi =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
  late List<dynamic> pokedexthis = [];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: -50,
              right: -50,
              child: Image.asset(
                'assets/images/pokeball.png',
                width: 200,
                fit: BoxFit.fitWidth,
              )),
          Positioned(
            top: 80,
            left: 20,
            child: Text(
              "PokeDex",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Positioned(
            top: 150,
            bottom: 0,
            width: width,
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder<PokeModel>(
                    future: _pokeDataModel,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final pokedex = snapshot.data!.pokemon;

                        return GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 1.4,
                          children: List.generate(pokedex.length, (index) {
                            final pokemon = pokedex[index];
                            final type = index < pokedexthis.length
                                ? pokedexthis[index]['type'][0]
                                : '';

                            return InkWell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: type == 'Grass'
                                        ? Colors.greenAccent
                                        : type == "Fire"
                                            ? Colors.redAccent
                                            : type == "Water"
                                                ? Colors.blue
                                                : type == "Electric"
                                                    ? Colors.yellow
                                                    : type == "Rock"
                                                        ? Colors.grey
                                                        : type == "Ground"
                                                            ? Colors.brown
                                                            : type == "Psychic"
                                                                ? Colors.indigo
                                                                : type ==
                                                                        "Fighting"
                                                                    ? Colors
                                                                        .orange
                                                                    : type ==
                                                                            "Bug"
                                                                        ? Colors
                                                                            .lightGreenAccent
                                                                        : type ==
                                                                                "Ghost"
                                                                            ? Colors.deepPurple
                                                                            : type == "Poison"
                                                                                ? Colors.deepPurpleAccent
                                                                                : type == "Normal"
                                                                                    ? Colors.black26
                                                                                    : Colors.pink,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: -10,
                                        right: -10,
                                        child: Image.asset(
                                          'assets/images/pokeball.png',
                                          height: 100,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      Positioned(
                                        top: 20,
                                        left: 20,
                                        child: Text(
                                          pokemon.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 45,
                                        left: 20,
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 4,
                                                bottom: 4),
                                            child: Text(
                                              type.toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            color: Colors.black26,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                      bottom: 5,
                                      right: 5,
                                      child: CachedNetworkImage(
                                        imageUrl: pokemon.img.toString(),
                                        height: 100,
                                        fit: BoxFit.fitHeight,
                                      )
                                    )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                //detail screen
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => PokemonDetailScreen(
                                          pokemonDetail: pokedexthis[index], 
                                          color: type == 'Grass'
                                        ? Colors.greenAccent
                                        : type == "Fire"
                                            ? Colors.redAccent
                                            : type == "Water"
                                                ? Colors.blue
                                                : type == "Electric"
                                                    ? Colors.yellow
                                                    : type == "Rock"
                                                        ? Colors.grey
                                                        : type == "Ground"
                                                            ? Colors.brown
                                                            : type == "Psychic"
                                                                ? Colors.indigo
                                                                : type ==
                                                                        "Fighting"
                                                                    ? Colors
                                                                        .orange
                                                                    : type ==
                                                                            "Bug"
                                                                        ? Colors
                                                                            .lightGreenAccent
                                                                        : type ==
                                                                                "Ghost"
                                                                            ? Colors.deepPurple
                                                                            : type == "Poison"
                                                                                ? Colors.deepPurpleAccent
                                                                                : type == "Normal"
                                                                                    ? Colors.black26
                                                                                    : Colors.pink, 
                                          heroTag: index)));
                              },
                            );
                          }),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                              'Failed to fetch Pokémon data. Error: ${snapshot.error}'),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void fetchPokemonData() async {
    try {
      final response = await http.get(Uri.parse(pokeApi));
      if (response.statusCode == 200) {
        final decodedJsonData = jsonDecode(response.body);
        setState(() {
          pokedexthis = decodedJsonData['pokemon'];
        });
      } else {
        print(
            'Failed to fetch Pokémon data. Error code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred while fetching Pokémon data: $error');
    }
  }

  fetchType(PokeModel? pokeModel, int index) {
    if (pokeModel != null) {
      final pokemon = pokeModel.pokemon[index];
      final types = pokemon.type;

      if (types != null) {
        return types.map((type) => type.toString()).toList();
      }
    }

    return [];
  }
}

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue, child: const Center(child: Text('Page 4')));
  }
}

class Page5 extends StatelessWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightGreenAccent,
        child: const Center(child: Text('Page 4')));
  }
}
