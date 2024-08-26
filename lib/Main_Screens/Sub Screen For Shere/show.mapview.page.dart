// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapViewPage extends StatelessWidget {
//   final String location;

//   MapViewPage({required this.location});

//   @override
//   Widget build(BuildContext context) {
//     // Attempt to parse the latitude and longitude from the location string
//     final parts = location.split(',');
//     final latitude = double.tryParse(parts[0].split(':')[1].trim());
//     final longitude = double.tryParse(parts[1].split(':')[1].trim());

//     // Check if the latitude and longitude are valid
//     if (latitude == null || longitude == null) {
//       return Scaffold(
//         appBar: AppBar(title: Text('Location Not Available')),
//         body: Center(
//           child: Text(
//             'The location data is not available or invalid.',
//             style: TextStyle(fontSize: 18, color: Colors.redAccent),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       );
//     }

//     // If location data is valid, display the map
//     final LatLng latLng = LatLng(latitude, longitude);

//     return Scaffold(
//       appBar: AppBar(title: Text('Shared Location')),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: latLng,
//           zoom: 14.0,
//         ),
//         markers: {
//           Marker(
//             markerId: MarkerId('sharedLocation'),
//             position: latLng,
//           ),
//         },
//       ),
//     );
//   }
// }
