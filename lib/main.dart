import 'package:MrCarwash/page/login.dart';
import 'package:MrCarwash/page/report/report.dart';
import 'package:MrCarwash/page/setting/karyawan/karyawan.dart';
import 'package:MrCarwash/page/setting/spot/spot_forn.dart';
import 'package:MrCarwash/page/test/test_jwt_decoder.dart';
import 'package:flutter/material.dart';
import 'package:MrCarwash/page/setting/category/category.dart';
import 'package:MrCarwash/page/setting/category/category_form.dart';
import 'package:MrCarwash/page/component/dropdown_field_input.dart';
import 'package:MrCarwash/page/component/text_field_input.dart';
import 'package:MrCarwash/page/setting/item/item.dart';
import 'package:MrCarwash/page/setting/item/item_form.dart';
import 'package:MrCarwash/page/setting/spot/spot.dart';
import 'package:MrCarwash/page/wash_service/monitoring_page.dart';
import 'package:MrCarwash/page/wash_service/pay_order.dart';
import 'package:MrCarwash/page/setting/setting.dart';
import 'package:MrCarwash/page/test/test_img_field.dart';
import 'package:MrCarwash/page/test/test_init_db.dart';
import 'package:MrCarwash/page/print.dart';

void main() {
  runApp(StratAt());
}

class StratAt extends StatelessWidget {
  StratAt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      home: KaryawanList(),
    );
  }
}
