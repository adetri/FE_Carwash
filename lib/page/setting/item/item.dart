import 'package:flutter/material.dart';
import 'package:MrCarwash/inc/method.dart';
import 'package:MrCarwash/inc/req.dart';
import 'package:MrCarwash/page/setting/category/category_form.dart';
import 'package:MrCarwash/page/setting/item/item_form.dart';
import 'package:MrCarwash/page/setting/setting.dart';

class ItemList extends StatelessWidget {
  ItemList({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                const SizedBox(width: 10),
                Text(
                  'Item',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Container(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                  onPressed: () {
                    nav_to(context, ItemForm());
                  },
                  child: Text("Add")),
            ),
            ListItem(),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  ListItem({super.key});

  @override
  State<ListItem> createState() => _ListItemState();
}

List<dynamic>? categories;
List<dynamic>? item;

class _ListItemState extends State<ListItem> {
  Req? req;
  dynamic item_payload = {};

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    req = Req(context);
    await req?.init();
    var req_category = await req?.fetchCategory2();
    item_payload['page'] = 100;
    var req_item = await req?.fetchAllItem(item_payload);
    setState(() {
      item = req_item?['response']['results']['mainitem'];
      dbg(item);
      categories = req_category?['response']['category'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: item == null
          ? Text("item No Found")
          : ListView.builder(
              itemCount: item!.length,
              itemBuilder: (BuildContext context, int index) {
                String item_name = item![index]['name'];
                String item_category_name = item![index]['category']['name'];
                String price = formatCurrency(item![index]['price']);
                // int category_id = item![index]['id'];
                return ExpansionTile(
                  title: Text("${item_name}(${item_category_name})"),
                  subtitle: Text(price),
                  children: <Widget>[
                    ListTile(
                      title: Text('Edit'),
                      onTap: () {
                        nav_to(
                            context,
                            ItemForm(
                              id_item: item![index]['id'],
                            ));
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
