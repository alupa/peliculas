import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Películas en cines'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context, 
                delegate: DataSearch(),
                // query: 'Hola'
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context),
            ],
        ),
      ),
    );
  }

  Widget _swiperTarjetas() {
    // peliculasProvider.getEnCines();
    // return CardSwiper(
    //   peliculas: [1,2,3,4,5],
    // );

    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) return CardSwiper(peliculas: snapshot.data);
        return Container(
          // height: 400.0,
          child: Center(
            child: CircularProgressIndicator()
            )
          );
      },
    );
  }

  Widget _footer(BuildContext context) {
    peliculasProvider.getPopulares();
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares', style: Theme.of(context).textTheme.subhead)),
          SizedBox(height: 5.0),
          // FutureBuilder(
          StreamBuilder(
            // future: peliculasProvider.getPopulares(),
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              // snapshot.data?.forEach((p) => print(p.title));
              if(snapshot.hasData) 
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,
                  );
              return Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}