class Order {
  final String id;
  final String pickupLocation;
  final String dropLocation;
  final String packageType;
  final String contactNumber;
  final double distance;
  final int estimatedTime;
  final String status; // 'Assigned', 'On the way', 'Delivered'
  final DateTime createdAt;
  final String? driverId;

  Order({
    required this.id,
    required this.pickupLocation,
    required this.dropLocation,
    required this.packageType,
    required this.contactNumber,
    required this.distance,
    required this.estimatedTime,
    required this.status,
    required this.createdAt,
    this.driverId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pickupLocation': pickupLocation,
      'dropLocation': dropLocation,
      'packageType': packageType,
      'contactNumber': contactNumber,
      'distance': distance,
      'estimatedTime': estimatedTime,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'driverId': driverId,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      pickupLocation: json['pickupLocation'],
      dropLocation: json['dropLocation'],
      packageType: json['packageType'],
      contactNumber: json['contactNumber'],
      distance: json['distance'],
      estimatedTime: json['estimatedTime'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      driverId: json['driverId'],
    );
  }
}
