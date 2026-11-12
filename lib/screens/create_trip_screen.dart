import 'package:flutter/material.dart';

import '../data/mock_places.dart';
import '../models/trip.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key, this.trip});

  final Trip? trip;

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  static const _forest = Color(0xFF17453D);
  static const _preferences = [
    'Պատմություն',
    'Մշակույթ',
    'Բնություն և լեռներ',
    'Արկածներ',
    'Ընտանեկան',
    'Հանգիստ',
  ];

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  DateTime _start = DateUtils.dateOnly(DateTime.now());
  DateTime _end = DateUtils.dateOnly(DateTime.now())
      .add(const Duration(days: 3));
  int _travelers = 2;
  String _cover = '';
  final Set<String> _selectedPreferences = {};

  @override
  void initState() {
    super.initState();
    _cover = places.first.imagePath;
    final trip = widget.trip;
    if (trip != null) {
      _name.text = trip.name;
      _description.text = trip.description;
      _start = trip.startDate;
      _end = trip.endDate;
      _travelers = trip.numberOfTravelers;
      _cover = trip.coverImage.isEmpty ? _cover : trip.coverImage;
      _selectedPreferences.addAll(trip.preferences);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  String _date(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}.${value.month.toString().padLeft(2, '0')}.${value.year}';

  Future<void> _selectDate({required bool start}) async {
    final chosen = await showDatePicker(
      context: context,
      initialDate: start ? _start : _end,
      firstDate: start
          ? (widget.trip == null
                ? DateUtils.dateOnly(DateTime.now())
                : DateTime(2000))
          : _start,
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (chosen == null || !mounted) return;
    setState(() {
      if (start) {
        _start = DateUtils.dateOnly(chosen);
        if (_end.isBefore(_start)) _end = _start;
      } else {
        _end = DateUtils.dateOnly(chosen);
      }
    });
  }

  void _create() {
    if (!_formKey.currentState!.validate()) return;
    if (_end.isBefore(_start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ավարտի օրը չի կարող մեկնարկից շուտ լինել։'),
        ),
      );
      return;
    }
    final existing = widget.trip;
    if (existing == null) {
      Navigator.pop(
        context,
        Trip(
          id: DateTime.now().microsecondsSinceEpoch,
          name: _name.text.trim(),
          description: _description.text.trim(),
          startDate: _start,
          endDate: _end,
          places: const [],
          coverImage: _cover,
          numberOfTravelers: _travelers,
          preferences: _selectedPreferences.toList(),
        ),
      );
      return;
    }

    final updated = Trip(
      id: existing.id,
      name: _name.text.trim(),
      description: _description.text.trim(),
      startDate: _start,
      endDate: _end,
      places: const [],
      coverImage: _cover,
      numberOfTravelers: _travelers,
      preferences: _selectedPreferences.toList(),
      estimatedBudget: existing.estimatedBudget,
      expenses: List.of(existing.expenses),
    );
    for (final day in existing.days) {
      final targetIndex = day.dayNumber - 1;
      if (targetIndex >= updated.days.length) continue;
      for (final visit in day.places) {
        updated.days[targetIndex].places.add(
          TripPlace(
            place: visit.place,
            arrivalTime: updated.days[targetIndex].date.add(
              Duration(
                hours: visit.arrivalTime.hour,
                minutes: visit.arrivalTime.minute,
              ),
            ),
            visitMinutes: visit.visitMinutes,
            notes: visit.notes,
          ),
        );
      }
    }
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.trip == null
            ? 'Նոր ճանապարհորդություն'
            : 'Խմբագրել ճանապարհորդությունը',
      ),
    ),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
        children: [
          Text(
            'Պլանավորեք ձեր հաջորդ արկածը',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Անհատականացրեք ուղևորությունը, ուղղություններն ավելացրեք ավելի ուշ։',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 22),
          TextFormField(
            controller: _name,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Ճանապարհորդության անունը',
              prefixIcon: Icon(Icons.edit_rounded),
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Մուտքագրեք ճանապարհորդության անունը'
                : null,
          ),
          const SizedBox(height: 18),
          const Text(
            'Շապիկի լուսանկար',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: places.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final place = places[index];
                final selected = _cover == place.imagePath;
                return GestureDetector(
                  onTap: () => setState(() => _cover = place.imagePath),
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected ? _forest : Colors.transparent,
                        width: 3,
                      ),
                      image: DecorationImage(
                        image: AssetImage(place.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.all(9),
                    child: Text(
                      place.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _dateTile(
                  'Մեկնում',
                  _date(_start),
                  () => _selectDate(start: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _dateTile(
                  'Վերադարձ',
                  _date(_end),
                  () => _selectDate(start: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Card(
            child: ListTile(
              leading: const Icon(Icons.people_alt_outlined, color: _forest),
              title: const Text('Ճանապարհորդներ'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _travelers > 1
                        ? () => setState(() => _travelers--)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text(
                    '$_travelers',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: _travelers < 20
                        ? () => setState(() => _travelers++)
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _description,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Նկարագրություն (ըստ ցանկության)',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Ի՞նչն է ձեզ հետաքրքրում',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _preferences
                .map(
                  (preference) => FilterChip(
                    label: Text(preference),
                    selected: _selectedPreferences.contains(preference),
                    onSelected: (selected) => setState(
                      () => selected
                          ? _selectedPreferences.add(preference)
                          : _selectedPreferences.remove(preference),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: _create,
              icon: Icon(
                widget.trip == null
                    ? Icons.add_road_rounded
                    : Icons.save_outlined,
              ),
              label: Text(
                widget.trip == null
                    ? 'Ստեղծել ճանապարհորդություն'
                    : 'Պահպանել փոփոխությունները',
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _dateTile(String title, String value, VoidCallback onTap) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  size: 17,
                  color: _forest,
                ),
                const SizedBox(width: 7),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
