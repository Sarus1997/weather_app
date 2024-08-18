import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  final double? lat;
  final double? lon;
  final String cityName;

  const MapScreen({
    super.key,
    required this.cityName,
    this.lat,
    this.lon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cityName),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 150, // Fixed height to constrain the map
              width: double.infinity,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: lat != null && lon != null
                    ? GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(lat!, lon!),
                          zoom: 12,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId(cityName),
                            position: LatLng(lat!, lon!),
                            infoWindow: InfoWindow(title: cityName),
                          ),
                        },
                      )
                    : const Center(
                        child: Text(
                          'Location data not available',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
              ),
            ),
            // Add additional widgets here if needed
          ],
        ),
      ),
    );
  }
}
