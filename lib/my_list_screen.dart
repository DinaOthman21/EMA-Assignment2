import 'package:assignment2/models/store.dart';
import 'package:assignment2/provider/store_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class MyListScreen extends StatelessWidget {
  const MyListScreen({Key? key}) : super(key: key);

  double _calculateDistance(double userLatitude, double userLongitude, double storeLatitude, double storeLongitude) {
    return Geolocator.distanceBetween(userLatitude, userLongitude, storeLatitude, storeLongitude) / 1000;
  }

  @override
  Widget build(BuildContext context) {
    final userPosition = Provider.of<Position?>(context);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 45.0),
          child: const Text(
            'My Favorite Stores',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.pink,
      ),
      body: Consumer<StoreProvider>(
        builder: (context, storeProvider, _) {
          final favoriteStores = storeProvider.favoriteStores;

          return ListView.builder(
            itemCount: favoriteStores.length,
            itemBuilder: (context, index) {
              final Store store = favoriteStores[index];

              final double distance = _calculateDistance(
                userPosition?.latitude ?? 0,
                userPosition?.longitude ?? 0,
                store.latitude ?? 0,
                store.longitude ?? 0,
              );

              return ListTile(
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
                    Text(
                      'Longitude: ${store.longitude}',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      'Latitude: ${store.latitude}',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      'Distance: ${distance.toStringAsFixed(2)} km',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    storeProvider.removeFromFavorites(store);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.pink,
                  ),
                  child: Text(
                    'Remove',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
