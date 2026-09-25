import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/driver.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // Storage keys
  static const String _ordersKey = 'routemate_orders';
  static const String _driverKey = 'routemate_driver';

  // Order management
  List<Order> _orders = [];
  
  List<Order> get orders => _orders;
  
  void addOrder(Order order) {
    _orders.insert(0, order);
    debugPrint('Order added: ${order.id}');
  }

  List<Order> getCustomerOrders() {
    return _orders.where((o) => o.driverId == null || o.status != 'Delivered').toList();
  }

  List<Order> getOrderHistory() {
    return _orders.where((o) => o.status == 'Delivered').toList();
  }

  void updateOrderStatus(String orderId, String status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final order = _orders[index];
      _orders[index] = Order(
        id: order.id,
        pickupLocation: order.pickupLocation,
        dropLocation: order.dropLocation,
        packageType: order.packageType,
        contactNumber: order.contactNumber,
        distance: order.distance,
        estimatedTime: order.estimatedTime,
        status: status,
        createdAt: order.createdAt,
        driverId: order.driverId,
      );
      debugPrint('Order $orderId status updated to: $status');
    }
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Driver management
  Driver? _currentDriver;

  Driver? get currentDriver => _currentDriver;

  void setDriver(Driver driver) {
    _currentDriver = driver;
    debugPrint('Driver set: ${driver.name}, Vehicle: ${driver.vehicleType}');
  }

  void updateDriverEarnings(double amount) {
    if (_currentDriver != null) {
      _currentDriver = Driver(
        id: _currentDriver!.id,
        name: _currentDriver!.name,
        vehicleType: _currentDriver!.vehicleType,
        rating: _currentDriver!.rating,
        completedTrips: _currentDriver!.completedTrips + 1,
        totalEarnings: _currentDriver!.totalEarnings + amount,
        isOnline: _currentDriver!.isOnline,
      );
    }
  }

  double get todayEarnings {
    // Simplified: return last 5 earnings
    return _currentDriver?.totalEarnings ?? 0.0;
  }

  int get completedDeliveries {
    return _currentDriver?.completedTrips ?? 0;
  }

  // Clear all data
  void clear() {
    _orders.clear();
    _currentDriver = null;
  }
}
