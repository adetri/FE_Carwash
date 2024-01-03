import 'package:MrCarwash/inc/req.dart';
import 'package:MrCarwash/page/setting/spot/spot_forn.dart';
import 'package:flutter/material.dart';
import 'package:MrCarwash/inc/method.dart';
import 'package:MrCarwash/page/setting/item/item.dart';
import 'package:MrCarwash/page/setting/setting.dart';

class SpotList extends StatelessWidget {
  const SpotList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(context),
            const SizedBox(height: 25),
            Container(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                  onPressed: () {
                    nav_to(context, SpotFrom());
                  },
                  child: Text("Add")),
            ),
            SpotDataList(),
          ],
        ),
      ),
    );
  }

  Widget header(context) {
    print("this exec");
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            // Handle back button tap
            nav_to(context, Settings());
          },
          child: Container(
            height: 50,
            alignment: Alignment.topLeft,
            child: Image.asset('assets/back.png'),
          ),
        ),
        SizedBox(width: 10),
        Text(
          'Spot',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class SpotDataList extends StatefulWidget {
  const SpotDataList({super.key});

  @override
  State<SpotDataList> createState() => _SpotDataListState();
}

class _SpotDataListState extends State<SpotDataList> {
  Req? req;
  List<dynamic>? spot;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    req = Req(context);
    await req?.init();
    var req_spot = await req?.fetchSpot();
    dbg(req_spot);
    setState(() {
      spot = req_spot?['response']['spot'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: spot == null
          ? Text("Spot No Found")
          : ListView.builder(
              itemCount: spot!.length,
              itemBuilder: (BuildContext context, int index) {
                String category_name = spot![index]['name'];
                // String item_category_name = item![index]['category']['name'];
                // String price = formatCurrency(item![index]['price']);
                // int category_id = item![index]['id'];
                return ExpansionTile(
                  title: Text(category_name),
                  // subtitle: Text("asdasdsa"),
                  children: <Widget>[
                    ListTile(
                      title: Text('Edit'),
                      onTap: () {
                        nav_to(
                            context,
                            SpotFrom(
                              id_spot: spot![index]['id'],
                            ));
                        // nav_to(
                        //     context,
                        //     ItemForm(
                        //       id_item: item![index]['id'],
                        //     ));
                      },
                    ),
                    // ListTile(
                    //   title: Text('Delete'),
                    //   onTap: () {
                    //     // Handle delete tap
                    //     print('Tapped on Delete for ');
                    //   },
                    // ),
                    // Add more ListTile widgets for subcategories as needed
                  ],
                );
              },
            ),
    );
  }
}
