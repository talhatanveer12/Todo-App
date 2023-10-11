import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/widgets/Modal/add_task.dart';
import 'package:todo_app/widgets/bottom_bar.dart';

const List<String> list = <String>['Today', 'Yesterday', '1 Week'];

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _MyCalendarWidgetState();
}

class _MyCalendarWidgetState extends State<CalendarScreen> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(31, 163, 163, 163),
        title: const Center(child: Text('Calendar')),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: CalendarFormat.week,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              withinRangeTextStyle: TextStyle(color: Colors.white),
              defaultTextStyle: TextStyle(color: Colors.white),
                outsideDaysVisible: false,
                canMarkersOverflow: true,
                // todayDecoration: BoxDecoration(
                //     color: Colors.purple,
                //     borderRadius: BorderRadius.all(Radius.circular(10))),
                // selectedDecoration: BoxDecoration(
                //     color: Colors.orange,
                //     borderRadius: BorderRadius.all(Radius.circular(10))),
                todayTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.white)),
            headerStyle: HeaderStyle(
              titleCentered: true,
              titleTextStyle: const TextStyle(color: Colors.white),
              formatButtonDecoration: BoxDecoration(
                
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20.0),
              ),
              formatButtonTextStyle: const TextStyle(color: Colors.white),
              formatButtonShowsNext: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(color: Color.fromARGB(31, 163, 163, 163),),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () => {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                        padding: MaterialStateProperty.all(const EdgeInsets.only(left: 48,right: 48,top: 16,bottom: 16))
                      ),
                      child: const Text(
                        'Today',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                        onPressed: () => {},style: ButtonStyle(
                          backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                        padding: MaterialStateProperty.all(const EdgeInsets.only(left: 48,right: 48,top: 16,bottom: 16))
                        ),
                        child: const Text(
                          'Complete',
                          style: TextStyle(color: Colors.white),
                        ),)
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: MediaQuery.of(context).size.height * .28,
                      child: ListView.separated(
                        
                        itemBuilder: (context, index) {
                          return ListTile(
                            tileColor: const Color.fromARGB(31, 163, 163, 163),
                            leading: SvgPicture.asset(
                              'lib/resources/assets/svg/circle.svg'),
                            title: Text(list[index],style: const TextStyle(color: Colors.white),),
                            subtitle: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              const Text("Last Name",style: TextStyle(color: Colors.white),),
                              Row(children: [
                                Container(color: Colors.purple, child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                              'lib/resources/assets/svg/study.svg'),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 4.0,left: 4.0),
                                        child: Text("University",style: TextStyle(color: Colors.white,fontSize: 10),),
                                      ),
                                    ],
                                  ),
                                )),
                                Container(color: Colors.blue, child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                              'lib/resources/assets/svg/flag.svg',width: 14,height: 14,),
                                      const Text("1",style: TextStyle(color: Colors.white),),
                                    ],
                                  ),
                                )),
                              ],),
                            ],),
                            
                          );
                        },
                        itemCount: list.length,
                        separatorBuilder: (context, index) {
                          return const Padding(padding: EdgeInsets.all(8));
                        },
                      ),
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTaskModal(context);
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color.fromARGB(31, 163, 163, 163),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomBar(),
    );
  }
}

void _addTaskModal(BuildContext context) {
  showModalBottomSheet(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext buildContext) {
        return const AddTask();
      });
}
