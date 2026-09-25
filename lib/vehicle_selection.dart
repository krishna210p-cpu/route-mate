import 'package:flutter/material.dart';
import 'main.dart';

// Import the main file which contains DriverDashboard

class VehicleSelectionScreen extends StatelessWidget {
  final String role;

  VehicleSelectionScreen({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/design.png',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 8),
            Text("Select Vehicle"),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Choose Your Vehicle",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Select the vehicle you'll be using for deliveries",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 32),
              
              // Vehicle Cards
              _buildVehicleCard(
                context,
                icon: Icons.motorcycle,
                title: "Bike",
                description: "Fast, small packages",
                subtitle: "Best for quick deliveries",
                color: Colors.blue,
                vehicle: "Bike",
              ),
              SizedBox(height: 16),
              
              _buildVehicleCard(
                context,
                icon: Icons.directions_bus,
                title: "Auto / Tempo",
                description: "Medium load",
                subtitle: "Perfect for medium-sized goods",
                color: Colors.orange,
                vehicle: "Tempo",
              ),
              SizedBox(height: 16),
              
              _buildVehicleCard(
                context,
                icon: Icons.local_shipping,
                title: "Truck",
                description: "Heavy goods, avoids narrow roads",
                subtitle: "For large shipments and bulk delivery",
                color: Colors.purple,
                vehicle: "Truck",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String subtitle,
    required Color color,
    required String vehicle,
  }) {
    return Card(
      elevation: 3,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DriverDashboard(vehicle: vehicle),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: color,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}