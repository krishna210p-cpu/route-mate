class Driver {
  final String id;
  final String name;
  final String vehicleType;
  final double rating;
  final int completedTrips;
  final double totalEarnings;
  final bool isOnline;

  Driver({
    required this.id,
    required this.name,
    required this.vehicleType,
    this.rating = 4.5,
    this.completedTrips = 0,
    this.totalEarnings = 0.0,
    this.isOnline = true,
  });
}
