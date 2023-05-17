import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/firebase/firebase_service.dart';

class PokemonDetailScreen extends StatefulWidget {
  final pokemonDetail;
  final Color color;
  final int heroTag;

  const PokemonDetailScreen(
      {super.key,
      required this.pokemonDetail,
      required this.color,
      required this.heroTag});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  late List<dynamic> favorites;
  final actualUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: widget.color,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 40,
            left: 1,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              iconSize: 30,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 40,
            right: 5,
            child: IconButton(
                icon: Icon(Icons.favorite),
                color: Colors.white,
                iconSize: 30,
                onPressed: () {
                  final pokemonId = widget.pokemonDetail['id'].toString();
                  insertFavorites(actualUser.uid, pokemonId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Agregado a favoritos...'),
                    ),
                  );
                }),
          ),
          Positioned(
              top: 90,
              left: 20,
              child: Text(
                widget.pokemonDetail['name'],
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              )),
          Positioned(
              top: 124,
              left: 20,
              child: Text(
                "No. " + widget.pokemonDetail['id'].toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )),
          Positioned(
              top: 150,
              left: 20,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                  child: Text(
                    widget.pokemonDetail['type'].join(', '),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Colors.black26),
              )),
          Positioned(
              top: height * 0.18,
              right: -30,
              child: Image.asset(
                'assets/images/pokeball.png',
                height: 200,
                fit: BoxFit.fitHeight,
              )),
          Positioned(
              bottom: 0,
              child: Container(
                width: width,
                height: height * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: width * 0.3,
                                child: Text(
                                  "Name",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 18,
                                  ),
                                )),
                            Container(
                              child: Text(
                                widget.pokemonDetail['name'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: width * 0.3,
                                child: Text(
                                  "Height",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 18,
                                  ),
                                )),
                            Container(
                              child: Text(
                                widget.pokemonDetail['height'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: width * 0.3,
                                child: Text(
                                  "Weight",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 18,
                                  ),
                                )),
                            Container(
                              child: Text(
                                widget.pokemonDetail['weight'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: width * 0.3,
                                child: Text(
                                  "Spawn Time",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 18,
                                  ),
                                )),
                            Container(
                              child: Text(
                                widget.pokemonDetail['spawn_time'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: width * 0.3,
                                child: Text(
                                  "Weaknesses",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 18,
                                  ),
                                )),
                            Container(
                              child: Text(
                                widget.pokemonDetail['weaknesses'].join(", "),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: width * 0.3,
                                child: Text(
                                  "Pre Form",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 18,
                                  ),
                                )),
                            widget.pokemonDetail['prev_evolution'] != null
                                ? SizedBox(
                                    height: 20,
                                    width: width * 0.45,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: widget
                                          .pokemonDetail['prev_evolution']
                                          .length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            widget.pokemonDetail[
                                                    'prev_evolution'][index]
                                                ['name'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Text(
                                    'Just Hatched',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: width * 0.3,
                                child: Text(
                                  "Evolution",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 18,
                                  ),
                                )),
                            widget.pokemonDetail['next_evolution'] != null
                                ? SizedBox(
                                    height: 20,
                                    width: width * 0.45,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: widget
                                          .pokemonDetail['next_evolution']
                                          .length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            widget.pokemonDetail[
                                                    'next_evolution'][index]
                                                ['name'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Text(
                                    'Max evolution',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Positioned(
              top: (height * 0.18),
              left: (width / 2) - 100,
              child: CachedNetworkImage(
                imageUrl: widget.pokemonDetail['img'],
                height: 200,
                fit: BoxFit.fitHeight,
              ))
        ],
      ),
    );
  }
}
