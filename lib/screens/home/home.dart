import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pokemon/controllers/poke_controller.dart';
import 'package:pokemon/firebase/firebase_service.dart';
import 'package:pokemon/model/poke_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'dart:convert';

import 'dart:core';

import 'package:pokemon/screens/home/pokemon_detail_screen.dart';
import 'package:pokemon/settings/theme_settings.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({super.key});

  static String routeName = "/Home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Firebase_service _firebase = Firebase_service();

  final auth = FirebaseAuth.instance;
  int _currentIndex = 0;

  final user = FirebaseAuth.instance.currentUser!;

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    final screens = [const Page1(), const Page3(), Page2()];
    ThemeProvider tema = Provider.of<ThemeProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(31, 231, 231, 231),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      drawer: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Drawer(
            child: Container(
              decoration: const BoxDecoration(),
              child: StreamBuilder(
                  stream: _firebase.getAllFavorites(user.email),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(snapshot.data!.docs[index].get('name'));

                          return Column(
                            children: [
                              UserAccountsDrawerHeader(
                                currentAccountPicture: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      '${snapshot.data!.docs[index].get('image') ?? user!.photoURL}${snapshot.data!.docs[index].get('image') != null ? '' : ''}'),
                                ),
                                accountName: Text(
                                    '${snapshot.data!.docs[index].get('name') ?? snapshot.data!.docs[index].get('email')}${snapshot.data!.docs[index].get('name') != null ? '' : ''}'),
                                accountEmail: Text('${user.email}'),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    side: const BorderSide(
                                      color: Color.fromRGBO(255, 178, 122, 1),
                                    ),
                                  ),
                                  primary: Colors.white,
                                  backgroundColor:
                                      const Color.fromRGBO(88, 89, 90, 0.239),
                                ),
                                onPressed: () {
                                  tema.cambiarTemaOscuro();
                                },
                                child: const Icon(Icons.nightlight,
                                    color: Color.fromRGBO(32, 83, 134, 1)),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    side: const BorderSide(
                                      color: Color.fromRGBO(255, 178, 122, 1),
                                    ),
                                  ),
                                  primary: Colors.white,
                                  backgroundColor:
                                      const Color.fromRGBO(88, 89, 90, 0.239),
                                ),
                                onPressed: () {
                                  tema.cambiarTemaClaro();
                                },
                                child: const Icon(Icons.sunny,
                                    color: Color.fromRGBO(255, 178, 122, 1)),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    side: const BorderSide(
                                      color: Color.fromRGBO(255, 178, 122, 1),
                                    ),
                                  ),
                                  primary: Colors.white,
                                  backgroundColor:
                                      const Color.fromRGBO(88, 89, 90, 0.239),
                                ),
                                onPressed: () {
                                  tema.cambiarTemaPersonalizado();
                                },
                                child: const Icon(Icons.auto_awesome,
                                    color: Color.fromRGBO(196, 111, 235, 1)),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    side: const BorderSide(
                                      color: Color.fromRGBO(255, 178, 122, 1),
                                    ),
                                  ),
                                  primary: Colors.white,
                                  backgroundColor:
                                      const Color.fromRGBO(88, 89, 90, 0.239),
                                ),
                                onPressed: () {
                                  FirebaseAuth.instance.signOut().then(
                                        (value) => Navigator.pushNamed(
                                            context, '/Login'),
                                      );
                                },
                                child: const Icon(Icons.exit_to_app,
                                    color: Color.fromRGBO(255, 178, 122, 1)),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error en la petición, intente nuevamente'),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
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
          color: Color.fromRGBO(18, 18, 18, 1),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(169, 200, 197, 197).withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
        child: GNav(
          gap: 5,
          activeColor: Color.fromARGB(248, 255, 255, 255),
          tabBackgroundColor: Color.fromARGB(156, 36, 53, 85),
          onTabChange: (index) => {
            setState(() {
              _currentIndex = index;
            })
          },
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
              text: "Pokedex",
            ),
            GButton(
              icon: Icons.person,
              iconColor: Color.fromARGB(255, 49, 184, 246),
              text: "User",
            ),
          ],
        ),
      ),
    );
  }
}

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  late Future<PokeModel> _pokeDataModel;

  final userPage1 = FirebaseAuth.instance.currentUser!;
  List<Map<String, dynamic>> favorites = [];
  var pokeApi =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
  late List<dynamic> pokedexthis = [];

  @override
  void initState() {
    super.initState();
    fetchFavorites();
    fetchFavoritesAndPokemonData();
    _pokeDataModel = PokeController().getData();
  }

  Future<void> fetchFavorites() async {
    Firebase_service _firebase = Firebase_service();
    // Aquí puedes usar el user_id específico que deseas consultar
    String userId = userPage1.uid.toString();

    List<Map<String, dynamic>> userFavorites =
        await await _firebase.getFavoritesByUserId(userId);

    setState(() {
      favorites = userFavorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/background_home.jpg"),
        fit: BoxFit.cover,
      )),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: pokedexthis.length,
              itemBuilder: (context, index) {
                final pokemon = pokedexthis[index];
                final id = pokemon['id'];
                final name = pokemon['name'];
                final type = pokemon['type'][0];

                Color backgroundColor = Colors.white;

                if (type == 'Grass') {
                  backgroundColor = Colors.greenAccent;
                } else if (type == 'Fire') {
                  backgroundColor = Colors.redAccent;
                } else if (type == 'Water') {
                  backgroundColor = Colors.blue;
                } else if (type == 'Electric') {
                  backgroundColor = Colors.yellow;
                } else if (type == 'Rock') {
                  backgroundColor = Colors.grey;
                } else if (type == 'Ground') {
                  backgroundColor = Colors.brown;
                } else if (type == 'Psychic') {
                  backgroundColor = Colors.indigo;
                } else if (type == 'Fighting') {
                  backgroundColor = Colors.orange;
                } else if (type == 'Bug') {
                  backgroundColor = Colors.lightGreenAccent;
                } else if (type == 'Ghost') {
                  backgroundColor = Colors.deepPurple;
                } else if (type == 'Poison') {
                  backgroundColor = Colors.deepPurpleAccent;
                } else if (type == 'Normal') {
                  backgroundColor = Color.fromARGB(66, 0, 0, 0);
                } else {
                  backgroundColor = Colors.pink;
                }

                return Card(
                  color: backgroundColor,
                  child: ListTile(
                    leading: Text('No. ' + id.toString()),
                    title: Text(name),
                    subtitle: Text(type),
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
                                                                          ? Colors
                                                                              .deepPurple
                                                                          : type == "Poison"
                                                                              ? Colors.deepPurpleAccent
                                                                              : type == "Normal"
                                                                                  ? Colors.black26
                                                                                  : Colors.pink,
                                  heroTag: index)));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void fetchFavoritesAndPokemonData() async {
    Firebase_service _firebase = Firebase_service();
    String userId = userPage1.uid.toString();
    List<Map<String, dynamic>> userFavorites =
        await _firebase.getFavoritesByUserId(userId);

    List<dynamic> pokemonList = [];

    for (var favorite in userFavorites) {
      String pokemonId = favorite['id_pokemon'];
      var pokemon = await fetchPokemonData(pokemonId);
      if (pokemon != null) {
        pokemonList.add(pokemon);
      }
    }

    setState(() {
      pokedexthis = pokemonList;
    });
  }

  Future<dynamic> fetchPokemonData(String pokemonId) async {
    try {
      var dio = Dio();
      var cacheManager = DioCacheManager(CacheConfig());
      dio.interceptors.add(cacheManager.interceptor);

      var response = await dio.get(
        pokeApi,
        options: buildCacheOptions(Duration(hours: 1)),
      );

      if (response.statusCode == 200) {
        var decodedJsonData = jsonDecode(response.data);
        var pokedexData = decodedJsonData['pokemon'] as List<dynamic>;

        var pokemon = pokedexData.firstWhere(
          (pokemon) => pokemon['id'].toString() == pokemonId,
          orElse: () => null,
        );

        return pokemon;
      } else {
        print(
            'Failed to fetch Pokémon data. Error code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred while fetching Pokémon data: $error');
    }

    return null;
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

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  Firebase_service _firebase = Firebase_service();
  final picker = ImagePicker();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  File? _image;
  File? selectedImage;
  String imageUrl = '';
  late String _tempImagePath;
  final userPage2 = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    _loadImage();
    _usernameController.text =
        _emailController.text = userPage2.email.toString();

    // Realiza una consulta a Firestore o Firebase Storage para obtener la URL de la imagen del usuario
    _firebase.getUserImageUrlByEmail(userPage2.email.toString()).then((url) {
      setState(() {
        imageUrl = url;
      });
    }).catchError((error) {
      print('Error obteniendo la URL de la imagen del usuario: $error');
      // Si ocurre un error al obtener la URL, asigna una URL de imagen por defecto
      setState(() {
        imageUrl = 'URL_DE_IMAGEN_POR_DEFECTO';
      });
    });
  }

  String getAuthProvider() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final providers = user.providerData;
      final providerNames =
          providers.map((userInfo) => userInfo.providerId).join(", ");
      return providerNames;
    }
    return "Sin autenticar";
  }

  Future<void> _loadImage() async {
    final ByteData imageData =
        await rootBundle.load('assets/images/pokeball.png');
    final tempDir = await getTemporaryDirectory();
    _tempImagePath = '${tempDir.path}/pokeball.png';
    final imageFile = File(_tempImagePath);
    await imageFile.writeAsBytes(imageData.buffer.asUint8List());
    setState(() {
      _image = imageFile;
    });
  }

  Future<void> getImageFromGallery() async {
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    print('${file?.path}');
    if (file == null) return;
    String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageTopUpload =
        referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageTopUpload.putFile(File(file!.path));
      imageUrl = await referenceImageTopUpload.getDownloadURL();

      setState(() {
        selectedImage = File(file.path);
      });
    } catch (error) {}
  }

  Future<void> getImageFromCamera() async {
    XFile? file = await picker.pickImage(source: ImageSource.camera);
    print('${file?.path}');
    if (file == null) return;
    String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageTopUpload =
        referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageTopUpload.putFile(File(file!.path));
      imageUrl = await referenceImageTopUpload.getDownloadURL();

      setState(() {
        selectedImage = File(file.path);
      });
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: Icon(Icons.photo_library),
                            title: Text('Select from Gallery'),
                            onTap: () async {
                              getImageFromGallery();
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text('Take a Photo'),
                            onTap: () async {
                              getImageFromCamera();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: CircleAvatar(
                backgroundImage: imageUrl != ''
                    ? NetworkImage(imageUrl) as ImageProvider<Object>?
                    : (_image != null)
                        ? FileImage(_image!) as ImageProvider<Object>?
                        : null,
                radius: 60,
                child:
                    (selectedImage == null && _image == null && imageUrl == '')
                        ? Icon(
                            Icons.person,
                            size: 60,
                          )
                        : null,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Currently authenticated with: ' + getAuthProvider()),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                enabled: false,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String name = _usernameController.text;
                String email = _emailController.text;
                String userId = userPage2.uid
                    .toString(); // Obtén el ID del usuario actual desde FirebaseAuth
                _firebase.updateUserInfo(email, name, imageUrl).then((_) {
                  // Actualización exitosa
                  // Puedes mostrar un mensaje de éxito o realizar cualquier otra acción necesaria
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Update Successful'),
                        content: Text('User information updated.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }).catchError((error) {
                  // Manejo del error en caso de fallo en la actualización
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Update Failed'),
                        content: Text(
                            'An error occurred while updating user information.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                });
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
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
              top: 120,
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
                                          top: 15,
                                          left: 20,
                                          child: Text(
                                            "No. " + pokemon.id.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 33,
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
                                          top: 55,
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
      var dio = Dio();
      var cacheManager = DioCacheManager(CacheConfig());
      dio.interceptors.add(cacheManager.interceptor);

      var response = await dio.get(
        pokeApi,
        options: buildCacheOptions(Duration(hours: 1)),
      );

      if (response.statusCode == 200) {
        var decodedJsonData = jsonDecode(response.data);
        var pokedexData = decodedJsonData['pokemon'] as List<dynamic>;
        setState(() {
          pokedexthis = pokedexData;
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
