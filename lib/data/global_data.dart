import '../models/food_item.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class GlobalData {
  static List<String> generateNextDates(int days) {
    List<String> dates = [];
    DateTime today = DateTime.now();
    for (int i = 0; i < days; i++) {
      DateTime nextDate = today.add(Duration(days: i));
      String formattedDate = "${nextDate.day.toString().padLeft(2, '0')}-${nextDate.month.toString().padLeft(2, '0')}-${nextDate.year}";
      dates.add(formattedDate);
    }
    return dates;
  }

  static List<FoodItem> availableFoods = [
    FoodItem(
      id: "egg",
      name: "Boiled Egg",
      price: 10,
      imagePath: "assets/images/fooditem-egg.png",
      availableDates: generateNextDates(5),
    ),
    FoodItem(
      id: "chicken_gravy",
      name: "Chicken Gravy",
      price: 80,
      imagePath: "assets/images/fooditem-chicken_gravy.png",
      availableDates: generateNextDates(5),
    ),
    FoodItem(
      id: "chilligobi",
      name: "Chilli Gobi",
      price: 40,
      imagePath: "assets/images/fooditem-chilligobi.png",
      availableDates: generateNextDates(5),
    ),
    FoodItem(
      id: "mushroom_manchurian",
      name: "Mushroom Manchurian",
      price: 60,
      imagePath: "assets/images/fooditem-mushroom_manchurian.png",
      availableDates: generateNextDates(5),
    ),
    FoodItem(
      id: "omlette",
      name: "Omlette",
      price: 10,
      imagePath: "assets/images/fooditem-omlette.png",
      availableDates: generateNextDates(5),
    ),
  ];

  static Set<String> servedTokens = {};
  static List<CartItem> cartItems = [];
  static List<Order> userOrders = [];
  static List<Order> completedOrders = [];
}
