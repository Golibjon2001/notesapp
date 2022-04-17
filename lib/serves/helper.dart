import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
class HiveHelper {
  static final _groceryList = Hive.box('grocery_list');
  static List<Map<String, dynamic>> getGroceries() {
    var groceryList = _groceryList.keys.map((key) {
      var value = _groceryList.get(key);
      return {
        "key": key,
        "item": value['item'],
        "quantity": value['quantity'],
        "date": value['date'],
      };
    }).toList();

    return groceryList;
  }
  static Future<void> addItem(Map<String, dynamic> newItem) async {
    await _groceryList.add(newItem);
  }

  static Future<void> updateItem(
      int itemKey, Map<String, dynamic> oldItem) async {
    await _groceryList.put(itemKey, oldItem);
  }

  static Future<void> deleteItem(int itemKey) async {
    await _groceryList.delete(itemKey);
  }
}