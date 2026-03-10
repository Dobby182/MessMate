import 'package:flutter/material.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {

  Map<String, int> quantity = {
    "egg": 0,
    "chicken_gravy": 0,
    "chilligobi": 0,
    "mushroom_manchurian": 0,
    "omlette": 0
  };

  List<String> dates = [
    "25-02-2026",
    "26-02-2026",
    "27-02-2026"
  ];

  Map<String, String> selectedDate = {
    "egg": "25-02-2026",
    "chicken_gravy": "25-02-2026",
    "chilligobi": "25-02-2026",
    "mushroom_manchurian": "25-02-2026",
    "omlette": "25-02-2026"
  };

  Widget foodCard(
      String title,
      String keyName,
      String imagePath,
      int price
      ) {

    return Card(

      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      child: Padding(

        padding: const EdgeInsets.all(10),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
              textAlign: TextAlign.center,
            ),

            Text(
              "PER ₹$price",
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 8),

            Image.asset(
              imagePath,
              height: 70,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (quantity[keyName]! > 0) {
                        quantity[keyName] =
                            quantity[keyName]! - 1;
                      }
                    });
                  },
                ),

                Text(
                  "${quantity[keyName]}",
                  style: const TextStyle(fontSize: 16),
                ),

                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity[keyName] =
                          quantity[keyName]! + 1;
                    });
                  },
                ),

              ],
            ),

            DropdownButton<String>(

              value: selectedDate[keyName],

              isExpanded: true,

              items: dates.map((String date) {

                return DropdownMenuItem<String>(
                  value: date,
                  child: Text(date),
                );

              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedDate[keyName] = value!;
                });
              },

            ),

            const SizedBox(height: 5),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(

                onPressed: () {},

                icon: const Icon(Icons.shopping_cart),

                label: const Text("Add"),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),

              ),
            )

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("MessMate - Book Food"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),

      body: GridView.count(

        crossAxisCount: 2,
        padding: const EdgeInsets.all(10),

        // increased height to remove overflow
        childAspectRatio: 0.55,

        children: [

          foodCard(
              "Boiled Egg",
              "egg",
              "assets/images/fooditem-egg.png",
              10
          ),

          foodCard(
              "Chicken Gravy",
              "chicken_gravy",
              "assets/images/fooditem-chicken_gravy.png",
              80
          ),

          foodCard(
              "Chilli Gobi",
              "chilligobi",
              "assets/images/fooditem-chilligobi.png",
              40
          ),

          foodCard(
              "Mushroom Manchurian",
              "mushroom_manchurian",
              "assets/images/fooditem-mushroom_manchurian.png",
              60
          ),

          foodCard(
              "Omlette",
              "omlette",
              "assets/images/fooditem-omlette.png",
              10
          ),

        ],
      ),
    );
  }
}