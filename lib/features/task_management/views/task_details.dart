import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:site_720/core/widgets/appbar.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppbar(context, "Task Details", true),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Task Name:",style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold),),
                Text("First Task",style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold),),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Task Name:",style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold),),
                Text("First Task",style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}