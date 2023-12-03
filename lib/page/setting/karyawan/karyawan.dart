import 'package:MrCarwash/inc/method.dart';
import 'package:MrCarwash/inc/req.dart';
import 'package:MrCarwash/page/component/header.dart';
import 'package:MrCarwash/page/setting/setting.dart';
import 'package:flutter/material.dart';

class KaryawanList extends StatelessWidget {
  KaryawanList({super.key});
  var header = MyHeader(prev_page: Settings(), title: "Employee");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                      onPressed: () {
                        // nav_to(context, SpotFrom());
                      },
                      child: Text("Add Karyawan")),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                      onPressed: () {
                        // nav_to(context, SpotFrom());
                      },
                      child: Text("Add User")),
                ),
              ],
            ),
            KaryawanDataList()
            // SpotDataList(),
          ],
        ),
      ),
    );
  }
}

class KaryawanDataList extends StatefulWidget {
  const KaryawanDataList({super.key});

  @override
  State<KaryawanDataList> createState() => _KaryawanDataListState();
}

class _KaryawanDataListState extends State<KaryawanDataList> {
  List<dynamic>? karywan;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Expanded(
        child: karywan == null
            ? Text("Karyawan Not Found")
            : ListView.builder(
                itemCount: karywan!.length,
                itemBuilder: (BuildContext context, int index) {},
              ),
      ),
    );
  }
}
