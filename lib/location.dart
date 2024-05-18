import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cross_platform/logs_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final LoggingService loggingService = LoggingService();

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      loggingService.startLogging('web', 'Using Location');
    } else {
      if (defaultTargetPlatform == TargetPlatform.android) {
        loggingService.startLogging('android', 'Using Location');
      } else if (defaultTargetPlatform == TargetPlatform.windows) {
        loggingService.startLogging('desktop', 'Using Location');
      }
    }
  }

  @override
  void dispose() {
    loggingService.stopLogging();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Location'),
      ),
      body: FlutterMap( 
        options: const MapOptions(
          initialCenter: LatLng(0, 0),
          initialZoom: 1,
          minZoom: 0,
          maxZoom: 19,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName:
            'net.tlserver6y.flutter_map_location_marker.example',
            maxZoom: 19,
          ),
          CurrentLocationLayer(
            headingStream: Stream.periodic(const Duration(seconds: 10)),
            alignPositionOnUpdate: AlignOnUpdate.always,
          ),
        ],
      ),
    );
  }
}
