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

  void set_month() {
    int currentMonth = now.month;
    int currentYear = now.year;
    String monthName = DateFormat.MMM().format(DateTime(2000, currentMonth));
    Map<String, dynamic> newData = {
      'year': currentYear,
      'month_int': currentMonth,
      'month_str': monthName,
      'isTapped': true
      // Add more key-value pairs as needed
    };

    widget.value['year'] = currentYear;
    widget.value['month_str'] = monthName;
    widget.value['month_int'] = currentMonth;
    // Appending the new map to the list

    date_list!.add(newData);

    for (int i = 1; i <= 12; i++) {
      currentMonth -= 1;
      if (currentMonth == 0) {
        currentMonth = 12;
        currentYear -= 1;
      }
      String monthName = DateFormat.MMM().format(DateTime(2000, currentMonth));
      Map<String, dynamic> newData = {
        'year': currentYear,
        'month_int': currentMonth,
        'month_str': monthName,
        // Add more key-value pairs as needed
      };
      date_list!.add(newData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                date_list[index]['isTapped'] = true;

                widget.value['year'] = map['year'];
                widget.value['month_str'] = map['month_str'];
                widget.value['month_int'] = map['month_int'];
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
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
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
