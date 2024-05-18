import 'package:assignment2/my_list_screen.dart';
import 'package:assignment2/provider/store_provider.dart';
import 'package:assignment2/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences? prefs;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
    _ensureAuthenticated();
    Provider.of<StoreProvider>(context, listen: false).fetchInitialData();
    _getCurrentLocation();
  }

  Future<void> _initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _ensureAuthenticated() async {
    if (prefs != null && !(prefs!.getBool('isAuthenticated') ?? false)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });

    Provider.of<StoreProvider>(context, listen: false).setUserPosition(position);
  }

  Future<void> _signOut() async {
    if (prefs != null) {
      await prefs!.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 65.0),
          child: const Text(
            'Stores List',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Consumer<StoreProvider>(
        builder: (context, storeProvider, _) {
          final stores = storeProvider.stores;
          final favoriteStores = storeProvider.favoriteStores;
          final userPosition = _currentPosition;

          return ListView.builder(
            itemCount: stores.length,
            itemBuilder: (context, index) {
              final store = stores[index];
              final isFavorite = favoriteStores.contains(store);

              final double distance = userPosition != null
                  ? Geolocator.distanceBetween(
                userPosition.latitude,
                userPosition.longitude,
                store.latitude ?? 0,
                store.longitude ?? 0,
              ) / 1000
                  : 0.0;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    store.name,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Text('Longitude: ${store.longitude}'),
                      //Text('Latitude: ${store.latitude}'),
                      //Text('Distance: ${distance.toStringAsFixed(2)} km'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.blue : Colors.black26,
                    ),
                    onPressed: () {
                      if (isFavorite) {
                        storeProvider.removeFromFavorites(store);
                      } else {
                        storeProvider.addToFavorites(store);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const MyListScreen(),
            ),
          );
        },
        label: const Text(
          'My Favorites',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: const Icon(Icons.favorite),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}