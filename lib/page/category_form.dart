import 'package:flutter/material.dart';

class CategoryForm extends StatelessWidget {
  const CategoryForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            SizedBox(height: 25),
            CatForm(),
          ],
        ),
      ),
    );
  }

  Widget header() {
    print("this exec");
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            // Handle back button tap
          },
          child: Container(
            height: 50,
            alignment: Alignment.topLeft,
            child: Image.asset('assets/back.png'),
          ),
        ),
        SizedBox(width: 10),
        Text(
          'Category Form',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class CatForm extends StatefulWidget {
  const CatForm({Key? key}) : super(key: key);

  @override
  State<CatForm> createState() => _CatFormState();
}

class _CatFormState extends State<CatForm> {
  TextEditingController _categoryController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: TextField(
              controller: _categoryController,
              onChanged: (value) {
                // Handle text changes
              },
              decoration: InputDecoration(
                labelText: 'Category Name',
                hintText: 'Category Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String categoryName = _categoryController.text;
                  print('Category Name: $categoryName');
                },
                child: Text('Submit'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
