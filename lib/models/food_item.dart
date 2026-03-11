class FoodItem {
  String id;
  String name;
  int price;
  String imagePath;
  List<String> availableDates;

  FoodItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.availableDates,
  });
}
