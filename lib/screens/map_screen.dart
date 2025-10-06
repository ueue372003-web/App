import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lnmq/models/place_model.dart';
import 'package:lnmq/services/place_service.dart';
import 'package:lnmq/l10n/app_localizations.dart';


class MapScreen extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final String? placeName;
  final String? placeLocation;

  const MapScreen({Key? key, this.latitude, this.longitude, this.placeName, this.placeLocation}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final PlaceService _placeService = PlaceService();
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final double lat = widget.latitude ?? 21.0285;
    final double lng = widget.longitude ?? 105.8542;
    final String name = widget.placeName ?? localizations.mapTitle;
    final String location = widget.placeLocation ?? '';

    final marker = Marker(
      markerId: const MarkerId('selected_place'),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: name, snippet: location),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.mapTitle),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, lng),
          zoom: 14,
        ),
        markers: {marker},
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
