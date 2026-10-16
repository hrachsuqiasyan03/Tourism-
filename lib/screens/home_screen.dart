import 'package:flutter/material.dart';

import '../data/categories.dart';
import '../data/mock_places.dart' as mock;
import '../data/mock_regions.dart';
import '../models/place.dart';
import '../models/region.dart';
import 'map.dart';
import 'place_details_screen.dart';
import 'region_details_screen.dart';
import 'search_screen.dart';

const _forest = Color(0xFF17453D);
const _muted = Color(0xFF737B75);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _query = TextEditingController();
  final _scroll = ScrollController();
  String _filter = '';
  CategoryType _selectedCategory = CategoryType.all;

  @override
  void dispose() {
    _query.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _showDestinations() => _scroll.animateTo(
    440,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeOutCubic,
  );

  void _selectCategory(CategoryType category) {
    setState(() {
      _selectedCategory = category;
      _filter = '';
      _query.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get places filtered by category and search
    var places = getPlacesByCategory(mock.cities, _selectedCategory);

    // Apply text search filter
    if (_filter.trim().isNotEmpty) {
      final value = _filter.trim().toLowerCase();
      places = places.where((place) {
        return place.name.toLowerCase().contains(value) ||
            place.description.toLowerCase().contains(value) ||
            place.city.toLowerCase().contains(value);
      }).toList();
    }

    // Get regions for the regions section
    final results = regions.where((region) {
      final value = _filter.trim().toLowerCase();
      return value.isEmpty ||
          region.name.toLowerCase().contains(value) ||
          region.biggestCity.toLowerCase().contains(value);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.explore, size: 25),
            const SizedBox(width: 9),
            const Text('ArmTravel', style: TextStyle(letterSpacing: -.3)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Գտնել վայրեր',
            icon: const Icon(Icons.search_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Զննել քարտեզը',
            icon: const Icon(Icons.map_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MapScreen()),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Scrollbar(
        controller: _scroll,
        thumbVisibility: true,
        child: CustomScrollView(
          controller: _scroll,
          slivers: [
            SliverToBoxAdapter(child: _hero(context)),
            // Categories section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ԶՆՆԵԼ ՈՒՂԳՐՈՒԹՅԱՆԸ ըստ տեսակի',
                      style: TextStyle(
                        color: _forest.withValues(alpha: .75),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _categoryRow(),
                  ],
                ),
              ),
            ),
            // Places section (shown when a category is selected)
            if (_selectedCategory != CategoryType.all)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedCategory.label,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF202925),
                            ),
                          ),
                          Text(
                            '${places.length} վայր',
                            style: TextStyle(
                              fontSize: 13,
                              color: _selectedCategory.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedCategory.description,
                        style: const TextStyle(color: _muted, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: TextField(
                  controller: _query,
                  onChanged: (value) => setState(() => _filter = value),
                  decoration: InputDecoration(
                    hintText: _selectedCategory == CategoryType.all
                        ? 'Որոնել վայրեր, քաղաքներ կամ մարզեր'
                        : 'Որոնել ${_selectedCategory.label}',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: _forest,
                    ),
                    suffixIcon: _filter.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _query.clear();
                              setState(() => _filter = '');
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                  ),
                ),
              ),
            ),
            // Places grid
            if (_selectedCategory != CategoryType.all)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 260,
                  child: places.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 48,
                                color: _muted.withValues(alpha: .5),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Ոչ մի վայր չի գտնվել',
                                style: const TextStyle(
                                  color: _muted,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                          itemCount: places.length,
                          itemBuilder: (context, index) => _PlaceCard(
                            place: places[index],
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PlaceDetailsScreen(place: places[index]),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            // Regions section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ՀԱՅԱՍՏԱՆԻ ՄԱՐԶԵՐ',
                      style: TextStyle(
                        color: _forest.withValues(alpha: .75),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Բոլոր ուղղությունները',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF202925),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Զննեք 11 մարզերը՝ ալպյան լճերից մինչև հնագույն վանքեր.',
                      style: TextStyle(color: _muted, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            if (results.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(28),
                  child: Center(child: Text('Ոչ մի մարզ չի համապատասխանում որոնմանը.')),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.crossAxisExtent;
                    final columns = width > 900
                        ? 4
                        : width > 580
                        ? 3
                        : 2;
                    return SliverGrid.builder(
                      itemCount: results.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: width > 580 ? 1.08 : .78,
                      ),
                      itemBuilder: (context, index) => _RegionCard(
                        region: results[index],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RegionDetailsScreen(region: results[index]),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            SliverToBoxAdapter(child: _footer()),
          ],
        ),
      ),
    );
  }

  /// Horizontal scrollable row of category cards
  Widget _categoryRow() {
    final categories = CategoryType.values;
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => _selectCategory(category),
              child: SizedBox(
                width: 150,
                child: Card(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: isSelected
                          ? Border.all(color: category.color, width: 2.5)
                          : null,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Colored top bar
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 4,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: category.color,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(18),
                              ),
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(category.icon, size: 26, color: category.color),
                              const SizedBox(height: 6),
                              Text(
                                category.label,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected ? category.color : const Color(0xFF202925),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                category.description,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: _muted,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _hero(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;
    return SizedBox(
      height: compact ? 340 : 390,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/regions/Sevan.jpg', fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: .16),
                  Colors.black.withValues(alpha: .68),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 30, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .18),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Text(
                    'ԻՐԱՎՈՒՆՔՆԵՐԻ ԵՐԿԻՐ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Գտեք հոգին\nՀայաստանի',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 34 : 44,
                    height: 1.05,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  'Լեռներ, հիշողություններ և պահեր, որոնք մնում են ձեզ հետ.',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: _showDestinations,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE2AA76),
                    foregroundColor: const Color(0xFF25352F),
                  ),
                  icon: const Icon(Icons.arrow_downward_rounded, size: 18),
                  label: const Text('Զննել ուղղությունները'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer() => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(22, 25, 22, 25),
    color: _forest,
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ArmTravel',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 7),
        Text(
          'Բացահայտիր Հայաստանը՝ վանքերից մինչև լեռնային լճեր։.',
          style: TextStyle(color: Colors.white70, height: 1.45),
        ),
        SizedBox(height: 14),
        Text(
          'Մեր մասին     Կապ',
          style: TextStyle(
            color: Color(0xFFE2AA76),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: .7,
          ),
        ),
      ],
    ),
  );
}

/// Horizontal card for a single place in the category section
class _PlaceCard extends StatelessWidget {
  const _PlaceCard({required this.place, required this.onTap});
  final Place place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 14),
    child: SizedBox(
      width: 170,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      place.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFE6E8E2),
                        child: const Icon(
                          Icons.place_outlined,
                          size: 32,
                          color: _muted,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .92),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, size: 11, color: Color(0xFFFFB300)),
                            const SizedBox(width: 2),
                            Text(
                              '${place.rating}',
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF202925),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF202925),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      place.city,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10, color: _muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _RegionCard extends StatelessWidget {
  const _RegionCard({required this.region, required this.onTap});
  final Region region;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  region.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFE6E8E2),
                    child: const Icon(
                      Icons.landscape_outlined,
                      size: 40,
                      color: _muted,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .92),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.place_rounded, size: 13, color: _forest),
                        SizedBox(width: 3),
                        Text(
                          'ՀԱՅԱՍՏԱՆ',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: _forest,
                            letterSpacing: .4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 10, 11),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        region.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF202925),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        region.biggestCity,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: _muted),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: _forest,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
