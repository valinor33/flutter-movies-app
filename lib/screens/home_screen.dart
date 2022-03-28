import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:movies_app_fl/providers/movies_provider.dart';
import 'package:movies_app_fl/search/search_delegate.dart';
import 'package:movies_app_fl/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Películas en cine"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()),
            icon: Icon(Icons.search_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Tarjetas pricipales
            CardSwiper(movies: moviesProvider.onDisplayMovies),

            // Slider de peliculas
            MovieSlider(
              movies: moviesProvider.popularMovies,
              title: 'Popular',
              onNextPage: () => moviesProvider.getPopularMovies(  ),
            ),
          ],
        ),
      ),
    );
  }
}
