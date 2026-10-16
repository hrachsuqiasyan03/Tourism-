import 'package:flutter/material.dart';

import '../data/mock_places.dart';
import '../models/place.dart';
import '../services/search_history_service.dart';
import '../widgets/place_card.dart';
import 'place_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Place> filteredPlaces = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void searchPlaces(String query) {
    final search = query.trim().toLowerCase();
    if (search.isEmpty) {
      setState(() {
        filteredPlaces = [];
      });
      return;
    }

    final results = places.where((place) {
      final name = place.name.toLowerCase();
      final city = place.city.toLowerCase();

      return name.contains(search) || city.contains(search);
    }).toList();

    setState(() {
      filteredPlaces = results;
    });
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      SearchHistoryService.addQuery(query);
      searchPlaces(query);
    }
  }

  void _selectHistoryItem(String query) {
    _searchController.text = query;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    SearchHistoryService.addQuery(query);
    searchPlaces(query);
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim();
    final isQueryEmpty = query.isEmpty;
    final history = SearchHistoryService.history;

    return Scaffold(
      appBar: AppBar(title: const Text('Որոնում')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: searchPlaces,
              onSubmitted: _onSearchSubmitted,
              decoration: InputDecoration(
                hintText: 'Որոնել ուղղություններ...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          searchPlaces('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isQueryEmpty
                  ? (history.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Որոնեք քաղաքներ կամ վայրեր',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Ձեր որոնման պատմությունը կհայտնվի այստեղ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Վերջին որոնումները',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      SearchHistoryService.clearHistory();
                                    });
                                  },
                                  child: const Text('Ջնջել բոլորը'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: ListView.separated(
                                itemCount: history.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final item = history[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: const Icon(
                                      Icons.history,
                                      color: Colors.grey,
                                    ),
                                    title: Text(item),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          SearchHistoryService.removeQuery(item);
                                        });
                                      },
                                    ),
                                    onTap: () => _selectHistoryItem(item),
                                  );
                                },
                              ),
                            ),
                          ],
                        ))
                  : (filteredPlaces.isEmpty
                      ? const Center(
                          child: Text(
                            'Ոչ մի ուղղություն չի գտնվել',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredPlaces.length,
                          itemBuilder: (context, index) {
                            final place = filteredPlaces[index];

                            return PlaceCard(
                              place: place,
                              onTap: () {
                                SearchHistoryService.addQuery(query);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PlaceDetailsScreen(place: place),
                                  ),
                                );
                              },
                            );
                          },
                        )),
            ),
          ],
        ),
      ),
    );
  }
}
