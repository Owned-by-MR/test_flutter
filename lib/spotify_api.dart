import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyApi {
  final String clientId = '3af8e17840684c5bb3325a5e8b8e808d';
  final String clientSecret = 'e46b037b7f76416ca7e3ac9676f557f7';
  String? _accessToken;

  // Authenticate with Spotify API
  Future<void> authenticate() async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization':
        'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access_token'];
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  // Search artists or albums
  Future<List<Map<String, dynamic>>> search(String query, String type) async {
    if (_accessToken == null) {
      await authenticate();
    }

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/search?q=$query&type=$type&limit=20'),
      headers: {'Authorization': 'Bearer $_accessToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data[type + 's']['items']);
    } else {
      throw Exception('Failed to fetch results');
    }
  }
}
