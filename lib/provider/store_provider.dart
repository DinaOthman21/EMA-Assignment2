import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import '../SQLite/database_helper.dart';
import '../models/store.dart';

class StoreProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Store> _stores = [];
  List<Store> _favoriteStores = [];
  Position? _userPosition;

  List<Store> get stores => _stores;

  List<Store> get favoriteStores => _favoriteStores;

  Position? get userPosition => _userPosition;

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

  void setUserPosition(Position position) {
    _userPosition = position;
    notifyListeners();
  }

  static final List<Store> initialData = [
    Store(
        id: 1,
        name: "Carrefour",
        longitude: 74.0445,
        latitude: 40.6892,
        distance: 0),
    Store(
        id: 2,
        name: "Metro Markets",
        longitude: 2.2945,
        latitude: 48.8584,
        distance: 0),
    Store(
        id: 3,
        name: "Kheir Zaman",
        longitude: 151.2153,
        latitude: -33.8568,
        distance: 0),
    Store(
        id: 4,
        name: "Hyper One",
        longitude: 43.2105,
        latitude: -22.9519,
        distance: 0),
    // Aswan
    Store(
        id: 5,
        name: "Kazyon",
        longitude: 32.8998,
        latitude: 24.0889,
        distance: 0),
    // Luxor
    Store(
        id: 6,
        name: "Gourmet Egypt",
        longitude: 32.6396,
        latitude: 25.6872,
        distance: 0),
    // Alex
    Store(
        id: 7,
        name: "Lulu Hypermarket",
        longitude: 29.9187,
        latitude: 31.2001,
        distance: 0),
    Store(
        id: 8,
        name: "Seoudi",
        longitude: 29.9187,
        latitude: 31.2001,
        distance: 0),
    Store(
        id: 9,
        name: "Alfa",
        longitude: 13.1631,
        latitude: 72.5450,
        distance: 0),
    Store(
        id: 10,
        name: "Zahran",
        longitude: 35.6586,
        latitude: 139.7454,
        distance: 0),
    Store(
        id: 11,
        name: "Al-Hawary",
        longitude: 27.1751,
        latitude: 78.0421,
        distance: 0),
    Store(
        id: 12,
        name: "Awlad Ragab",
        longitude: 41.8902,
        latitude: 12.4922,
        distance: 0),
    // Additional stores
    Store(
        id: 13,
        name: "Spinney's",
        longitude: 31.2357,
        latitude: 30.0444,
        distance: 0), // Cairo
    Store(
        id: 14,
        name: "Mahmoud Sons",
        longitude: 31.2357,
        latitude: 30.0444,
        distance: 0), // Cairo
    Store(
        id: 15,
        name: "Family Market",
        longitude: 30.8025,
        latitude: 26.8206,
        distance: 0), // Egypt (General)
    Store(
        id: 16,
        name: "Fresh Food Market",
        longitude: 30.8025,
        latitude: 26.8206,
        distance: 0), // Egypt (General)
    Store(
        id: 17,
        name: "Oscar Grand Stores",
        longitude: 31.2001,
        latitude: 29.9187,
        distance: 0), // Alexandria
    Store(
        id: 18,
        name: "Hyper Panda",
        longitude: 39.1971,
        latitude: 21.4858,
        distance: 0), // Jeddah, Saudi Arabia
    Store(
        id: 19,
        name: "Danube",
        longitude: 39.1971,
        latitude: 21.4858,
        distance: 0), // Jeddah, Saudi Arabia
    Store(
        id: 20,
        name: "Carrefour Saudi",
        longitude: 39.1971,
        latitude: 21.4858,
        distance: 0), // Jeddah, Saudi Arabia
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