import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AbcScreen extends StatefulWidget {
  const AbcScreen({super.key});

  @override
  State<AbcScreen> createState() => _AbcScreenState();
}

class _AbcScreenState extends State<AbcScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/home/ic_yahya_chodrary.svg',
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome to ABC Services",
              style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              "Unlock",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold,color: Colors.grey),
              textAlign: TextAlign.center,
            ),

          ],
        ),
      ),
    );
  }
}
