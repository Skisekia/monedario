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

    // Agrupa transacciones por fecha de vencimiento (solo futuros)
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
    return Scaffold(
      appBar: AppHeader(
        title: "Calendario de pagos",
        showCalendar: false,
        showHome: false,
        showBack: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          children: [
            TableCalendar<TransactionModel>(
              firstDay: DateTime(DateTime.now().year, DateTime.now().month - 2),
              lastDay: DateTime(DateTime.now().year, DateTime.now().month + 4, 31),
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
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Pagos para ${DateFormat('dd MMM yyyy').format(_selectedDay)}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: _getEventsForDay(_selectedDay).isNotEmpty
                  ? ListView.builder(
                      itemCount: _getEventsForDay(_selectedDay).length,
                      itemBuilder: (_, i) {
                        final tx = _getEventsForDay(_selectedDay)[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: const Icon(Icons.payments, color: Color(0xFF837AB6)),
                            title: Text(tx.concept, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text(
                              "Monto: \$${tx.amount.toStringAsFixed(2)}\n"
                              "Tipo: ${tx.type.name.toUpperCase()}",
                            ),
                            trailing: Text(
                              DateFormat('hh:mm a').format(tx.dueDate),
                              style: const TextStyle(color: Colors.black54, fontSize: 12),
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(vertical: 28),
                      child: Text("No hay pagos programados este día.", style: TextStyle(color: Colors.grey)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
