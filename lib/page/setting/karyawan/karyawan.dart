import 'package:MrCarwash/inc/method.dart';
import 'package:MrCarwash/inc/req.dart';
import 'package:MrCarwash/page/component/header.dart';
import 'package:MrCarwash/page/setting/karyawan/karyawan_form.dart';
import 'package:MrCarwash/page/setting/karyawan/user_form.dart';
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
                        nav_to(context, KaryawanForm());
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
                        nav_to(context, UserForm());
                      },
                      child: Text("Add User")),
                ),
              ],
            ),
            KaryawanDataList(),
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
  Req? req;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    req = Req(context);
    await req?.init();
    var req_karywan = await req?.fechKaryawan();

    setState(() {
      karywan = req_karywan?['response']['pegawai'];
    });
    dbg(karywan);
  }

  @override
  Widget build(BuildContext context) {
    return karywan == null
        ? Text("Karyawan Not Found")
        : Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height *
                    0.8, // Adjust the height as needed
                child: ListView.builder(
                  itemCount: karywan!.length,
                  itemBuilder: (BuildContext context, int index) {
                    String karyawan_name = karywan?[index]['name'];
                    String karywan_role = karywan?[index]['role']['name'];
                    int? karyawan_id = karywan?[index]['id'];
                    return ExpansionTile(
                      title: Text("${karyawan_name} (${karywan_role})"),
                      children: <Widget>[
                        ListTile(
                          title: Text('Edit'),
                          onTap: () {
                            nav_to(
                                context,
                                KaryawanForm(
                                  id_karyawan: karyawan_id,
                                ));
                          },
                        ),
                        // Add more ListTile widgets for subcategories as needed
                      ],
                    );
                  },
                ),
              ),
            ),
          );
  }
}
