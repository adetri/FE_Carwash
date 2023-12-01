import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/category.dart';
import 'package:flutter_application_1/page/category_form.dart';
import 'package:flutter_application_1/page/component/dropdown_field_input.dart';
import 'package:flutter_application_1/page/component/text_field_input.dart';
import 'package:flutter_application_1/page/item.dart';
import 'package:flutter_application_1/page/item_form.dart';
import 'package:flutter_application_1/page/monitoring_page.dart';
import 'package:flutter_application_1/page/pay_order.dart';
import 'package:flutter_application_1/page/setting.dart';
import 'package:flutter_application_1/page/test/test_img_field.dart';
import 'package:flutter_application_1/page/test/test_init_db.dart';
import 'package:flutter_application_1/page/print.dart';

// import 'package:flutter_application_1/page/login.dart';
// import 'package:flutter_application_1/page/monitoring_page.dart';
// import 'package:flutter_application_1/page/test_print.dart';
// import 'page/monitoring_page.dart';
// import 'page/pre_order.dart';
// import 'page/order_detail.dart';
// import 'page/pay_order.dart';
// import 'page/test_page.dart';
// import 'page/report.dart';
// import 'page/test_print.dart';
// import 'page/item_order_detail.dart';

void main() {
  runApp(StratAt());
}

class StratAt extends StatelessWidget {
  StratAt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter List from JSON',
      home: ItemForm(
        id_item: 5,
      ),
    );
  }
}
