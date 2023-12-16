import 'package:MrCarwash/inc/method.dart';
import 'package:flutter/material.dart';

class TestCallbackFun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ParentWidget(),
    );
  }
}

class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  int _counter = 0;

  void incrementCounter() {
    setState(() {
      _counter++;

      dbg(_counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Widget $_counter'),
      ),
      body: Center(
        child: ChildWidget(callback: incrementCounter),
      ),
      // ...
    );
  }
}

class ChildWidget extends StatelessWidget {
  final VoidCallback callback;

  const ChildWidget({required this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Trigger callback to update ParentWidget's state
        callback();
      },
      child: Container(
        width: 200,
        height: 200,
        color: Colors.blue,
        child: Center(
          child: Text(
            'Tap me',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
