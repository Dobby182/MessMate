import 'package:flutter/material.dart';

class FoodScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("MessMate - Book Food"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),

      body: Padding(

        padding: EdgeInsets.all(20),

        child: Column(

          children: [

            Text(
              "Select Food Item",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {},
              child: Text("Egg"),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {},
              child: Text("Chicken"),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {},
              child: Text("Milk"),
            ),

          ],

        ),

      ),

    );

  }

}
