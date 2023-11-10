import 'package:flutter/material.dart';

class ItemDetail extends StatefulWidget {
  const ItemDetail({Key? key}) : super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  List<Color> containerColors = [
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black
  ];

  void changeColor(int index) {
    setState(() {
      for (int i = 0; i < containerColors.length; i++) {
        if (i == index) {
          containerColors[i] = Colors.blue;
        } else {
          containerColors[i] = Colors.black;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
        backgroundColor: Colors.grey,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: List.generate(
                    containerColors.length,
                    (index) {
                      return GestureDetector(
                        onTap: () {
                          changeColor(index);
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          color: containerColors[index],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
