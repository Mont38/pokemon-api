import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:pokemon/model/poke_model.dart';
import 'dart:convert';

class PokeController {
  var url =
      'https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json';

  Future<PokeModel> getData() async {
    var dio = Dio();
    var cacheManager = DioCacheManager(CacheConfig());
    dio.interceptors.add(cacheManager.interceptor);

    var response = await dio.get(
      url,
      options: buildCacheOptions(Duration(hours: 1)),
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.data);
      var dataBindings = PokeModel.fromJson(jsonResponse);
      return dataBindings;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
