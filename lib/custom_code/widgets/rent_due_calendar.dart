// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class _PopupItem {
  _PopupItem({
    required this.title,
    this.body,
    this.amount, // int or double are fine
    this.icon = Icons.event,
  });

  final String title;
  final String? body; // notes
  final num? amount; // supports int or double
  final IconData icon;
}

IconData _iconForType(String? t) {
  switch ((t ?? '').toLowerCase()) {
    case 'inspection':
      return Icons.build_outlined;
    case 'move_in':
      return Icons.login_outlined;
    case 'move_out':
      return Icons.logout_outlined;
    case 'valuation':
      return Icons.assessment_outlined;
    case 'rent':
      return Icons.payments_outlined;
    case 'gas':
      return Icons.gas_meter;
    case 'electricity':
      return Icons.bolt;
    default:
      return Icons.event;
  }
}

class RentDueCalendar extends StatefulWidget {
  const RentDueCalendar({
    super.key,
    this.width,
    this.height,
    this.rentDueDates, // List<DateTime> of rent days
    this.otherEventDates, // List<DateTime> of other single‑day events
    this.events, // List<EventsRecord> for popup details
    this.rentAmount,
  });

  final double? width;
  final double? height;
  final List<DateTime>? rentDueDates;
  final List<DateTime>? otherEventDates;
  final List<EventsRecord>? events;
  final double? rentAmount;

  @override
  State<RentDueCalendar> createState() => _RentDueCalendarState();
}

class _RentDueCalendarState extends State<RentDueCalendar> {
  static const _todayBlue = Color(0xFF153048);
  static const _eventGreen = Color(0xFF33B56B);

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _inList(List<DateTime>? list, DateTime day) =>
      list?.any((d) => isSameDate(d, day)) ?? false;

  bool isRentDue(DateTime day) => _inList(widget.rentDueDates, day);
  bool hasOtherEvent(DateTime day) => _inList(widget.otherEventDates, day);

  List<EventsRecord> _eventsForDay(DateTime day) {
    final list = widget.events ?? const <EventsRecord>[];
    return list.where((e) {
      final d = e.startDate;
      if (d == null) return false;
      final dt = DateTime(d.year, d.month, d.day);
      return isSameDate(dt, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2035, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });

        final dayEvents = _eventsForDay(selectedDay);

        // Build popup items: a synthetic Rent Due + real events
        final items = <_PopupItem>[
          if (isRentDue(selectedDay))
            _PopupItem(
              title: 'Rent Due',
              amount: widget.rentAmount,
              icon: Icons.payments_outlined,
            ),
          ...dayEvents.map((e) => _PopupItem(
                title: (e.title ?? e.type ?? 'Event').toString(),
                body: (e.notes ?? '').trim().isEmpty ? null : e.notes!.trim(),
                amount: e.amount, // int OK
                icon: _iconForType(e.type),
              )),
        ];

        if (items.isEmpty) return;

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(DateFormat('d MMM yyyy').format(selectedDay)),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480, maxHeight: 360),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 16),
                itemBuilder: (_, i) {
                  final it = items[i];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(it.icon, color: _eventGreen),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title + optional amount right-aligned
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    it.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (it.amount != null && it.amount != 0)
                                  Text(
                                    NumberFormat.currency(
                                            symbol: '£', decimalDigits: 0)
                                        .format(it.amount),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ],
                            ),
                            if (it.body != null) ...[
                              const SizedBox(height: 4),
                              Text(it.body!,
                                  style: const TextStyle(height: 1.35)),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              )
            ],
          ),
        );
      },
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: _todayBlue, // today = blue
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: _eventGreen, // selected = solid green
          shape: BoxShape.circle,
        ),
        defaultTextStyle: TextStyle(color: Colors.black),
      ),
      calendarBuilders: CalendarBuilders(
        // Draw the same green ring for ANY event (rent or other).
        defaultBuilder: (context, day, _) {
          final hasEvent = isRentDue(day) || hasOtherEvent(day);
          if (!hasEvent) return null;

          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: _eventGreen, width: 2),
              shape: BoxShape.circle,
            ),
            child:
                Text('${day.day}', style: const TextStyle(color: Colors.black)),
          );
        },
      ),
    );
  }
}
