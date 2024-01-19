import 'package:MrCarwash/env.dart';
import 'package:MrCarwash/page/checking.dart';
import 'package:MrCarwash/page/component/check_box.dart';
import 'package:MrCarwash/page/component/horizontal_month_scroll.dart';
import 'package:MrCarwash/page/component/radio_btn.dart';
import 'package:MrCarwash/page/login.dart';
import 'package:MrCarwash/page/main_menu.dart';
import 'package:MrCarwash/page/report/menu_report.dart';
import 'package:MrCarwash/page/report/report.dart';
import 'package:MrCarwash/page/report/report_chart.dart';
import 'package:MrCarwash/page/setting/karyawan/karyawan.dart';
import 'package:MrCarwash/page/setting/karyawan/karyawan_form.dart';
import 'package:MrCarwash/page/setting/karyawan/user_form.dart';
import 'package:MrCarwash/page/setting/outlet_profile/oulet_profile_form.dart';
import 'package:MrCarwash/page/setting/spot/spot_forn.dart';
import 'package:MrCarwash/page/test/test_chart.dart';
import 'package:MrCarwash/page/test/test_datimetime.dart';
import 'package:MrCarwash/page/test/test_excel.dart';
import 'package:MrCarwash/page/test/test_jwt_decoder.dart';
import 'package:MrCarwash/page/test/test_loading.dart';
import 'package:MrCarwash/page/test/test_print.dart';
import 'package:MrCarwash/page/test/test_radio.dart';
import 'package:MrCarwash/page/test/test_stream_controller.dart';
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
import 'package:MrCarwash/env.dart';

void main() {
  runApp(StratAt());
}

class StratAt extends StatelessWidget {
  StratAt({Key? key}) : super(key: key);

  bool loading = LOADING;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      home: CheckingPage(),
    );
  }
}
