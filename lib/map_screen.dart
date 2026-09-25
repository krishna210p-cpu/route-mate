import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final String vehicle;

  MapScreen({required this.vehicle});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng driverLocation;
  final LatLng pickup = LatLng(19.0800, 72.8800);
  final LatLng drop = LatLng(19.0900, 72.8850);
  
  String _selectedRouteMode = 'Fastest'; // Fastest, Fuel Efficient, Heavy Vehicle Safe
  Timer? _movementTimer;
  int _movementCount = 0;
  
  @override
  void initState() {
    super.initState();
    driverLocation = LatLng(19.0760, 72.8777);
    _startDriverMovementSimulation();
  }
  
  @override
  void dispose() {
    _movementTimer?.cancel();
    super.dispose();
  }
  
  void _startDriverMovementSimulation() {
    _movementTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _movementCount++;
        // Simulate slight movement towards destination
        double latIncrement = 0.0001 * (_movementCount % 10);
        double lngIncrement = 0.0001 * (_movementCount % 8);
        driverLocation = LatLng(
          driverLocation.latitude + latIncrement,
          driverLocation.longitude + lngIncrement,
        );
      });
    });
  }

  String getRouteMessage() {
    if (widget.vehicle == "Truck") {
      return "🚛 Heavy Vehicle: Avoiding narrow roads, using main routes only";
    } else if (widget.vehicle == "Tempo") {
      return "🚌 Medium Vehicle: Balanced route for optimal delivery";
    } else {
      return "🏍️ Bike: Fastest route via shortest path";
    }
  }

  String getFuelOptimizationMessage() {
    if (widget.vehicle == "Truck") {
      return "Optimized route reduces fuel consumption by 15%";
    } else if (widget.vehicle == "Tempo") {
      return "Efficient route saves 10% fuel";
    } else {
      return "Most fuel-efficient path selected";
    }
  }
  
  String getVehicleOptimizedMessage() {
    if (widget.vehicle == "Bike") {
      return "✓ This route is optimized for your vehicle - allowing narrow roads for fastest delivery";
    } else if (widget.vehicle == "Auto") {
      return "✓ This route is optimized for your vehicle - using moderate roads";
    } else if (widget.vehicle == "Truck") {
      return "✓ This route is optimized for your vehicle - avoiding narrow roads, preferring main roads";
    } else {
      return "✓ This route is optimized for your vehicle";
    }
  }

  Future<void> _startNavigation(BuildContext context) async {
    // Generate Google Maps URL with pickup and destination
    final String googleMapsUrl = 
        'https://www.google.com/maps/dir/?api=1'
        '&origin=${pickup.latitude},${pickup.longitude}'
        '&destination=${drop.latitude},${drop.longitude}'
        '&travelmode=driving';

    try {
      final Uri uri = Uri.parse(googleMapsUrl);
      
      // Launch Google Maps
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Opens in Google Maps app
        );
      } else {
        // Fallback: open in browser
        await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to open maps. Please check your internet connection.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          FlutterMap(
            options: MapOptions(
              initialCenter: driverLocation,
              initialZoom: 13,
            ),
            children: [
              // MapTiler Tile Layer - Updated API
              TileLayer(
                urlTemplate: "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=oSSTV2DVUI48SY9vXoSm",
              ),
              // Route Line (Polyline)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [pickup, drop],
                    strokeWidth: 4,
                    color: Colors.blue,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  // Driver Location - Blue Marker
                  Marker(
                    point: driverLocation,
                    width: 80,
                    height: 80,
                    child: Icon(Icons.person_pin_circle,
                        color: Colors.blue, size: 40),
                  ),
                  // Pickup Location - Green Marker
                  Marker(
                    point: pickup,
                    width: 80,
                    height: 80,
                    child: Icon(Icons.location_on,
                        color: Colors.green, size: 40),
                  ),
                  // Destination - Red Marker
                  Marker(
                    point: drop,
                    width: 80,
                    height: 80,
                    child: Icon(Icons.flag, color: Colors.red, size: 40),
                  ),
                ],
              ),
            ],
          ),

          // Floating Top Info Card - Route Mode
          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Route Mode",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildRouteOptionButton('Fastest', Icons.speed),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _buildRouteOptionButton('Fuel Efficient', Icons.eco),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _buildRouteOptionButton('Heavy Vehicle', Icons.local_shipping),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Vehicle Info Card
          Positioned(
            top: 180,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vehicle Optimization Message
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, size: 18, color: Colors.green.shade700),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            getVehicleOptimizedMessage(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        widget.vehicle == "Truck" ? Icons.local_shipping :
                            widget.vehicle == "Tempo" ? Icons.directions_bus :
                            Icons.motorcycle,
                        color: Colors.green.shade700,
                        size: 26,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getRouteMessage(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.eco, size: 14, color: Colors.blue.shade700),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      getFuelOptimizationMessage(),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.blue.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Legend - Repositioned to avoid overlap
          Positioned(
            top: 420,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Legend",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildLegendItem(Icons.person_pin_circle, Colors.blue, "Driver"),
                  SizedBox(height: 6),
                  _buildLegendItem(Icons.location_on, Colors.green, "Pickup"),
                  SizedBox(height: 6),
                  _buildLegendItem(Icons.flag, Colors.red, "Destination"),
                ],
              ),
            ),
          ),

          // Bottom Sheet Panel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey.shade50],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: Offset(0, -8),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar for visual feedback
                  Container(
                    width: 60,
                    height: 5,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  
                  // Traffic Info
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade50, Colors.orange.shade100],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.orange.shade200, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.traffic, size: 18, color: Colors.orange.shade800),
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Moderate traffic ahead",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.orange.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Trip Details
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTripDetail(
                          icon: Icons.route,
                          value: "3.2 km",
                          label: "Distance",
                          color: Colors.blue,
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: Colors.grey.shade200,
                        ),
                        _buildTripDetail(
                          icon: Icons.access_time,
                          value: "12 min",
                          label: "Est. Time",
                          color: Colors.green,
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: Colors.grey.shade200,
                        ),
                        _buildTripDetail(
                          icon: Icons.local_gas_station,
                          value: "₹45",
                          label: "Fuel",
                          color: Colors.amber,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Start Navigation Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.4),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          _startNavigation(context);
                        },
                        splashColor: Colors.white.withOpacity(0.3),
                        highlightColor: Colors.white.withOpacity(0.1),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.navigation, color: Colors.white, size: 24),
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Start Navigation",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteOptionButton(String mode, IconData icon) {
    final isSelected = _selectedRouteMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRouteMode = mode;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$mode route selected - ${_getRouteModeDescription(mode)}'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: AnimatedScale(
        scale: isSelected ? 1.05 : 1.0,
        duration: Duration(milliseconds: 200),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected ? LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade600],
            ) : null,
            color: isSelected ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.blue.shade700 : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ] : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
              SizedBox(height: 6),
              Text(
                mode,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRouteModeDescription(String mode) {
    switch (mode) {
      case 'Fastest':
        return 'Quickest delivery time';
      case 'Fuel Efficient':
        return 'Saves fuel and money';
      case 'Heavy Vehicle':
        return 'Avoids narrow roads';
      default:
        return 'Optimized route';
    }
  }

  Widget _buildLegendItem(IconData icon, Color color, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 14),
          ),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetail({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}