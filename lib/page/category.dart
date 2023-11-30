import 'package:flutter/material.dart';
import 'package:flutter_application_1/inc/method.dart';
import 'package:flutter_application_1/inc/req.dart';
import 'package:flutter_application_1/page/category_form.dart';
import 'package:flutter_application_1/page/setting.dart';

class CategoryList extends StatelessWidget {
  CategoryList({Key? key});

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
                  'Category',
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
                    nav_to(context, CategoryForm());
                  },
                  child: Text("Add")),
            ),
            ListCategory(),
          ],
        ),
      ),
    );
  }
}

class ListCategory extends StatefulWidget {
  ListCategory({super.key});

  @override
  State<ListCategory> createState() => _ListCategoryState();
}

List<dynamic>? categories;

class _ListCategoryState extends State<ListCategory> {
  Req? req;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    req = Req(context);
    await req?.init();
    var req_category = await req?.fetchCategory2();
    setState(() {
      categories = req_category?['response']['category'];
    });
    print(categories);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: categories == null
          ? Text("Category No Found")
          : ListView.builder(
              itemCount: categories!.length,
              itemBuilder: (BuildContext context, int index) {
                String category_name = categories![index]['name'];
                int category_id = categories![index]['id'];
                return ExpansionTile(
                  title: Text(category_name),
                  children: <Widget>[
                    ListTile(
                      title: Text('Edit'),
                      onTap: () {
                        nav_to(
                            context,
                            CategoryForm(
                              id_category: category_id,
                            ));
                        print('Tapped on Edit for ');
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
