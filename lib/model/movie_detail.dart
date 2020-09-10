import 'package:movie_app/model/genre.dart';

class MovieDetail {
  final int id;
  final bool adult;
  final int budget;
  final List<Genre> genres;
  final String realeseDate;
  final int runtime;

  MovieDetail(
    this.id,
    this.adult,
    this.budget,
    this.genres,
    this.realeseDate,
    this.runtime
  );

  MovieDetail.fromJson(Map<String, dynamic> json)
  : id = json["id"],
    adult = json["adult"],
    budget = json["budget"],
    genres = (json["genres"] as List).map((i) => new Genre.fromJson(i)).toList(),
    realeseDate = json["release_date"],
    runtime = json["runtime"];
}