// lib/screens/search_screen.dart
// lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:lnmq/models/place_model.dart';
import 'package:lnmq/services/place_service.dart';
import 'package:lnmq/services/search_history_service.dart';
import 'package:lnmq/screens/place_detail_screen.dart';
import 'package:lnmq/l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _searchFocusNode = FocusNode();
  final SearchHistoryService _historyService = SearchHistoryService();
  List<String> _searchHistory = [];
  bool _showSuggestions = false;
  final TextEditingController _searchController = TextEditingController();
  final PlaceService _placeService = PlaceService();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final history = await _historyService.getHistory();
    setState(() {
      _searchHistory = history;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _showSuggestions = _searchQuery.isEmpty && _searchHistory.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.searchTitle, style: const TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(25),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: localizations.searchHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                                _showSuggestions = _searchHistory.isNotEmpty;
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(color: Colors.orange, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  textInputAction: TextInputAction.search,
                  onTap: () {
                    setState(() {
                      _showSuggestions = _searchHistory.isNotEmpty;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      _showSuggestions = false;
                    });
                  },
                ),
              ),
              if (_showSuggestions)
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Wrap(
                    spacing: 8,
                    children: _searchHistory.map((query) => ActionChip(
                      label: Text(query),
                      onPressed: () {
                        _searchController.text = query;
                        setState(() {
                          _searchQuery = query;
                          _showSuggestions = false;
                          _searchFocusNode.unfocus();
                        });
                      },
                    )).toList(),
                  ),
                ),
              const SizedBox(height: 12),
              Expanded(
                child: StreamBuilder<List<Place>>(
                  stream: _placeService.searchPlaces(_searchQuery),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text(localizations.loadDataError(snapshot.error.toString())));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text(localizations.noPlaceFound));
                    }

                    final places = snapshot.data!;
                    return ListView.separated(
                      itemCount: places.length,
                      separatorBuilder: (context, idx) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final place = places[index];
                        return Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: place.imageUrls.isNotEmpty && place.imageUrls.first.isNotEmpty                   
                                  ? Image.network(
                                      place.imageUrls.first,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.broken_image, size: 60),
                                    )
                                  : Image.asset(
                                      'assets/placeholder_image.png',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              place.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 18),
                                Text(place.rating.toStringAsFixed(1)),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlaceDetailScreen(placeId: place.id),
                                ),
                              );
                              _historyService.addQuery(_searchQuery);
                              _loadSearchHistory();
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}