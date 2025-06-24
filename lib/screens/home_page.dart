import 'package:flutter/material.dart';
import 'package:p5/models/movie.dart';
import 'package:p5/services/api_service.dart';
import 'package:p5/screens/detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> movies = [];
  bool isLoading = false;
  String? errorMessage;
  final TextEditingController _searchController = TextEditingController();
  String _currentSearchQuery = 'batman'; // Query default saat startup

  @override
  void initState() {
    super.initState();
    fetchMovies(
      _currentSearchQuery,
    ); // Memuat film dengan query default saat startup
  }

  Future<void> fetchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        movies = [];
        isLoading = false;
        errorMessage = null;
      });
      return;
    }
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final result = await ApiService().getMovies(query);
      setState(() {
        movies = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage =
            'Gagal memuat film: ${e.toString()}'; // Menggunakan toString() untuk pesan yang lebih baik
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: ${e.toString()}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating, // Lebih modern
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Aplikasi Film',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(
              12.0,
            ), // Padding yang sedikit lebih besar
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Film...',
                hintText: 'Misal: The Matrix, Inception, dll.',
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Sudut membulat
                  borderSide: BorderSide.none, // Hilangkan garis border default
                ),
                filled: true,
                fillColor: Colors.white, // Latar belakang putih
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _currentSearchQuery = '';
                            });
                            fetchMovies('');
                          },
                        )
                        : null,
              ),
              onChanged: (value) {
                // Perbarui UI untuk menampilkan/menyembunyikan tombol clear
                setState(() {});
              },
              onSubmitted: (value) {
                setState(() {
                  _currentSearchQuery = value;
                });
                fetchMovies(value);
              },
            ),
          ),
          if (isLoading)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.blueAccent),
                    SizedBox(height: 10),
                    Text(
                      'Memuat film...',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else if (errorMessage != null)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.redAccent,
                        size: 70, // Ukuran ikon lebih besar
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Terjadi Kesalahan!',
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
                        onPressed: () => fetchMovies(_currentSearchQuery),
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
              ),
            )
          else if (movies.isEmpty && _currentSearchQuery.isNotEmpty)
            const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sentiment_dissatisfied,
                        color: Colors.grey,
                        size: 70,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Ups, Tidak Ditemukan!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Film yang Anda cari tidak ada dalam database kami. Coba kata kunci lain atau periksa ejaan.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (movies.isEmpty && _currentSearchQuery.isEmpty)
            const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.movie_filter,
                        color: Colors.blueGrey,
                        size: 70,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Temukan Film Impian Anda!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Gunakan kolom pencarian di atas untuk menemukan informasi tentang film favorit Anda.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: movies.length,
                itemBuilder: (ctx, index) {
                  final movie = movies[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 6,
                    ), // Margin vertikal saja
                    elevation: 8, // Bayangan lebih menonjol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ), // Sudut lebih membulat
                    ),
                    clipBehavior:
                        Clip.antiAlias, // Penting untuk ClipRRect inner
                    child: InkWell(
                      // Untuk efek riak saat ditekan
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DetailPage(imdbId: movie.imdbId),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ), // Sudut membulat pada gambar
                              child:
                                  movie.posterUrl.isNotEmpty &&
                                          movie.posterUrl != 'N/A'
                                      ? Image.network(
                                        movie.posterUrl,
                                        width: 90,
                                        height: 130,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  width: 90,
                                                  height: 130,
                                                  color: Colors.grey[300],
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    color: Colors.grey[600],
                                                    size: 40,
                                                  ),
                                                ),
                                      )
                                      : Container(
                                        width: 90,
                                        height: 130,
                                        color: Colors.grey[300],
                                        child: Icon(
                                          Icons.movie,
                                          color: Colors.grey[600],
                                          size: 40,
                                        ),
                                      ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          20, // Ukuran font judul lebih besar
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  // Menampilkan tahun jika tersedia
                                  if (movie.year != null &&
                                      movie.year!.isNotEmpty)
                                    Text(
                                      'Tahun: ${movie.year!}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
