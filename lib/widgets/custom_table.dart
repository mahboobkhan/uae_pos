import 'package:flutter/material.dart';

class CustomTable extends StatefulWidget {
  final double width;
  final double height;
  final List<String> data;
  final String title;
  final Color textCOlor;

  const CustomTable({
    required this.width,
    required this.height,
    required this.data,
    required this.title,
    required this.textCOlor,
    super.key,
  });

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: height * 0.15,
            width: width,
            color: Colors.grey,
            child: Center(
              child: Text(
                widget.title,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.005),
          SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  widget.data
                      .map(
                        (item) => Column(
                          children: [
                            Container(
                              width: width,
                              color: Colors.grey.shade300,
                              child: Center(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    color: widget.textCOlor,
                                    fontSize: height * 0.02,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                          ],
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
