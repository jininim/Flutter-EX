import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtoon/model/webtoon_Model.dart';
import 'package:webtoon/model/webtoon_detail_model.dart';
import 'package:webtoon/model/webtoon_episode_model.dart';
import 'package:webtoon/model/webtoon_favorite_model.dart';

class ApiService {
  // ignore: non_constant_identifier_names, constant_identifier_names
  static const String BaseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonIstances = [];
    final url = Uri.parse('$BaseUrl/$today');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        webtoonIstances.add(WebtoonModel.fromJson(webtoon));
      }
      return webtoonIstances;
    }
    throw Error();
  }

  static Future<WebToonDetailModel> getToonById(String id) async {
    final url = Uri.parse("$BaseUrl/$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebToonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtoonFavoriteModel>> getToonFavorite(
      List<String> ids) async {
    List<WebtoonFavoriteModel> favoriteInstances = [];
    for (var id in ids) {
      final url = Uri.parse("$BaseUrl/$id");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final favorites = jsonDecode(response.body);
        favoriteInstances.add(WebtoonFavoriteModel.fromJson(favorites));
      }
      return favoriteInstances;
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse("$BaseUrl/$id/episodes");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }
}
