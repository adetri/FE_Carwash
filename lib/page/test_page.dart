import 'package:flutter/material.dart';

/// Flutter code sample for [ExpansionTile].

void main() => runApp(const ExpansionTileApp());

class ExpansionTileApp extends StatelessWidget {
  const ExpansionTileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('ExpansionTile Sample')),
        body: const ExpansionTileExample(),
      ),
    );
  }
}

class ExpansionTileExample extends StatefulWidget {
  const ExpansionTileExample({super.key});

  @override
  State<ExpansionTileExample> createState() => _ExpansionTileExampleState();
}

class _ExpansionTileExampleState extends State<ExpansionTileExample> {
  bool _customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // const ExpansionTile(
        //   title: Text('ExpansionTile 1'),
        //   subtitle: Text('Trailing expansion arrow icon'),
        //   children: <Widget>[
        //     ListTile(title: Text('This is tile number 1')),
        //   ],
        // ),
        // ExpansionTile(
        //   title: const Text('ExpansionTile 2'),
        //   subtitle: const Text('Custom expansion arrow icon'),
        //   trailing: Icon(
        //     _customTileExpanded
        //         ? Icons.arrow_drop_down_circle
        //         : Icons.arrow_drop_down,
        //   ),
        //   children: const <Widget>[
        //     ListTile(title: Text('This is tile number 2')),
        //   ],
        //   onExpansionChanged: (bool expanded) {
        //     setState(() {
        //       _customTileExpanded = expanded;
        //     });
        //   },
        // ),
        ExpansionTile(
          backgroundColor: Colors.teal[50],
          title: Text('Klo(B A546 CB)'),
          subtitle: Container(
            // color: Colors.grey,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "NoOrder",
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "03/04/2024 40:30",
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          trailing: Text("Rp.40.000"),
          controlAffinity: ListTileControlAffinity.leading,
          children: <Widget>[
            ListTile(title: Text('This is tile number 3')),
          ],
        ),
        ExpansionTile(
          backgroundColor: Colors.teal[50],
          title: Text('Klo(B A546 CB)'),
          subtitle: Container(
            // color: Colors.grey,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "NoOrder",
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "03/04/2024 40:30",
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          trailing: Text("Rp.40.000"),
          controlAffinity: ListTileControlAffinity.leading,
          children: <Widget>[
            ListTile(title: Text('This is tile number 3')),
          ],
        ),
        ExpansionTile(
          backgroundColor: Colors.teal[50],
          title: Text('Klo(B A546 CB)'),
          subtitle: Container(
            // color: Colors.grey,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "NoOrder",
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "03/04/2024 40:30",
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          trailing: Text("Rp.40.000"),
          controlAffinity: ListTileControlAffinity.leading,
          children: <Widget>[
            ListTile(title: Text('This is tile number 3')),
          ],
        ),
        ExpansionTile(
          backgroundColor: Colors.teal[50],
          title: Text('Klo(B A546 CB)'),
          subtitle: Container(
            // color: Colors.grey,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "NoOrder",
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "03/04/2024 40:30",
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          trailing: Text("Rp.40.000"),
          controlAffinity: ListTileControlAffinity.leading,
          children: <Widget>[
            ListTile(title: Text('This is tile number 3')),
          ],
        ),
        ExpansionTile(
          backgroundColor: Colors.green[400],
          collapsedBackgroundColor: Colors.green[400],
          title: Text('Klo(B A546 CB)'),
          subtitle: Container(
            // color: Colors.grey,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "NoOrder",
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "03/04/2024 40:30",
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          trailing: Text("Rp.40.000"),
          controlAffinity: ListTileControlAffinity.leading,
          children: <Widget>[
            ListTile(title: Text('This is tile number 3')),
          ],
        ),
      ],
    );
  }
}
