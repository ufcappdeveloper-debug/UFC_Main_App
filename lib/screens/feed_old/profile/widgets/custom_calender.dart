import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const CustomCalendar({super.key, required this.onDateSelected});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  final DateTime _firstDay = DateTime(1950);
  late final DateTime _lastDay;

  late String _locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _locale = Localizations.localeOf(context).languageCode;
  }

  @override
  void initState() {
    super.initState();
    _lastDay = DateTime.now();
    _focusedDay = _lastDay;
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: _locale,
      firstDay: _firstDay,
      lastDay: _lastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      daysOfWeekHeight: 30,
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        selectedDecoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        defaultTextStyle: const TextStyle(fontFamily: 'Arial'),
        weekendTextStyle: const TextStyle(fontFamily: 'Arial'),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekendStyle: TextStyle(fontWeight: FontWeight.bold),
        weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarBuilders: CalendarBuilders(
        headerTitleBuilder: (context, date) {
          final locale =
              Localizations.localeOf(context).toString(); // Get current locale
          final months = List.generate(
              12, (i) => DateFormat.MMMM(locale).format(DateTime(0, i + 1)));
          final years = List.generate(
              _lastDay.year - _firstDay.year + 1, (i) => _firstDay.year + i);

          int selectedMonth = date.month;
          int selectedYear = date.year;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Month Dropdown
                DropdownButton<int>(
                  value: selectedMonth,
                  icon: const Icon(Icons.arrow_drop_down),
                  underline: const SizedBox(),
                  onChanged: (int? newMonth) {
                    if (newMonth != null) {
                      setState(() {
                        DateTime tentative = DateTime(
                            _focusedDay.year, newMonth, _focusedDay.day);
                        // Clamp the new focusedDay to lastDay if it goes beyond
                        if (tentative.isAfter(_lastDay)) {
                          tentative = _lastDay;
                        }
                        _focusedDay = tentative;
                      });
                    }
                  },
                  items: List.generate(12, (index) {
                    return DropdownMenuItem(
                      value: index + 1,
                      child: Text(
                        months[index],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 8),
                // Year Dropdown
                DropdownButton<int>(
                  value: selectedYear,
                  icon: const Icon(Icons.arrow_drop_down),
                  underline: const SizedBox(),
                  onChanged: (int? newYear) {
                    if (newYear != null) {
                      setState(() {
                        DateTime tentative = DateTime(
                            newYear, _focusedDay.month, _focusedDay.day);
                        // Clamp to _lastDay if beyond
                        if (tentative.isAfter(_lastDay)) {
                          tentative = _lastDay;
                        } else if (tentative.isBefore(_firstDay)) {
                          tentative = _firstDay;
                        }
                        _focusedDay = tentative;
                      });
                    }
                  },
                  items: years.map((year) {
                    return DropdownMenuItem(
                      value: year,
                      child: Text(
                        year.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
        defaultBuilder: (context, day, focusedDay) {
          return Center(
            child: Text(
              DateFormat('d', 'en').format(day),
              style: const TextStyle(fontFamily: 'Arial'),
            ),
          );
        },
        selectedBuilder: (context, day, focusedDay) {
          return Container(
            margin: const EdgeInsets.all(6.0),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Text(
              DateFormat('d', 'en').format(day),
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        widget.onDateSelected(selectedDay);
      },
    );
  }
}

class _MonthYearPicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const _MonthYearPicker({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<_MonthYearPicker> createState() => _MonthYearPickerState();
}

class _MonthYearPickerState extends State<_MonthYearPicker> {
  late int selectedYear;
  late int selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialDate.year;
    selectedMonth = widget.initialDate.month;
  }

  List<int> get yearList {
    return List.generate(
      widget.lastDate.year - widget.firstDate.year + 1,
      (index) => widget.firstDate.year + index,
    );
  }

  List<String> get monthList =>
      List.generate(12, (i) => DateFormat.MMMM().format(DateTime(0, i + 1)));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Select Month & Year',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: selectedYear,
                  items: yearList
                      .map((year) => DropdownMenuItem(
                            value: year,
                            child: Text(year.toString()),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => selectedYear = val!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: selectedMonth,
                  items: List.generate(
                    12,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text(monthList[index]),
                    ),
                  ),
                  onChanged: (val) => setState(() => selectedMonth = val!),
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
                DateTime(selectedYear, selectedMonth),
              );
            },
            child: const Text("Select"),
          )
        ],
      ),
    );
  }
}
