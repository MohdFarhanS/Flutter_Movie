import 'package:flutter/material.dart';
import 'package:p5/models/movie.dart'; // Sesuaikan path ini
import 'package:p5/services/api_service.dart'; // Sesuaikan path ini

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      // Perhatikan bahwa getMovies sekarang membutuhkan argumen query
      // Misalnya, kita bisa mencari film dengan query "batman"
      final result = await ApiService().getMovies("batman");
      setState(() {
        movies = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Film')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (ctx, index) {
                final movie = movies[index];
                return ListTile(
                  leading: movie.posterUrl.isNotEmpty
                      ? Image.network(
                          movie.posterUrl,
                          width: 50,
                          height: 75,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                        )
                      : const Icon(Icons.movie),
                  title: Text(movie.title),
                );
              },
            ),
    );
  }
}