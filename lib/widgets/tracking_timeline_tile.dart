import 'package:flutter/material.dart';

class TrackingTimelineTile extends StatelessWidget {
  final String date;
  final String time;
  final String status;
  final String city;
  final String description;
  final bool inProgress;

  final double? width;
  final double? height;

  const TrackingTimelineTile({
    super.key,
    required this.date,
    required this.time,
    required this.status,
    required this.city,
    required this.description,
    required this.inProgress,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = width ?? MediaQuery.of(context).size.width;
    final double screenHeight = height ?? MediaQuery.of(context).size.height;

    final Color dotColor = inProgress ? Colors.red : Colors.grey;
    final Color lineColor =
        inProgress ? Colors.red.shade400 : Colors.grey.shade400;
    final Color textColor = inProgress ? Colors.red : Colors.grey;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Left spacing
        SizedBox(width: screenWidth * 0.3),

        // Date & Time
        SizedBox(
          width: screenWidth * 0.12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(date, style: const TextStyle(color: Colors.blue)),
              Text(time, style: const TextStyle(color: Colors.black)),
            ],
          ),
        ),

        SizedBox(width: screenWidth * 0.02),

        // Dot + Line
        SizedBox(
          width: screenWidth * 0.02,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: dotColor,
                radius: screenWidth * 0.005,
              ),
              Container(
                height: screenHeight * 0.14,
                width: screenWidth * 0.0025,
                color: lineColor,
              ),
            ],
          ),
        ),

        SizedBox(width: screenWidth * 0.02),

        // Status + City + Description
        SizedBox(
          width: screenWidth * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
              Text(
                city,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
