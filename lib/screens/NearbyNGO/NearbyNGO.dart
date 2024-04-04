import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:utkarsh/screens/NearbyNGO/CardWidget.dart'; 
class NGO {
  final String name;
  final String address;
  final double distance;
  final String? website; // Optional field for website

  NGO({required this.name, required this.address, required this.distance, this.website});
}

class NearbyNGO extends StatefulWidget {
  const NearbyNGO({super.key});

  @override
  State<NearbyNGO> createState() => _NearbyNGOState();
}

class _NearbyNGOState extends State<NearbyNGO> {
  Location location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  // List<String> _ngoNames = [];
  List<NGO> _ngos = [];

  @override
  void initState() {
    super.initState();
    _checkLocationService();
  }

  _checkLocationService() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    _fetchNearbyNGOs();
  }

  _fetchNearbyNGOs() async {
    final apiKey = dotenv.env['maps_api'] ?? '';
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_locationData?.latitude},${_locationData?.longitude}&radius=5000&type=non-profit&keyword=ngo&key=$apiKey'));
      print(response.body);
     if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _ngos = (data['results'] as List).map((item) {
          // Extract the latitude and longitude from the item
          final lat = item['geometry']['location']['lat'];
          final lng = item['geometry']['location']['lng'];
          // Calculate the distance using the geolocator package
          final double distanceInMeters = Geolocator.distanceBetween(
            _locationData!.latitude!,
            _locationData!.longitude!,
            lat,
            lng,
          );
          return NGO(
            name: item['name'],
            address: item['vicinity'], // Assuming 'vicinity' is the field for address
            distance: distanceInMeters / 1000, // Convert meters to kilometers
            website: item['website'], // Assuming 'website' is the field for website
          );
        }).toList();
      });
    } else {
      throw Exception('Failed to load NGOs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstantsColors.accentColor,
        title: Text('Nearby NGOs'),
      ),
      body: _ngos.isEmpty
          ? Center(child: CircularProgressIndicator(
            color: AppConstantsColors.accentColor,
          ))
          : ListView.builder(

              itemCount: _ngos.length,
              itemBuilder: (context, index) {
                final ngo = _ngos[index];
                return CardNearby(
                  ngoName: ngo.name,
                  ngoAddress: ngo.address,
                  distance: ngo.distance.toStringAsFixed(2),
                  website: ngo.website,
                );
              },
            )
    );
  }
}
