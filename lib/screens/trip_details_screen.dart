import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/trip.dart';
import '../services/trip_repository.dart';
import 'create_trip_screen.dart';
import 'destination_selection_screen.dart';
import 'place_details_screen.dart';

class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({super.key, required this.trip});

  final Trip trip;

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  static const _forest = Color(0xFF17453D);
  late Trip _trip;
  int _dayIndex = 0;
  int _section = 0;

  @override
  void initState() {
    super.initState();
    _trip = widget.trip;
  }

  void _changed() {
    TripRepository.update(_trip);
    setState(() {});
  }

  String _date(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';

  double _distanceKm(TripPlace first, TripPlace second) {
    const radius = 6371.0;
    final lat1 = first.place.latitude * math.pi / 180;
    final lat2 = second.place.latitude * math.pi / 180;
    final deltaLat =
        (second.place.latitude - first.place.latitude) * math.pi / 180;
    final deltaLon =
        (second.place.longitude - first.place.longitude) * math.pi / 180;
    final a =
        math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(deltaLon / 2) *
            math.sin(deltaLon / 2);
    return radius * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  Future<void> _addDestination() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => DestinationSelectionScreen(trip: _trip),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _editTrip() async {
    final result = await Navigator.push<Trip>(
      context,
      MaterialPageRoute(builder: (_) => CreateTripScreen(trip: _trip)),
    );
    if (result == null || !mounted) return;
    _trip = result;
    TripRepository.update(_trip);
    setState(() => _dayIndex = math.min(_dayIndex, _trip.days.length - 1));
  }

  Future<void> _visitActions(TripPlace visit) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Ժամանումի ժամը'),
              onTap: () => Navigator.pop(context, 'time'),
            ),
            ListTile(
              leading: const Icon(Icons.hourglass_bottom),
              title: const Text('Այցի տևողությունը'),
              onTap: () => Navigator.pop(context, 'duration'),
            ),
            ListTile(
              leading: const Icon(Icons.sticky_note_2_outlined),
              title: const Text('Անձնական նշումներ'),
              onTap: () => Navigator.pop(context, 'notes'),
            ),
            ListTile(
              leading: const Icon(Icons.drive_file_move_outline),
              title: const Text('Տեղափոխել այլ օր'),
              onTap: () => Navigator.pop(context, 'move'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text(
                'Հեռացնել ուղևորությունից',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (!mounted || action == null) return;
    final day = _trip.days[_dayIndex];
    if (action == 'time') {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(visit.arrivalTime),
      );
      if (time == null) return;
      visit.arrivalTime = DateTime(
        day.date.year,
        day.date.month,
        day.date.day,
        time.hour,
        time.minute,
      );
    } else if (action == 'duration') {
      final minutes = await showDialog<int>(
        context: context,
        builder: (context) {
          var selected = visit.visitMinutes;
          return StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
              title: const Text('Այցի տևողությունը'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$selected րոպե',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Slider(
                    min: 15,
                    max: 360,
                    divisions: 23,
                    value: selected.toDouble(),
                    onChanged: (value) =>
                        setDialogState(() => selected = value.round()),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Չեղարկել'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, selected),
                  child: const Text('Պահպանել'),
                ),
              ],
            ),
          );
        },
      );
      if (minutes == null) return;
      visit.visitMinutes = minutes;
    } else if (action == 'notes') {
      final controller = TextEditingController(text: visit.notes);
      final notes = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Անձնական նշումներ'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Ավելացրեք օգտակար մանրամասներ',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Չեղարկել'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Պահպանել'),
            ),
          ],
        ),
      );
      controller.dispose();
      if (notes == null) return;
      visit.notes = notes;
    } else if (action == 'move') {
      final targetDay = await showDialog<int>(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('Ընտրել օր'),
          children: [
            for (var index = 0; index < _trip.days.length; index++)
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, index),
                child: Text(
                  '${_trip.days[index].dayNumber}-րդ օր · ${_date(_trip.days[index].date)}',
                ),
              ),
          ],
        ),
      );
      if (targetDay == null) return;
      day.places.remove(visit);
      final destinationDay = _trip.days[targetDay];
      visit.arrivalTime = destinationDay.date.add(
        Duration(
          hours: visit.arrivalTime.hour,
          minutes: visit.arrivalTime.minute,
        ),
      );
      destinationDay.places.add(visit);
    } else if (action == 'delete') {
      day.places.remove(visit);
    }
    _changed();
  }

  Future<void> _addExpense([int? editIndex]) async {
    final previous = editIndex == null ? null : _trip.expenses[editIndex];
    final result = await showDialog<TripExpense>(
      context: context,
      builder: (context) => _ExpenseDialog(expense: previous),
    );
    if (result == null) return;
    if (editIndex == null) {
      _trip.expenses.add(result);
    } else {
      _trip.expenses[editIndex] = result;
    }
    _changed();
  }

  Future<void> _setBudget() async {
    final controller = TextEditingController(
      text: _trip.estimatedBudget == 0
          ? ''
          : _trip.estimatedBudget.toStringAsFixed(0),
    );
    void saveBudget(BuildContext dialogContext) {
      final parsed = _parseMoney(controller.text);
      if (parsed == null || parsed < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Մուտքագրեք վավեր՝ զրոյից ոչ պակաս գումար։'),
          ),
        );
        return;
      }
      Navigator.pop(dialogContext, parsed);
    }

    final value = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Նախահաշվային բյուջե'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => saveBudget(context),
          decoration: const InputDecoration(
            prefixText: '֏ ',
            hintText: 'Օրինակ՝ 250000',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Չեղարկել'),
          ),
          FilledButton(
            onPressed: () => saveBudget(context),
            child: const Text('Պահպանել'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value == null) return;
    _trip.estimatedBudget = value;
    _changed();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(_trip.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: [
        IconButton(
          tooltip: 'Խմբագրել',
          onPressed: _editTrip,
          icon: const Icon(Icons.edit_outlined),
        ),
      ],
    ),
    body: Column(
      children: [
        _tripHeader(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: SegmentedButton<int>(
            segments: const [
              ButtonSegment(
                value: 0,
                icon: Icon(Icons.route_outlined),
                label: Text('Օրակարգ'),
              ),
              ButtonSegment(
                value: 1,
                icon: Icon(Icons.account_balance_wallet_outlined),
                label: Text('Բյուջե'),
              ),
            ],
            selected: {_section},
            onSelectionChanged: (selection) =>
                setState(() => _section = selection.first),
          ),
        ),
        Expanded(child: _section == 0 ? _itinerary() : _budget()),
      ],
    ),
  );

  Widget _tripHeader() => SizedBox(
    height: 190,
    child: Stack(
      fit: StackFit.expand,
      children: [
        if (_trip.coverImage.isNotEmpty)
          Image.asset(
            _trip.coverImage,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: _forest),
          )
        else
          Container(color: _forest),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Color(0xDD102A25)],
            ),
          ),
        ),
        Positioned(
          left: 18,
          right: 18,
          bottom: 14,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _infoPill(
                    Icons.calendar_month_outlined,
                    '${_date(_trip.startDate)} — ${_date(_trip.endDate)}',
                  ),
                  const SizedBox(width: 8),
                  _infoPill(Icons.people_outline, '${_trip.numberOfTravelers}'),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _trip.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 23,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${_trip.places.length} ուղղություն  ·  ${_trip.status}',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _infoPill(IconData icon, String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .2),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 15),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    ),
  );

  Widget _itinerary() {
    final day = _trip.days[_dayIndex];
    return Column(
      children: [
        if (_trip.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 2),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _trip.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
          ),
        SizedBox(
          height: 74,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            scrollDirection: Axis.horizontal,
            itemCount: _trip.days.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = _trip.days[index];
              return ChoiceChip(
                selected: _dayIndex == index,
                onSelected: (_) => setState(() => _dayIndex = index),
                label: Text(
                  'ՕՐ ${item.dayNumber}  ·  ${_date(item.date)}   (${item.places.length})',
                ),
                selectedColor: const Color(0xFFDCEAE3),
              );
            },
          ),
        ),
        Expanded(
          child: day.places.isEmpty
              ? _emptyDay()
              : ReorderableListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 2, 16, 12),
                  itemCount: day.places.length,
                  onReorderItem: (oldIndex, newIndex) {
                    final visit = day.places.removeAt(oldIndex);
                    day.places.insert(newIndex, visit);
                    if (day.places.isNotEmpty) {
                      var nextArrival = day.places.first.arrivalTime;
                      for (var index = 1; index < day.places.length; index++) {
                        nextArrival = nextArrival.add(
                          Duration(
                            minutes: day.places[index - 1].visitMinutes + 30,
                          ),
                        );
                        day.places[index].arrivalTime = nextArrival;
                      }
                    }
                    _changed();
                  },
                  itemBuilder: (context, index) {
                    final visit = day.places[index];
                    final next = index + 1 < day.places.length
                        ? day.places[index + 1]
                        : null;
                    return Column(
                      key: ValueKey('${visit.place.id}-${day.dayNumber}'),
                      children: [
                        Card(
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PlaceDetailsScreen(place: visit.place),
                              ),
                            ),
                            borderRadius: BorderRadius.circular(18),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        TimeOfDay.fromDateTime(
                                          visit.arrivalTime,
                                        ).format(context),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: _forest,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          color: _forest,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      if (index < day.places.length - 1)
                                        Container(
                                          width: 2,
                                          height: 64,
                                          color: const Color(0xFFDCE4DF),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      visit.place.imagePath,
                                      width: 82,
                                      height: 82,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => Container(
                                        width: 82,
                                        height: 82,
                                        color: Colors.black12,
                                        child: const Icon(Icons.place),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          visit.place.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '${visit.place.type} · ${visit.visitMinutes} րոպե',
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ),
                                        if (visit.notes.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 5,
                                            ),
                                            child: Text(
                                              visit.notes,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Կառավարել այցը',
                                    onPressed: () => _visitActions(visit),
                                    icon: const Icon(Icons.more_vert),
                                  ),
                                  ReorderableDragStartListener(
                                    index: index,
                                    child: const Padding(
                                      padding: EdgeInsets.only(top: 12),
                                      child: Icon(
                                        Icons.drag_handle,
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (next != null)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 38,
                              top: 2,
                              bottom: 6,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.directions_car_outlined,
                                  size: 15,
                                  color: Colors.black45,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Ուղիղ գծով ${_distanceKm(visit, next).toStringAsFixed(1)} կմ · գնահատված մոտ ${(_distanceKm(visit, next) / 55 * 60).round()} րոպե',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              onPressed: _addDestination,
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text('Ավելացնել ուղղություն'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _emptyDay() => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              color: Color(0xFFE6EFEA),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.route_rounded, size: 38, color: _forest),
          ),
          const SizedBox(height: 14),
          const Text(
            'Այս օրվա ծրագիրը դեռ դատարկ է',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            'Ընտրեք Հայաստանի տեսարժան վայրերից՝ ձեր օրը կազմելու համար։',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 15),
          FilledButton.icon(
            onPressed: _addDestination,
            icon: const Icon(Icons.add),
            label: const Text('Ընտրել ուղղություններ'),
          ),
        ],
      ),
    ),
  );

  Widget _budget() => ListView(
    padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
    children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ճանապարհորդության բյուջե',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    onPressed: _setBudget,
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Փոխել բյուջեն',
                  ),
                ],
              ),
              Text(
                _money(_trip.actualExpenses),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: _forest,
                ),
              ),
              Text(
                'ծախսված ${_trip.estimatedBudget > 0 ? '· ${_money(_trip.estimatedBudget)} նախատեսված' : '· սահմանեք ձեր նախահաշիվը'}',
                style: const TextStyle(color: Colors.black54),
              ),
              if (_trip.estimatedBudget > 0) ...[
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: (_trip.actualExpenses / _trip.estimatedBudget).clamp(
                    0,
                    1,
                  ),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                  color: _trip.actualExpenses > _trip.estimatedBudget
                      ? Colors.red
                      : _forest,
                ),
              ],
              const SizedBox(height: 8),
              Text(
                'Մեկ ճանապարհորդի հաշվով՝ ${_money(_trip.actualExpenses / _trip.numberOfTravelers)}',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Ծախսեր',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          TextButton.icon(
            onPressed: _addExpense,
            icon: const Icon(Icons.add),
            label: const Text('Ավելացնել'),
          ),
        ],
      ),
      if (_trip.expenses.isEmpty)
        const Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Text(
                'Ծախսեր դեռ չկան։ Ավելացրեք ձեր առաջին ծախսը։',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
      else ...[
        ...TripExpenseCategory.values.map((category) {
          final total = _trip.expenses
              .where((expense) => expense.category == category)
              .fold<double>(0, (sum, expense) => sum + expense.amount);
          if (total == 0) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(13),
                child: Row(
                  children: [
                    Text(category.emoji, style: const TextStyle(fontSize: 21)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                category.label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                _money(total),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: _trip.actualExpenses == 0
                                ? 0
                                : total / _trip.actualExpenses,
                            minHeight: 5,
                            borderRadius: BorderRadius.circular(4),
                            color: _forest,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 4),
        ..._trip.expenses.indexed.map((entry) {
          final (index, expense) = entry;
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFE8EFEA),
                child: Text(expense.category.emoji),
              ),
              title: Text(
                expense.description.isEmpty
                    ? expense.category.label
                    : expense.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${expense.category.label} · ${_date(expense.date)}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _money(expense.amount),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') _addExpense(index);
                      if (value == 'delete') {
                        _trip.expenses.removeAt(index);
                        _changed();
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Խմբագրել')),
                      PopupMenuItem(value: 'delete', child: Text('Հեռացնել')),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    ],
  );

  String _money(double amount) => '֏${amount.toStringAsFixed(0)}';
}

class _ExpenseDialog extends StatefulWidget {
  const _ExpenseDialog({this.expense});

  final TripExpense? expense;

  @override
  State<_ExpenseDialog> createState() => _ExpenseDialogState();
}

class _ExpenseDialogState extends State<_ExpenseDialog> {
  late final TextEditingController _amount;
  late final TextEditingController _description;
  late TripExpenseCategory _category;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _amount = TextEditingController(
      text: widget.expense?.amount.toString() ?? '',
    );
    _description = TextEditingController(
      text: widget.expense?.description ?? '',
    );
    _category = widget.expense?.category ?? TripExpenseCategory.food;
    _date = widget.expense?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    super.dispose();
  }

  void _save() {
    final amount = _parseMoney(_amount.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Մուտքագրեք դրական գումար։')),
      );
      return;
    }
    Navigator.pop(
      context,
      TripExpense(
        category: _category,
        amount: amount,
        description: _description.text.trim(),
        date: _date,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    scrollable: true,
    title: Text(widget.expense == null ? 'Նոր ծախս' : 'Խմբագրել ծախսը'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<TripExpenseCategory>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: 'Կատեգորիա'),
            items: TripExpenseCategory.values
                .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text('${category.emoji}  ${category.label}'),
                  ),
                )
                .toList(),
            onChanged: (value) =>
                setState(() => _category = value ?? _category),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Գումար (AMD)',
              prefixText: '֏ ',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _description,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(labelText: 'Նկարագրություն'),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Չեղարկել'),
      ),
      FilledButton(onPressed: _save, child: const Text('Պահպանել')),
    ],
  );
}

double? _parseMoney(String raw) {
  var value = raw.trim().replaceAll(RegExp(r'[\s\u00A0]'), '');
  if (value.isEmpty) return null;

  if (value.contains(',') && value.contains('.')) {
    value = value.replaceAll(',', '');
  } else if (value.contains(',')) {
    final lastComma = value.lastIndexOf(',');
    final decimalDigits = value.length - lastComma - 1;
    value = decimalDigits == 3
        ? value.replaceAll(',', '')
        : value.replaceAll(',', '.');
  }

  final amount = double.tryParse(value);
  return amount != null && amount.isFinite ? amount : null;
}
