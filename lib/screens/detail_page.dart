import 'package:flutter/material.dart';
import 'package:p5/services/api_service.dart';

class DetailPage extends StatefulWidget {
  final String imdbId;

  const DetailPage({super.key, required this.imdbId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? movieDetail;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchMovieDetail();
  }

  Future<void> _fetchMovieDetail() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final result = await ApiService().getMovieDetail(widget.imdbId);
      setState(() {
        movieDetail = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Gagal memuat detail film: ${e.toString()}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: ${e.toString()}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
          action: SnackBarAction(
            label: 'Tutup',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          movieDetail?['Title'] ?? 'Detail Film',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Warna ikon kembali
      ),
      body:
          isLoading
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.blueAccent),
                    SizedBox(height: 10),
                    Text(
                      'Memuat detail film...',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              )
              : errorMessage != null
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.redAccent,
                        size: 70,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Gagal Memuat!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        errorMessage!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton.icon(
                        onPressed: _fetchMovieDetail,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : movieDetail == null
              ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey, size: 70),
                      SizedBox(height: 15),
                      Text(
                        'Informasi Tidak Tersedia',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Detail film ini tidak dapat dimuat atau tidak tersedia dalam database.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Poster Film
                    Center(
                      child: Card(
                        elevation: 10, // Bayangan poster
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child:
                            movieDetail!['Poster'] != 'N/A' &&
                                    movieDetail!['Poster'] != null
                                ? Image.network(
                                  movieDetail!['Poster'],
                                  height:
                                      MediaQuery.of(context).size.height *
                                      0.4, // Ukuran responsif
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) => Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                            0.4,
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.7,
                                        color: Colors.grey[300],
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 60,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                )
                                : Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.movie,
                                    size: 60,
                                    color: Colors.grey[600],
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Judul Film
                    Text(
                      movieDetail!['Title'] ?? 'Judul Tidak Tersedia',
                      style: const TextStyle(
                        fontSize: 30, // Ukuran font judul lebih besar
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Rating, Tahun, Durasi
                    Row(
                      children: [
                        Icon(
                          Icons.star_rate,
                          color: Colors.amber[700],
                          size: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${movieDetail!['imdbRating'] ?? 'N/A'} / 10',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Icon(
                          Icons.calendar_today,
                          color: Colors.blueGrey,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${movieDetail!['Year'] ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Icon(
                          Icons.access_time,
                          color: Colors.blueGrey,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${movieDetail!['Runtime'] ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Genre sebagai Chip
                    if (movieDetail!['Genre'] != null &&
                        movieDetail!['Genre'] != 'N/A')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Wrap(
                          spacing: 8.0, // Jarak antar chip
                          runSpacing: 4.0, // Jarak antar baris chip
                          children:
                              (movieDetail!['Genre'] as String)
                                  .split(', ')
                                  .map(
                                    (genre) => Chip(
                                      label: Text(genre),
                                      backgroundColor: Colors.blue.withOpacity(
                                        0.1,
                                      ),
                                      labelStyle: TextStyle(
                                        color: Colors.blue[800],
                                        fontWeight: FontWeight.w500,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          color: Colors.blue.withOpacity(0.3),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),

                    const Divider(
                      height: 25,
                      thickness: 1.5,
                      color: Colors.blueGrey,
                    ),

                    // Sinopsis
                    const Text(
                      'Sinopsis',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      movieDetail!['Plot'] ?? 'Sinopsis tidak tersedia.',
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),

                    const Divider(
                      height: 25,
                      thickness: 1.5,
                      color: Colors.blueGrey,
                    ),

                    // Detail lainnya
                    _buildDetailSection('Detail Tambahan', [
                      _buildDetailRow(
                        'Sutradara',
                        movieDetail!['Director'],
                        Icons.camera_alt,
                      ),
                      _buildDetailRow(
                        'Penulis',
                        movieDetail!['Writer'],
                        Icons.edit,
                      ),
                      _buildDetailRow(
                        'Aktor',
                        movieDetail!['Actors'],
                        Icons.people,
                      ),
                      _buildDetailRow(
                        'Bahasa',
                        movieDetail!['Language'],
                        Icons.language,
                      ),
                      _buildDetailRow(
                        'Negara',
                        movieDetail!['Country'],
                        Icons.flag,
                      ),
                      _buildDetailRow(
                        'Penghargaan',
                        movieDetail!['Awards'],
                        Icons.emoji_events,
                      ),
                      _buildDetailRow(
                        'Box Office',
                        movieDetail!['BoxOffice'],
                        Icons.money,
                      ),
                    ]),
                  ],
                ),
              ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    // Filter out SizedBox.shrink() to avoid showing empty sections
    final filteredChildren =
        children.where((widget) => widget is! SizedBox).toList();
    if (filteredChildren.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        ...filteredChildren,
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDetailRow(String label, String? value, IconData icon) {
    if (value == null || value == 'N/A' || value.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueGrey[700], size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
