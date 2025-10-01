import 'package:flutter/material.dart';

class UnusedOrderTracking extends StatefulWidget {
  const UnusedOrderTracking({super.key});

  @override
  State<UnusedOrderTracking> createState() => _UnusedOrderTrackingState();
}

class _UnusedOrderTrackingState extends State<UnusedOrderTracking> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SizedBox(height: height * 0.02),
        // //Row for Gap from left for container
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       //Gap width from left
        //       // SizedBox(width: width * 0.023),
        //       Container(
        //         height: height * 0.25,
        //         width: width,
        //         decoration: BoxDecoration(color: Colors.white),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             SizedBox(width: width * 0.03),
        //             Column(
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 SizedBox(height: height * 0.05),
        //                 Text(
        //                   "Consignment Number",
        //                   style: TextStyle(color: Colors.blueGrey),
        //                 ),
        //                 SimpleGreyBorderContainer(
        //                   height: height * 0.05,
        //                   width: width * 0.2,
        //                   child: TextField(
        //                     style: TextStyle(
        //                       fontSize: 15,
        //                       color: Colors.grey,
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                     cursorHeight: height * 0.02,
        //                     decoration: InputDecoration(
        //                       hintText: "54763931000****",
        //                       hintStyle: TextStyle(
        //                         fontSize: 15,
        //                         color: Colors.grey,
        //                         fontWeight: FontWeight.normal,
        //                       ),
        //                       contentPadding: EdgeInsets.only(
        //                         left: 8,
        //                         bottom: 15,
        //                       ),
        //                       border: InputBorder.none,
        //                     ),
        //                   ),
        //                 ),
        //                 //Track Button
        //                 SizedBox(height: height * 0.01),
        //                 MaterialButton(
        //                   onPressed: () {},
        //                   color: Colors.deepOrange,
        //                   height: height * 0.05,
        //                   minWidth: 280,
        //                   child: Text(
        //                     "Track",
        //                     style: TextStyle(
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             //Order ID Feild
        //             SizedBox(width: width * 0.02),
        //             Column(
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 SizedBox(height: height * 0.05),
        //                 Text(
        //                   "Order ID",
        //                   style: TextStyle(color: Colors.blueGrey),
        //                 ),
        //                 SimpleGreyBorderContainer(
        //                   color: Colors.grey.shade300,
        //                   height: height * 0.05,
        //                   width: width * 0.15,
        //                   child: Padding(
        //                     padding: const EdgeInsets.only(
        //                       left: 8.0,
        //                       bottom: 2,
        //                     ),
        //                     child: Align(
        //                       alignment: Alignment.centerLeft,
        //                       child: Text(
        //                         "547639317690", // Example Order ID
        //                         style: TextStyle(
        //                           fontSize: 15,
        //                           color: Colors.black,
        //                           fontWeight: FontWeight.normal,
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             SizedBox(width: width * 0.02),
        //             Column(
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 SizedBox(height: height * 0.05),
        //                 Text(
        //                   "Booking Date",
        //                   style: TextStyle(color: Colors.blueGrey),
        //                 ),
        //                 SimpleGreyBorderContainer(
        //                   color: Colors.grey.shade300,
        //                   height: height * 0.05,
        //                   width: width * 0.15,
        //                   child: Padding(
        //                     padding: const EdgeInsets.only(
        //                       left: 8.0,
        //                       bottom: 2,
        //                     ),
        //                     child: Align(
        //                       alignment: Alignment.centerLeft,
        //                       child: Text(
        //                         "10 April 2025",
        //                         style: TextStyle(
        //                           fontSize: 15,
        //                           color: Colors.black,
        //                           fontWeight: FontWeight.normal,
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             SizedBox(width: width * 0.02),
        //             Column(
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 SizedBox(height: height * 0.05),
        //                 Text(
        //                   "From",
        //                   style: TextStyle(color: Colors.blueGrey),
        //                 ),
        //                 SimpleGreyBorderContainer(
        //                   color: Colors.grey.shade300,
        //                   height: height * 0.05,
        //                   width: width * 0.15,
        //                   child: Padding(
        //                     padding: const EdgeInsets.only(
        //                       left: 8.0,
        //                       bottom: 2,
        //                     ),
        //                     child: Align(
        //                       alignment: Alignment.centerLeft,
        //                       child: Text(
        //                         "Sajid Ali",
        //                         style: TextStyle(
        //                           fontSize: 15,
        //                           color: Colors.black,
        //                           fontWeight: FontWeight.normal,
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //                 SizedBox(height: height * 0.008),
        //                 SimpleGreyBorderContainer(
        //                   color: Colors.grey.shade300,
        //                   height: height * 0.05,
        //                   width: width * 0.15,
        //                   child: Padding(
        //                     padding: const EdgeInsets.only(
        //                       left: 8.0,
        //                       bottom: 2,
        //                     ),
        //                     child: Align(
        //                       alignment: Alignment.centerLeft,
        //                       child: Text(
        //                         "Bahawalpur",
        //                         style: TextStyle(
        //                           fontSize: 15,
        //                           color: Colors.black,
        //                           fontWeight: FontWeight.normal,
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             SizedBox(width: width * 0.02),
        //             Column(
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 SizedBox(height: height * 0.05),
        //                 Text(
        //                   "To",
        //                   style: TextStyle(color: Colors.blueGrey),
        //                 ),
        //                 SimpleGreyBorderContainer(
        //                   color: Colors.grey.shade300,
        //                   height: height * 0.05,
        //                   width: width * 0.15,
        //                   child: Padding(
        //                     padding: const EdgeInsets.only(
        //                       left: 8.0,
        //                       bottom: 2,
        //                     ),
        //                     child: Align(
        //                       alignment: Alignment.centerLeft,
        //                       child: Text(
        //                         "Abdul Samad",
        //                         style: TextStyle(
        //                           fontSize: 15,
        //                           color: Colors.black,
        //                           fontWeight: FontWeight.normal,
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //                 SizedBox(height: height * 0.008),
        //                 SimpleGreyBorderContainer(
        //                   color: Colors.grey.shade300,
        //                   height: height * 0.05,
        //                   width: width * 0.15,
        //                   child: Padding(
        //                     padding: const EdgeInsets.only(
        //                       left: 8.0,
        //                       bottom: 2,
        //                     ),
        //                     child: Align(
        //                       alignment: Alignment.centerLeft,
        //                       child: Text(
        //                         "Muzaffar Garh",
        //                         style: TextStyle(
        //                           fontSize: 15,
        //                           color: Colors.black,
        //                           fontWeight: FontWeight.normal,
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),

        //             //**Help and Notify me button Space */

        //             // SizedBox(width: width * 0.02),
        //             // Column(mainAxisAlignment: MainAxisAlignment.center,
        //             // crossAxisAlignment: CrossAxisAlignment.start,
        //             // children: [
        //             //   MaterialButton(onPressed: (){})
        //             // ],
        //             // )
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
