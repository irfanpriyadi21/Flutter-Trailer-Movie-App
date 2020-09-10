import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_app/bloc/get_now_playing_bloc.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/model/movie_response.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:movie_app/style/theme.dart' as Style;

class NowPlaying extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {

  void initState(){
    super.initState();
    nowPlayingMoviesBloc.getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: nowPlayingMoviesBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot){
          if(snapshot.hasData){
              if(snapshot.data.error != null && snapshot.data.error.length > 0){
                return _buildErrorWidget(snapshot.data.error);
              }
              return _buildNowPlayingWidget(snapshot.data);

          }else if(snapshot.hasError){
            return _buildErrorWidget(snapshot.error);

          }else{
            return _buildLoadingWidget();
          }
      },
    );
  }

  Widget _buildLoadingWidget(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 25.0,
            width: 25.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Error Occured: $error"),
        ],
      ),
    );
  }

  Widget _buildNowPlayingWidget(MovieResponse data){
    List<Movie> movies = data.movies;
    if(movies.length == 0){
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("No Movies"),
          ],
        ),
      );
    }else{
      return Container(
        height: 220,
        child: PageIndicatorContainer(
          align: IndicatorAlign.bottom,
          indicatorSpace: 8.0,
          padding: EdgeInsets.all(5.0),
          indicatorColor: Style.Colors.titleColor,
          indicatorSelectorColor: Style.Colors.secondColor,
          shape: IndicatorShape.circle(size: 8.0),
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.take(5).length,
            itemBuilder: (context, index){
              return Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(image: NetworkImage('https://image.tmdb.org/t/p/original/'+ movies[index].backPoster),
                      fit: BoxFit.cover
                      )
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Style.Colors.mainColor.withOpacity(1.0),
                          Style.Colors.mainColor.withOpacity(0.0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [
                          0.0,
                          0.9 
                        ]
                      )
                    )
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: GestureDetector(
                      onTap: (){
                        // Navigator.push(context, 
                        // MaterialPageRoute(builder: (context) => VidioPlayerScreen(
                        //   controller: YoutubePlayerController(initialVideoId: videos[0].key,
                        //   flags: YoutubePlayerFlags(
                        //     autoPlay: true
                        //   )))
                        //   )
                        // );
                      },
                      child: Icon(FontAwesomeIcons.playCircle,color: Style.Colors.secondColor,
                        size: 40.0 
                      ),
                    )
                  ),
                  Positioned(
                    bottom: 30,
                    child: Container(
                      padding : EdgeInsets.only(left: 10, right:10),
                      width:250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            movies[index].title,
                            style: TextStyle(
                              height: 1.5,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0
                            )
                          ) 
                        ],
                      ), 
                    ),
                  )
                ],
              );
            } ),
          length: movies.take(5).length,
        ),
      );
    }

  }

}