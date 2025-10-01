import 'package:abc_consultant/widgets/smooth_grey_borderfeild.dart';
import 'package:abc_consultant/widgets/tracking_timeline_tile.dart';
import 'package:flutter/material.dart';

class TrackOrder extends StatefulWidget {
  const TrackOrder({super.key});

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Size(:height, :width) = size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 1,
        title: Center(
          child: SizedBox(
            height: height * 0.07,
            width: width * 0.3,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter Your Order ID for Tracking',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Order Delivering Process Details
              SizedBox(height: height * 0.02),
              Container(
                height: height * 1.2,
                width: width,
                decoration: BoxDecoration(color: Colors.white),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.1),
                    TrackingTimelineTile(
                      date: "21 April 2025",
                      time: "05:52 pm",
                      status: "Delivered",
                      city: "MUZAFFAR GARH",
                      description:
                          "The shipment has been delivered at the consigneer's address and has been received by self",
                      inProgress: true,
                    ),
                    TrackingTimelineTile(
                      date: "19 April 2025",
                      time: "11:56 pm",
                      status: "Out-for-Delivery",
                      city: "MUZAFFAR GARH",
                      description:
                          "The shipment has been scheduled for delivery.Please keep your mobile on",
                      inProgress: false,
                    ),
                    TrackingTimelineTile(
                      date: "19 April 2025",
                      time: "10:40 am",
                      status: "Reached at Destination",
                      city: "MUZAFFAR GARH",
                      description:
                          "The shipment has been delivered at the destination city and will be schduled for delivery",
                      inProgress: false,
                    ),
                    TrackingTimelineTile(
                      date: "19 April 2025",
                      time: "06:44 pm",
                      status: "In-Transit",
                      city: "Bahawalpur",
                      description:
                          "The shipment has been dispatched and is on its way to destination city",
                      inProgress: false,
                    ),
                    TrackingTimelineTile(
                      date: "19 April 2025",
                      time: "06:28 pm",
                      status: "Arrived atOPS Facility",
                      city: "Bahawalpur",
                      description:
                          "The shipment has been arrived at M&P operations at the origin hub and will be scheduled for transit",
                      inProgress: false,
                    ),
                    TrackingTimelineTile(
                      date: "19 April 2025",
                      time: "11:08 am",
                      status: "Booked",
                      city: "Bahawalpur",
                      description:
                          "Your Order has been placed it will be packed and prepared for shipment",
                      inProgress: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
