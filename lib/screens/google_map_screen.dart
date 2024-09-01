import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';

class HighlightedMapPage extends StatefulWidget {
  @override
  _HighlightedMapPageState createState() => _HighlightedMapPageState();
}

class _HighlightedMapPageState extends State<HighlightedMapPage> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider()..loadClimateDataForTableForUK()..loadClimateDataForTableScotland(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('UK Regions - Highlighted Map'),
          actions: [
            Consumer<WeatherProvider>(builder: (context, provider, _) {
              return DropdownButton<String?>(
                value: provider.selectedYear,
                  items: provider.climateTableData
                      .map((element) => DropdownMenuItem<String>(
                            child: Text(element.year.toString()),
                            value: element.year,
                          ))
                      .toList(),
                  onChanged: (String? year) {
                    provider.selectedYear = year!;
                    provider.updatePolygons();
                  });
            }),
          ],
        ),
        body: Consumer<WeatherProvider>(builder: (context, provider, _) {
          if(provider.climateTableData.isEmpty || provider.climateTableDataScotland.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return GoogleMap(
            onMapCreated: _onMapCreated,
            mapType: MapType.terrain,
            initialCameraPosition: CameraPosition(
              target: provider.center,
              zoom: 5.0,
            ),
            polygons: provider.polygons,
          );
        }),
      ),
    );
  }
}
