import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VehicleCard extends StatelessWidget {
  final String? vehicleType;
  final String? vehicleRegistrationNumber;
  final bool? isPolicyExpired;

  const VehicleCard({
    Key? key,
    required this.vehicleType,
    required this.vehicleRegistrationNumber,
    required this.isPolicyExpired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('entered Card build');
    return Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8.0),
    //gradient: LinearGradient(
    //  colors: [Colors.blue.shade300, Colors.blue.shade500],
    //  begin: Alignment.topLeft,
    //  end: Alignment.bottomRight,
    //),
    color: Colors.white,
    border: Border.all(color:Colors.blue),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        spreadRadius: 2,
        blurRadius: 4,
        offset: const Offset(0, 2), // changes position of shadow
      ),
    ],
  ),
  child: Card(
    elevation: 0, // No elevation for the card as it's already in the container with shadow
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    color: Colors.transparent, // Transparent background color for the card
    child: InkWell(
      onTap: () {
        // Add your onTap logic here
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // First Column - Vehicle Icon
            Icon(
              _getVehicleIcon(vehicleType!),
              size: 80,
              color: Colors.blue, // Adjust color as needed
            ),
            const SizedBox(width: 8),
            // Second Column - Vehicle Information
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Row - Vehicle Registration Number
                Text(
                  'Registration Number: $vehicleRegistrationNumber',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Second Row - Policy Status
                //Text(
                //  isPolicyExpired! ? 'Policy Expired' : 'Policy Active',
                //  style: TextStyle(
                //    color: isPolicyExpired! ? Colors.red : Colors.green,
                //    fontWeight: FontWeight.bold,
                //  ),
                //),
                Row(
                      children: [
                        // Policy Status Indicator
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: !isPolicyExpired! ? Colors.red : Colors.green,
                          ),
                          child: Center(
                            child: Icon(
                              !isPolicyExpired! ? Icons.close : Icons.check,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          !isPolicyExpired! ? 'Policy Expired' : 'Policy Active',
                          style: TextStyle(
                            color: !isPolicyExpired! ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
              ],
            ),
          ],
        ),
      ),
    ),
  ),
);

  }

  // Helper function to get the vehicle icon based on the vehicle type
  IconData _getVehicleIcon(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'two-wheeler':
        return Icons.motorcycle;
      case 'four-wheeler':
        return Icons.directions_car;
      case 'six-wheeler':
        return Icons.local_shipping;
      default:
        return Icons.help_outline; // Default icon
    }
  }
}
