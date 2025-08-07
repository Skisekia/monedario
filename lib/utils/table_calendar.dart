import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction_model.dart';
import '../utils/app_header.dart';
import 'package:intl/intl.dart';

class TableCalendarView extends StatefulWidget {
  const TableCalendarView({super.key});

  @override
  State<TableCalendarView> createState() => _TableCalendarViewState();
}

class _TableCalendarViewState extends State<TableCalendarView> {
  late Map<DateTime, List<TransactionModel>> _eventsByDay;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day);
    _eventsByDay = {};
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final txController = Provider.of<TransactionController>(context, listen: false);

    final Map<DateTime, List<TransactionModel>> map = {};
    for (var tx in txController.transactions) {
      final day = DateTime(tx.dueDate.year, tx.dueDate.month, tx.dueDate.day);
      if (!map.containsKey(day)) map[day] = [];
      map[day]!.add(tx);
    }
    setState(() {
      _eventsByDay = map;
    });
  }

  List<TransactionModel> _getEventsForDay(DateTime day) {
    final dateKey = DateTime(day.year, day.month, day.day);
    return _eventsByDay[dateKey] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final paddingH = isTablet ? 30.0 : 12.0;
    final paddingV = isTablet ? 22.0 : 12.0;

    return Scaffold(
      appBar: AppHeader(
        title: "Calendario de pagos",
        showCalendar: false,
        showHome: false,
        showBack: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
        child: Column(
          children: [
            // Calendario bonito y responsivo
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: TableCalendar<TransactionModel>(
                  firstDay: DateTime(DateTime.now().year, DateTime.now().month - 2),
                  lastDay: DateTime(DateTime.now().year, DateTime.now().month + 6, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (d) => isSameDay(d, _selectedDay),
                  calendarFormat: CalendarFormat.month,
                  eventLoader: _getEventsForDay,
                  onDaySelected: (selected, focused) {
                    setState(() {
                      _selectedDay = DateTime(selected.year, selected.month, selected.day);
                      _focusedDay = focused;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    markerDecoration: BoxDecoration(
                      color: const Color(0xFF837AB6),
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: const Color(0xFF250E2C),
                      shape: BoxShape.circle,
                    ),
                    weekendTextStyle: const TextStyle(color: Colors.deepPurple),
                    defaultTextStyle: const TextStyle(fontSize: 15),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekendStyle: TextStyle(color: Colors.deepPurple),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                        fontSize: isTablet ? 22 : 17,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF250E2C)),
                    leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF837AB6)),
                    rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF837AB6)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Detalle de pagos del día
            Text(
              "Pagos para ${DateFormat('dd MMM yyyy', 'es_MX').format(_selectedDay)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 22 : 17,
                color: const Color(0xFF250E2C),
              ),
            ),
            const SizedBox(height: 7),

            Expanded(
              child: _getEventsForDay(_selectedDay).isNotEmpty
                  ? ListView.builder(
                      itemCount: _getEventsForDay(_selectedDay).length,
                      itemBuilder: (_, i) {
                        final tx = _getEventsForDay(_selectedDay)[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 3),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 24 : 14, vertical: 10,
                            ),
                            leading: CircleAvatar(
                              radius: isTablet ? 24 : 20,
                              backgroundColor: const Color(0xFF837AB6).withAlpha(38),
                              child: Icon(Icons.payments, color: Color(0xFF837AB6), size: isTablet ? 30 : 22),
                            ),
                            title: Text(
                              tx.concept,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: isTablet ? 18 : 15,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "Monto: \$${tx.amount.toStringAsFixed(2)}   |   ${tx.type.name.toUpperCase()}",
                                style: TextStyle(fontSize: isTablet ? 15 : 12),
                              ),
                            ),
                            trailing: Text(
                              DateFormat('hh:mm a').format(tx.dueDate),
                              style: TextStyle(color: Colors.black54, fontSize: isTablet ? 14 : 12),
                            ),
                            isThreeLine: false,
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: isTablet ? 30 : 14),
                        child: Text(
                          "No hay pagos programados este día.",
                          style: TextStyle(color: Colors.grey, fontSize: isTablet ? 17 : 13),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
