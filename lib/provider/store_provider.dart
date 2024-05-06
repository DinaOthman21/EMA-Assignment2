import 'package:flutter/material.dart';
import 'package:assignment2/SQLite/database_helper.dart';
import 'package:assignment2/models/store.dart';

class StoreProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Store> _stores = [];
  List<Store> _favoriteStores = [];

  List<Store> get stores => _stores;

  List<Store> get favoriteStores => _favoriteStores;

  Future<void> fetchFavoriteStores(int userId) async {
    final favoriteStores = await _dbHelper.getFavoriteStores(userId);
    _favoriteStores = favoriteStores;
    notifyListeners();
  }

  void addToFavorites(Store store) async {
    _favoriteStores.add(store);
    await _dbHelper.insertStore(store); // Store store in the database
    notifyListeners();
  }

  Future<void> removeFromFavorites(Store store) async {
    _favoriteStores.remove(store);
    await _dbHelper.deleteStore(store.id); // Remove store from the database
    notifyListeners();
  }

  // Placeholder initial data
  static final List<Store> initialData = [
    Store(
        id: 1,
        name: "Bazooka",
        longitude: 40.6892,
        latitude:  74.0445,
        distance: 0),
    Store(
        id: 2,
        name: "Buffalo Burger",
        longitude: 48.8584,
        latitude: 2.2945,
        distance: 0),
    Store(
        id: 3,
        name: "Hardees",
        longitude: 33.8568,
        latitude: 151.2153,
        distance: 0),
    Store(
        id: 4,
        name: "Heart Attack",
        longitude:22.9519,
        latitude: 43.2105,
        distance: 0),
    //Aswan
    Store(
        id: 5,
        name: "Mo'men",
        longitude: 24.0889,
        latitude: 32.8998,
        distance: 0),
    //luxor
    Store(
        id: 6,
        name: "Pizza King",
        longitude: 25.6872,
        latitude: 32.6396,
        distance: 0),
    //Alex
    Store(
        id: 7,
        name: "Pizza Hut",
        longitude:  31.2001,
        latitude:  29.9187,
        distance: 0),
    Store(
        id:8 ,
        name: "Kapotsha",
        longitude:  31.2001,
        latitude:  29.9187,
        distance: 0),
    Store(
        id: 9,
        name: "Cook Door",
        longitude:   72.5450,
        latitude:  13.1631,
        distance: 0),
    Store(
        id: 10,
        name: "KFC",
        longitude:  139.7454,
        latitude:  35.6586,
        distance: 0),
    Store(
        id: 11,
        name: "papa jons",
        longitude:  78.0421,
        latitude:  27.1751,
        distance: 0),
    Store(
        id: 12,
        name: "Dunkin Dounts",
        longitude:  12.4922,
        latitude:  41.8902,
        distance: 0),
    Store(
        id: 12,
        name: "Knsas",
        longitude:  55.5555,
        latitude:  89.235,
        distance: 0),
  ];

  Future<void> fetchInitialData() async {
    // Simulate fetching data from API or database
    _stores = initialData;
    // Schedule the notifyListeners call after the current build phase completes
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

}
