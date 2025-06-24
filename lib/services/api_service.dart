import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie.dart';

class ApiService {
  static const String _baseUrl = 'https://www.omdbapi.com/';
  static const String _apikey =
      '288b3fa5'; // Pindahkan ke .env untuk production!

  Future<List<Movie>> getMovies(String s) async {
    try {
      final url = Uri.parse('$_baseUrl?s=movie&apikey=$_apikey');

      // Tambahkan timeout 10 detik
      final response = await http
          .get(url)
          .timeout(
            const Duration(seconds: 10),
            onTimeout:
                () =>
                    throw Exception('Request timeout: Server tidak merespons'),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Handle error dari OMDB (meski status code 200)
        if (data['Response'] != 'True') {
          throw Exception(data['Error'] ?? 'Gagal memuat data');
        }

        if (data['Search'] == null) {
          return []; // Return list kosong jika tidak ada hasil
        }

        return (data['Search'] as List)
            .map((json) => Movie.fromJson(json))
            .toList();
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Gagal terhubung ke server: ${e.message}');
    } on FormatException {
      throw Exception('Data format tidak valid');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
