import 'package:flutter/material.dart';
import 'package:movie_app/bloc/get_casts_bloc.dart';
import 'package:movie_app/model/cast.dart';
import 'package:movie_app/model/cast_response.dart';
import 'package:movie_app/style/theme.dart' as Style;

class Casts extends StatefulWidget {
  final int id;
  Casts({Key key, @required this.id}): super(key: key);
  @override
  _CastsState createState() => _CastsState(id);
}

class _CastsState extends State<Casts> {
  final int id;
  _CastsState(this.id);

  @override
  void initState(){
    super.initState();
    castsBloc..getCasts(id);
  }

  @override
  void dispose(){
    super.dispose();
    castsBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10, top: 20),
          child:Text(
            'CASTS',
            style: TextStyle(
              color: Style.Colors.titleColor,
              fontWeight: FontWeight.w500,
              fontSize: 12
            ),
          )
        ),
        SizedBox(
          height: 5
        ),
        StreamBuilder<CastResponse>(
          stream: castsBloc.subject.stream,
          builder: (context, AsyncSnapshot<CastResponse> snapshot){
              if(snapshot.hasData){
                  if(snapshot.data.error != null && snapshot.data.error.length > 0){
                    return _buildErrorWidget(snapshot.data.error);
                  }
                  return _buildCastsWidget(snapshot.data);

              }else if(snapshot.hasError){
                return _buildErrorWidget(snapshot.error);

              }else{
                return _buildLoadingWidget();
              }
          },
        )
      ],
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

  Widget _buildCastsWidget(CastResponse data){
    List<Cast> casts = data.casts;
    return Container(
      height: 140,
      padding: EdgeInsets.only(left: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: casts.length,
        itemBuilder:(context, index){
          return Container(
            padding: EdgeInsets.only(top: 10, right: 10),
            width: 100,
            child: GestureDetector(
              onTap: (){},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "https://image.tmdb.org/t/p/w300/" + casts[index].img
                        )
                      )
                    ),
                  ),
                  SizedBox(
                    height : 10
                  ),
                  Text(
                    casts[index].name.length > 15
                    ? casts[index].name.substring(0, 15) + "..."
                    : casts[index].name,
                    style: TextStyle(
                      height: 1.4,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 9
                    ),
                  ),
                  SizedBox(
                    height: 10
                  ),
                  Text(
                    casts[index].character,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Style.Colors.titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 7
                    )
                  )
                ]
              )
            ),
          );
        },
      ),
    );
  }
}