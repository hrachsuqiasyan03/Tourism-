import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/trip.dart';
import '../services/trip_repository.dart';
import 'create_trip_screen.dart';
import 'trip_details_screen.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  static const _forest = Color(0xFF17453D);
  String _filter = 'Բոլորը';

  Future<void> _createTrip() async {
    final trip = await Navigator.push<Trip>(
      context,
      MaterialPageRoute(builder: (_) => const CreateTripScreen()),
    );
    if (trip != null) TripRepository.add(trip);
  }

  Future<void> _editTrip(Trip trip) async {
    final updated = await Navigator.push<Trip>(
      context,
      MaterialPageRoute(builder: (_) => CreateTripScreen(trip: trip)),
    );
    if (updated != null) TripRepository.update(updated);
  }

  Future<void> _deleteTrip(Trip trip) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Հեռացնել ճանապարհորդությունը՞'),
        content: Text('«${trip.name}»-ը հեռացվե՞լ ձեր ուղևորություններից։'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Չեղարկել'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Հեռացնել'),
          ),
        ],
      ),
    );
    if (confirmed == true) TripRepository.delete(trip);
  }

  Future<void> _shareTrip(Trip trip) async {
    final text = StringBuffer()
      ..writeln(trip.name)
      ..writeln('${_date(trip.startDate)} — ${_date(trip.endDate)}')
      ..writeln()
      ..writeln('Օրակարգ');
    for (final day in trip.days) {
      text.writeln('Օր ${day.dayNumber} · ${_date(day.date)}');
      for (final visit in day.places) {
        text.writeln(
          '  ${TimeOfDay.fromDateTime(visit.arrivalTime).format(context)} — ${visit.place.name}',
        );
      }
    }
    await Clipboard.setData(ClipboardData(text: text.toString()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ուղևորության ամփոփումը պատճենվել է՝ տարածելու համար։'),
      ),
    );
  }

  String _date(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Իմ ճանապարհորդությունները'),
      actions: [
        IconButton(
          onPressed: _createTrip,
          tooltip: 'Նոր ճանապարհորդություն',
          icon: const Icon(Icons.add_rounded),
        ),
        const SizedBox(width: 4),
      ],
    ),
    body: ValueListenableBuilder<List<Trip>>(
      valueListenable: TripRepository.trips,
      builder: (context, trips, _) {
        final filtered =
            trips
                .where((trip) => _filter == 'Բոլորը' || trip.status == _filter)
                .toList()
              ..sort(
                (first, second) => first.startDate.compareTo(second.startDate),
              );
        if (trips.isEmpty) return _emptyState();
        return LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 760 ? 2 : 1;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _summary(trips)),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 56,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      scrollDirection: Axis.horizontal,
                      children: ['Բոլորը', 'Առաջիկա', 'Ընթացքում', 'Ավարտված']
                          .map((status) {
                            final count = status == 'Բոլորը'
                                ? trips.length
                                : trips
                                      .where((trip) => trip.status == status)
                                      .length;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text('$status  $count'),
                                selected: _filter == status,
                                onSelected: (_) =>
                                    setState(() => _filter = status),
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ),
                ),
                if (filtered.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text('Այս բաժնում ուղևորություններ չկան։'),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _tripCard(filtered[index]),
                        childCount: filtered.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisExtent: 305,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: _createTrip,
      backgroundColor: _forest,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add),
      label: const Text('Ստեղծել ուղևորություն'),
    ),
  );

  Widget _summary(List<Trip> trips) {
    final upcoming = trips.where((trip) => trip.status == 'Առաջիկա').length;
    final ongoing = trips.where((trip) => trip.status == 'Ընթացքում').length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
      child: Row(
        children: [
          Expanded(
            child: _stat('Բոլորը', '${trips.length}', Icons.luggage_outlined),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _stat(
              'Առաջիկա',
              '$upcoming',
              Icons.event_available_outlined,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _stat('Ընթացքում', '$ongoing', Icons.explore_outlined),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, IconData icon) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Row(
        children: [
          Icon(icon, size: 19, color: _forest),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _tripCard(Trip trip) => Card(
    child: InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TripDetailsScreen(trip: trip)),
      ),
      borderRadius: BorderRadius.circular(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 157,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (trip.coverImage.isNotEmpty)
                  Image.asset(
                    trip.coverImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        Container(color: const Color(0xFF17453D)),
                  )
                else
                  Container(color: const Color(0xFF17453D)),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black26,
                        Colors.transparent,
                        Color(0xB3000000),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 4,
                  top: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _status(trip.status),
                      PopupMenuButton<String>(
                        iconColor: Colors.white,
                        onSelected: (action) {
                          if (action == 'open') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TripDetailsScreen(trip: trip),
                              ),
                            );
                          }
                          if (action == 'edit') _editTrip(trip);
                          if (action == 'delete') _deleteTrip(trip);
                          if (action == 'duplicate') {
                            TripRepository.add(trip.duplicate());
                          }
                          if (action == 'share') _shareTrip(trip);
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'open',
                            child: ListTile(
                              dense: true,
                              leading: Icon(Icons.open_in_new),
                              title: Text('Բացել'),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'edit',
                            child: ListTile(
                              dense: true,
                              leading: Icon(Icons.edit_outlined),
                              title: Text('Խմբագրել'),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'duplicate',
                            child: ListTile(
                              dense: true,
                              leading: Icon(Icons.copy_outlined),
                              title: Text('Պատճենել'),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'share',
                            child: ListTile(
                              dense: true,
                              leading: Icon(Icons.share_outlined),
                              title: Text('Կիսվել'),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: ListTile(
                              dense: true,
                              leading: Icon(Icons.delete_outline),
                              title: Text('Հեռացնել'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 12,
                  child: Text(
                    trip.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 15,
                      color: _forest,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${_date(trip.startDate)} — ${_date(trip.endDate)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _detail(Icons.place_outlined, '${trip.places.length} վայր'),
                    const SizedBox(width: 14),
                    _detail(
                      Icons.people_outline,
                      '${trip.numberOfTravelers} ուղևոր',
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: _forest,
                      size: 19,
                    ),
                  ],
                ),
                if (trip.places.isNotEmpty) ...[
                  const SizedBox(height: 7),
                  Text(
                    trip.places
                        .map(
                          (place) =>
                              place.city.isEmpty ? place.name : place.city,
                        )
                        .toSet()
                        .take(2)
                        .join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _status(String status) {
    final ongoing = status == 'Ընթացքում';
    final done = status == 'Ավարտված';
    final color = ongoing
        ? const Color(0xFFB4E1CB)
        : done
        ? const Color(0xFFE0E4E2)
        : const Color(0xFFFFE0B8);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF24332D),
        ),
      ),
    );
  }

  Widget _detail(IconData icon, String label) => Row(
    children: [
      Icon(icon, size: 16, color: Colors.black54),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
    ],
  );

  Widget _emptyState() => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 110),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 178,
            height: 178,
            decoration: const BoxDecoration(
              color: Color(0xFFE7EFEA),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.landscape_rounded,
                  size: 108,
                  color: Color(0xFFB8CDC1),
                ),
                Positioned(
                  right: 32,
                  bottom: 28,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: _forest,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_road, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Ճանապարհորդությունները սկսվում են այստեղ',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'Պլանավորեք ձեր հաջորդ ուղևորությունը Հայաստանում՝ ընտրելով վայրեր, օրեր և բյուջե։',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, height: 1.4),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: _createTrip,
            icon: const Icon(Icons.add),
            label: const Text('Ստեղծել առաջին ուղևորությունը'),
          ),
        ],
      ),
    ),
  );
}
