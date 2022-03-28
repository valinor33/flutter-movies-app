import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';


class MoviesProvider extends ChangeNotifier {
  String _apiKey = "bacec6da78a0e92a20c87ef97fc727d6";
  String _baseUrl = "api.themoviedb.org";
  String _language = "es-ES";

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  MoviesProvider() {
    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      ' language': _language,
      ' page': '$page',
    });

    final response = await http.get(url);

    return response.body;
  }

  getOnDisplayMovies() async {
    _popularPage++;

    final jsonData =
        await this._getJsonData('3/movie/now_playing', _popularPage);
    final nowPlayingResponse = NowPayingResponse.fromJson(jsonData);

    onDisplayMovies = nowPlayingResponse.results;

    notifyListeners();
  }

  getPopularMovies() async {
    final jsonData = await this._getJsonData('3/movie/popular');
    final popularResponse = PopularResponse.fromJson(jsonData);

    popularMovies = [...popularMovies, ...popularResponse.results];

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final jsonData = await this._getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  // Future<List<Movie>> searchMovies(String query) async {
  //   final url = Uri.https(_baseUrl, "3/search/movie", {
  //     'api_key': _apiKey,
  //     ' language': _language,
  //     'query': query,
  //   });

  //   final response = await http.get(url);
  //   final searchResponse = SearchResponse.fromJson(response.body);

  //   return searchResponse.results;
  // }
}
