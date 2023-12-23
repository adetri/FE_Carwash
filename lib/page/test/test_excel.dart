import 'package:MrCarwash/inc/method.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: TestExcel(),
    );
  }
}

class TestExcel extends StatefulWidget {
  TestExcel({
    Key? key,
  }) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _TestExcelState createState() => _TestExcelState();
}

class _TestExcelState extends State<TestExcel> {
  var platform = MethodChannel('com.example.app/mediaScanner');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            ElevatedButton(child: Text('Create Excel'), onPressed: createExcel),
      ),
    );
  }

  Future<void> scanMedia(String filePath) async {
    try {
      await platform.invokeMethod('scanFile', {'filePath': filePath});
    } on PlatformException catch (e) {
      print('Failed to scan media: $e');
    }
  }

  Future<void> createExcel() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      // Create the Excel file
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setText('Hello World!');
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      // Get the external storage directory
      Directory? downloadDirectory = await getExternalStorageDirectory();
      String downloadPath = '';

      if (downloadDirectory != null) {
        downloadPath = downloadDirectory.path + '/Download';
        Directory(downloadPath).createSync(recursive: true);

        // Specify the file path in the download directory
        final String fileName = '$downloadPath/Output2.xlsx';
        final File file = File(fileName);
        await file.writeAsBytes(bytes, flush: true);

        // Show a message that the file has been saved
        print('File saved at: $fileName');
      } else {
        // Handle the case where the download directory is null
        print('Download directory not available.');
      }
    } else {
      // Handle the case where permission is not granted
      print('Permission not granted.');
    }
  }
}
