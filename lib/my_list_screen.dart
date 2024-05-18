import 'package:assignment2/provider/LocationService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:assignment2/provider/store_provider.dart';
import 'package:assignment2/models/store.dart';

class MyListScreen extends StatelessWidget {
  const MyListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Favorite Stores',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<Position>(
        future: LocationService().getCurrentPosition(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final Position? userPosition = snapshot.data;
            return Consumer<StoreProvider>(
              builder: (context, storeProvider, _) {
                final favoriteStores = storeProvider.favoriteStores;

                return ListView.builder(
                  itemCount: favoriteStores.length,
                  itemBuilder: (context, index) {
                    final Store store = favoriteStores[index];

                    final double distance = Geolocator.distanceBetween(
                      userPosition!.latitude,
                      userPosition.longitude,
                      store.latitude ?? 0,
                      store.longitude ?? 0,
                    ) / 1000; // Convert meters to kilometers

                    return ListTile(
                      title: Text(
                        store.name,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Distance: ${distance.toStringAsFixed(2)} km',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          storeProvider.removeFromFavorites(store);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
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
            );
          }
        },
      ),
    );
  }
}