// movie.dart
class Movie {
  final String title;
  final String director;
  final int year;
  final String image;

  Movie({this.title = '', this.director = '', this.year = 0, this.image = ''});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'director': director,
      'year': year,
      'image': image,
    };
  }

  // Constructor para crear un objeto Movie desde un mapa
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      title: map['title'] ?? '',
      director: map['director'] ?? '',
      year: map['year'] ?? 0,
      image: map['image'] ?? '',
    );
  }
}
