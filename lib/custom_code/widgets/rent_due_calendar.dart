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

import 'index.dart'; // Imports other custom widgets

import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class _PopupItem {
  _PopupItem({
    required this.title,
    this.body,
    this.amount,
    this.icon = Icons.event,
  });

  final String title;
  final String? body;
  final num? amount;
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
    case 'rent_due':
      return Icons.payments_outlined;
    case 'gas':
      return Icons.gas_meter;
    case 'electricity':
      return Icons.bolt;
    default:
      return Icons.event;
  }
}

/// Calendar driven only by [events] (including auto-generated rent_due rows).
class RentDueCalendar extends StatefulWidget {
  const RentDueCalendar({
    super.key,
    this.width,
    this.height,
    this.events,
  });

  final double? width;
  final double? height;
  final List<EventsRecord>? events;

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

  List<EventsRecord> _eventsForDay(DateTime day) {
    final list = widget.events ?? const <EventsRecord>[];
    return list.where((e) {
      final d = e.startDate;
      if (d == null) return false;
      final dt = DateTime(d.year, d.month, d.day);
      return isSameDate(dt, day);
    }).toList();
  }

  bool _hasEventOnDay(DateTime day) => _eventsForDay(day).isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final calendar = TableCalendar(
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
        if (dayEvents.isEmpty) return;

        final items = <_PopupItem>[];
        for (final EventsRecord e in dayEvents) {
          final notes = e.notes.trim();
          items.add(
            _PopupItem(
              title: e.title.isNotEmpty
                  ? e.title
                  : (e.type.isNotEmpty ? e.type : 'Event'),
              body: notes.isEmpty ? null : notes,
              amount: e.amount,
              icon: _iconForType(e.type),
            ),
          );
        }

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
                                      symbol: '£',
                                      decimalDigits: 0,
                                    ).format(it.amount),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ],
                            ),
                            if (it.body != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                it.body!,
                                style: const TextStyle(height: 1.35),
                              ),
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
          color: _todayBlue,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: _eventGreen,
          shape: BoxShape.circle,
        ),
        defaultTextStyle: TextStyle(color: Colors.black),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, _) {
          if (!_hasEventOnDay(day)) return null;

          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: _eventGreen, width: 2),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${day.day}',
              style: const TextStyle(color: Colors.black),
            ),
          );
        },
      ),
    );

    if (widget.width != null || widget.height != null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: calendar,
      );
    }
    return calendar;
  }
}
