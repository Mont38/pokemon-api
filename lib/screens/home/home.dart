import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pokemon/controllers/poke_controller.dart';
import 'package:pokemon/firebase/firebase_service.dart';
import 'package:pokemon/model/poke_model.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:core';

import 'package:pokemon/screens/home/pokemon_detail_screen.dart';

class Home extends StatefulWidget {
  Home({super.key});

  static String routeName = "/Home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final screens = [const Page1(), const Page3(), const Page2()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(31, 231, 231, 231),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      drawer: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Drawer(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(56, 61, 93, 0.985),
              ),
              child: ListView(
                children: [
                  const UserAccountsDrawerHeader(
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://i.pinimg.com/564x/15/5e/a4/155ea4a6a22db66e8bf1eaba7349ffd8.jpg'),
                      ),
                      accountName: Text('Natanael Cano'),
                      accountEmail: Text('rancho@humilde.com.mx')),
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                          color: Color.fromRGBO(255, 178, 122, 1),
                        ),
                      ),
                      primary: Colors.white,
                      backgroundColor: Color.fromRGBO(71, 76, 106, 0.85),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: Icon(Icons.settings,
                        color: Color.fromRGBO(255, 178, 122, 1)),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                          color: Color.fromRGBO(255, 178, 122, 1),
                        ),
                      ),
                      primary: Colors.white,
                      backgroundColor: Color.fromRGBO(71, 76, 106, 0.85),
                    ),
                    onPressed: () {},
                    child: Icon(Icons.notifications,
                        color: Color.fromRGBO(255, 178, 122, 1)),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                          color: Color.fromRGBO(255, 178, 122, 1),
                        ),
                      ),
                      primary: Colors.white,
                      backgroundColor: Color.fromRGBO(71, 76, 106, 0.85),
                    ),
                    onPressed: () {},
                    child: Icon(Icons.exit_to_app,
                        color: Color.fromRGBO(255, 178, 122, 1)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: screens[_currentIndex],
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: Color.fromRGBO(249, 249, 249, 0.169),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(169, 158, 158, 158).withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
        child: GNav(
          gap: 5,
          activeColor: Color.fromARGB(248, 255, 255, 255),
          tabBackgroundColor: Color.fromARGB(156, 36, 53, 85),
          onTabChange: (index) => {setState(() => _currentIndex = index)},
          selectedIndex: _currentIndex,
          tabs: const [
            GButton(
              icon: Icons.favorite_border,
              iconColor: Color.fromARGB(255, 225, 110, 233),
              margin: EdgeInsets.only(left: 10),
              text: "Favorites",
            ),
            GButton(
              icon: Icons.catching_pokemon_outlined,
              iconColor: Colors.red,
              text: "pokemones",
            ),
            GButton(
              icon: Icons.backpack,
              iconColor: Color.fromARGB(255, 246, 125, 49),
              text: "inventory",
            ),
          ],
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return Text(snapshot.data?[index]['name']);
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
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
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/background_home.jpg"),
          fit: BoxFit.cover,
        )),
        child: Stack(
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
                    color: const Color.fromARGB(255, 253, 253, 253)),
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
                                                              : type ==
                                                                      "Psychic"
                                                                  ? Colors
                                                                      .indigo
                                                                  : type ==
                                                                          "Fighting"
                                                                      ? Colors
                                                                          .orange
                                                                      : type ==
                                                                              "Bug"
                                                                          ? Colors
                                                                              .lightGreenAccent
                                                                          : type == "Ghost"
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
                                            ))
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
                                                                  : type ==
                                                                          "Ground"
                                                                      ? Colors
                                                                          .brown
                                                                      : type ==
                                                                              "Psychic"
                                                                          ? Colors
                                                                              .indigo
                                                                          : type == "Fighting"
                                                                              ? Colors.orange
                                                                              : type == "Bug"
                                                                                  ? Colors.lightGreenAccent
                                                                                  : type == "Ghost"
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
