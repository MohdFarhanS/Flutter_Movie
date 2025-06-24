class Movie {
  final String title;
  final String posterUrl;
  final String imdbId;
  final String? year;

  Movie({
    required this.title,
    required this.posterUrl,
    required this.imdbId,
    this.year,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'],
      posterUrl:
          json['Poster'] != 'N/A'
              ? json['Poster']
              : 'https://via.placeholder.com/150',
      imdbId: json['imdbID'],
      year: json['Year'],
    );
  }
}
