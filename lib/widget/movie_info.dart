import 'package:flutter/material.dart';
import 'package:movie_app/bloc/get_movie_detail_bloc.dart';
import 'package:movie_app/model/movie_detail.dart';
import 'package:movie_app/model/movie_detail_response.dart';
import 'package:movie_app/style/theme.dart' as Style;


class MovieInfo extends StatefulWidget {
  final int id;
  MovieInfo({Key key, @required this.id}) : super(key : key);
  @override
  _MovieInfoState createState() => _MovieInfoState(id);
}

class _MovieInfoState extends State<MovieInfo> {
  final int id;
  _MovieInfoState(this.id);
  @override
  void initState(){
    super.initState();
    movieDetailBloc..getMovieDetail(id);
  }

  @override
  void dispose(){
    super.dispose();
    movieDetailBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieDetailResponse>(
      stream: movieDetailBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieDetailResponse> snapshot){
        if(snapshot.hasData){
          if(snapshot.data.error != null &&
            snapshot.data.error.length > 0){
            return _buildErrorWidget(snapshot.data.error);
          }
            return _buildInfoWidget(snapshot.data);
        }else if(snapshot.hasError){
          return _buildErrorWidget(snapshot.error);
        }else{
          return _buildLoadingWidget();
        }
      }
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

  Widget _buildInfoWidget(MovieDetailResponse data){
    MovieDetail detail = data.movieDetail;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "BUDGET",
                    style: TextStyle(
                      color: Style.Colors.titleColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12
                    ),
                  ),
                  SizedBox(
                    height: 10
                  ),
                  Text(
                    detail.budget.toString() + "\$",
                    style: TextStyle(
                      color: Style.Colors.secondColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                    ),
                  )
                ]
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "DURATION",
                    style: TextStyle(
                      color: Style.Colors.titleColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12
                    ),
                  ),
                  SizedBox(
                    height: 10
                  ),
                  Text(
                    detail.runtime.toString() + "min",
                    style: TextStyle(
                      color: Style.Colors.secondColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                    ),
                  )
                ]
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "REALESE DATE",
                    style: TextStyle(
                      color: Style.Colors.titleColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12
                    ),
                  ),
                  SizedBox(
                    height: 10
                  ),
                  Text(
                    detail.realeseDate,
                    style: TextStyle(
                      color: Style.Colors.secondColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                    ),
                  )
                ]
              )
            ],
          ),
        ),
        SizedBox(
          height: 10
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "GENRES",
                style: TextStyle(
                  color: Style.Colors.titleColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12
                ),
              ),
              SizedBox(
                height: 10
              ),
              Container(
                height: 38,
                padding : EdgeInsets.only(top: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: detail.genres.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          border: Border.all(
                            width: 1,
                            color: Colors.white
                          )
                        ),
                        child: Center(
                          child: Text(
                          detail.genres[index].name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 9
                          ),
                        )
                        ),
                      ),
                    );
                  }
                ) 
              ),
            ],
          )       
        )
      ],
    );

  }

}