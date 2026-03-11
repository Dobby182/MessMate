import '../models/food_item.dart';

class GlobalData {
  static List<FoodItem> availableFoods = [
    FoodItem(
      id: "egg",
      name: "Boiled Egg",
      price: 10,
      imagePath: "assets/images/fooditem-egg.png",
      availableDates: ["25-02-2026", "26-02-2026", "27-02-2026"],
    ),
    FoodItem(
      id: "chicken_gravy",
      name: "Chicken Gravy",
      price: 80,
      imagePath: "assets/images/fooditem-chicken_gravy.png",
      availableDates: ["25-02-2026", "26-02-2026", "27-02-2026"],
    ),
    FoodItem(
      id: "chilligobi",
      name: "Chilli Gobi",
      price: 40,
      imagePath: "assets/images/fooditem-chilligobi.png",
      availableDates: ["25-02-2026", "26-02-2026", "27-02-2026"],
    ),
    FoodItem(
      id: "mushroom_manchurian",
      name: "Mushroom Manchurian",
      price: 60,
      imagePath: "assets/images/fooditem-mushroom_manchurian.png",
      availableDates: ["25-02-2026", "26-02-2026", "27-02-2026"],
    ),
    FoodItem(
      id: "omlette",
      name: "Omlette",
      price: 10,
      imagePath: "assets/images/fooditem-omlette.png",
      availableDates: ["25-02-2026", "26-02-2026", "27-02-2026"],
    ),
  ];

  static Set<String> servedTokens = {};
}
