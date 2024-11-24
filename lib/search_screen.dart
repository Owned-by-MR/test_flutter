import 'package:flutter/material.dart';
import 'spotify_api.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SpotifyApi api = SpotifyApi();
  String searchTerm = '';
  String searchType = 'album'; // Default search type
  List<Map<String, dynamic>> results = [];

  void _searchSpotify(String query) async {
    try {
      final res = await api.search(query, searchType);
      setState(() {
        results = res;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spotify Search'),
        bottom: TabBar(
          onTap: (index) {
            setState(() {
              searchType = index == 0 ? 'album' : 'artist';
              results.clear();
            });
            if (searchTerm.isNotEmpty) _searchSpotify(searchTerm);
          },
          tabs: [
            Tab(text: 'Albums'),
            Tab(text: 'Artists'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
                if (value.isNotEmpty) _searchSpotify(value);
              },
            ),
          ),
          Expanded(
            child: searchType == 'album' ? _buildAlbumGrid() : _buildArtistList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final album = results[index];
        return Card(
          child: Column(
            children: [
              Image.network(album['images'][0]['url'], height: 100),
              Text(album['name'], style: TextStyle(fontWeight: FontWeight.bold)),
              Text(album['artists'][0]['name']),
              Text(album['release_date']),
            ],
          ),
        );
      },
    );
  }

  Widget _buildArtistList() {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final artist = results[index];
        return ListTile(
          leading: artist['images'].isNotEmpty
              ? Image.network(artist['images'][0]['url'], width: 50)
              : null,
          title: Text(artist['name']),
        );
      },
    );
  }
}
