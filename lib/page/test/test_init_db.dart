import 'package:flutter/material.dart';
import 'package:flutter_application_1/inc/db.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Your DatabaseHelper class definition goes here...

class Testinitdb extends StatelessWidget {
  final dbHelper = DatabaseHelper();
  int taskId = 1;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Insert Task Example'),
        ),
        body: Center(
            child: Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                dynamic data = await dbHelper.getTasks();
                print(data);

                List<Map<String, dynamic>> tasks =
                    await dbHelper.getTasksById(taskId);
                if (tasks.isNotEmpty) {
                  // Handle retrieved tasks here...
                  print('Task with ID $taskId: ${tasks.first}');
                } else {
                  print('Task not found for ID: $taskId');
                }
              },
              child: Text('Test Select'),
            ),
            ElevatedButton(
              onPressed: () async {
                int insertedId = await insertTaskIntoDatabase();
                print('Inserted task with ID: $insertedId');
              },
              child: Text('Insert Task'),
            ),
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> updatedTask = {
                  'id': 1, // Replace with the ID of the task you want to update
                  'jwt': 'Updated Task Name1',
                };

                int rowsAffected = await dbHelper.updateTask(updatedTask);
                print('Rows affected: $rowsAffected');
              },
              child: Text('Update Task'),
            ),
            ElevatedButton(
              onPressed: () async {
                int rowsAffected = await dbHelper.deleteTaskOther();
                print('Rows affected: $rowsAffected');
              },
              child: Text('Detele Task'),
            ),
          ],
        )),
      ),
    );
  }

  Future<int> insertTaskIntoDatabase() async {
    Map<String, dynamic> task = {
      'jwt': 'Example Task',
      'host': 'This is an example task description.',
    };

    int insertedId = await dbHelper.insertTask(task);
    return insertedId;
  }

  // Future<int> updateTaskInDatabase(Map<String, dynamic> updatedTask) async {
  //   int rowsAffected = await dbHelper.updateTask(updatedTask);
  //   return rowsAffected;
  // }
}
