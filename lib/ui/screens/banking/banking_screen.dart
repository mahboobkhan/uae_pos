import 'package:flutter/material.dart';

class BankingScreen extends StatefulWidget {
  const BankingScreen({super.key});

  @override
  State<BankingScreen> createState() => _BankingScreenState();
}

class _BankingScreenState extends State<BankingScreen> {

  final List<String> categories = [
    'All',
    'New',
    'Pending',
    'Completed',
    'Stop',
  ];
  String? selectedCategory;
  final List<String> categories1 = [
    'No Tags',
    'Tag 001',
    'Tag 002',
    'Sample Tag',
  ];
  String? selectedCategory1;
  final List<String> categories2 = ['All', 'Pending', 'Paid'];
  String? selectedCategory2;
  final List<String> categories3 = [
    'All',
    'Toady',
    'Yesterday',
    'Last 7 Days',
    'Last 30 Days',
    'Custom Range',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 45,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(2),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Dropdowns
                _buildDropdown(selectedCategory, "Customer Type", categories, (
                  newValue,
                ) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                }),
        
                _buildDropdown(selectedCategory1, "Select Tags", categories1, (
                  newValue,
                ) {
                  setState(() {
                    selectedCategory1 = newValue!;
                  });
                }),
                _buildDropdown(selectedCategory2, "Payment Status", categories2, (
                  newValue,
                ) {
                  setState(() {
                    selectedCategory2 = newValue!;
                  });
                }),
                const SizedBox(width: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.11,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.red, width: 1.5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const TextField(
                        style: TextStyle(fontSize: 12),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(fontSize: 12),
                          border: InputBorder.none,
                          isCollapsed: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 310),
                GestureDetector(
                  onTap: () {
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildDropdown(
      String? selectedValue,
      String hintText,
      List<String> items,
      ValueChanged<String?> onChanged, {
        Icon icon = const Icon(Icons.arrow_drop_down),
      }) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Container(
        width: 140,
        height: 25,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 1),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue,
            icon: icon,
            hint: Text(hintText),
            style: TextStyle(fontSize: 10),
            onChanged: onChanged,
            items:
            items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  padding: EdgeInsets.zero,
                  child: Text(value),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
