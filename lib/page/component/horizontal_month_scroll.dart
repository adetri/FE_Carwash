import 'package:MrCarwash/inc/method.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HorizontalDate extends StatefulWidget {
  HorizontalDate({
    super.key,
    VoidCallback? callback,
  }) {
    this.callback = callback;
  }

  Map<String, dynamic> value = {};

  VoidCallback? callback;

  @override
  State<HorizontalDate> createState() => _HorizontalDateState();
}

class _HorizontalDateState extends State<HorizontalDate> {
  DateTime now = DateTime.now();
  List<Map<String, dynamic>> date_list = [];
  Set<int> selectedDays = {};
  int selectedIndex = 0; // Default no selected index
  int daysInMonth = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  List<dynamic>? tgl;
  void init() {
    set_month();
  }

  int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  int set_days(year, month) {
    if (now.month == month) {
      daysInMonth = now.day;
    } else {
      daysInMonth = getDaysInMonth(year, month);
    }

    return daysInMonth;
  }

  void set_month() {
    setState(() {
      int currentMonth = now.month;
      int currentYear = now.year;
      daysInMonth = set_days(currentYear, currentMonth);
      String monthName = DateFormat.MMM().format(DateTime(2000, currentMonth));
      Map<String, dynamic> newData = {
        'year': currentYear,
        'month_int': currentMonth,
        'month_str': monthName,
        'isTapped': true,
        'day': daysInMonth
        // Add more key-value pairs as needed
      };

      widget.value['year'] = currentYear;
      widget.value['month_str'] = monthName;
      widget.value['month_int'] = currentMonth;
      widget.value['day'] = daysInMonth;

      // Appending the new map to the list

      date_list!.add(newData);

      for (int i = 1; i <= 12; i++) {
        currentMonth -= 1;
        if (currentMonth == 0) {
          currentMonth = 12;
          currentYear -= 1;
        }
        String monthName =
            DateFormat.MMM().format(DateTime(2000, currentMonth));
        Map<String, dynamic> newData = {
          'year': currentYear,
          'month_int': currentMonth,
          'month_str': monthName,
          // Add more key-value pairs as needed
        };
        date_list!.add(newData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: date_list.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> map = entry.value;

              bool isTapped = map['isTapped'] ?? false;

              return GestureDetector(
                onTap: () {
                  if (widget.callback != null) {
                    widget.callback!();
                  }
                  setState(() {
                    for (int i = 0; i < date_list.length; i++) {
                      if (i != index) {
                        date_list[i]['isTapped'] = false;
                      }
                    }
                    daysInMonth = set_days(map['year'], map['month_int']);

                    date_list[index]['isTapped'] = true;
                    widget.value['year'] = map['year'];
                    widget.value['month_str'] = map['month_str'];
                    widget.value['month_int'] = map['month_int'];
                    widget.value['day'] = daysInMonth;
                    selectedIndex = 0;

                    print(selectedIndex);
                    // print(daysInMonth);
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(5),
                  width: 60,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isTapped
                        ? Color.fromARGB(255, 154, 152, 147)
                        : Colors.transparent,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Text("${map['year']}"),
                        Text(
                          "${map['month_str']}",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(daysInMonth, (index) {
              int date = daysInMonth - index;
              bool is_block = selectedIndex == index ? true : false;
              return GestureDetector(
                onTap: () {
                  if (widget.callback != null) {
                    widget.callback!();
                  }
                  setState(() {
                    daysInMonth = set_days(
                        widget.value['year'], widget.value['month_int']);

                    selectedIndex = index; // Update the selected index
                    widget.value['day'] = date;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: is_block
                        ? Color.fromARGB(255, 154, 152, 147)
                        : Colors.transparent,
                  ),
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 5.0),
                  child: Text('${date}'),
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}

class TestRunHorizontalDate extends StatefulWidget {
  TestRunHorizontalDate({super.key});

  @override
  State<TestRunHorizontalDate> createState() => _TestRunHorizontalDateState();
}

class _TestRunHorizontalDateState extends State<TestRunHorizontalDate> {
  int counter = 0;
  late HorizontalDate tgl;
  void test_strem() {
    setState(() {
      counter += 1;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    tgl = HorizontalDate(
      callback: test_strem,
    );
    await tgl.value;

    setState(() {
      tgl.value = tgl.value;
    });
    dbg(tgl.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(child: tgl),
            tgl.value.isNotEmpty ? Text(counter.toString()) : Text("kososng")
          ],
        ),
      ),
    );
  }
}
