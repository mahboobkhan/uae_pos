import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(height: 80,),
          Container(
            width: 220,
            color: Colors.grey[900],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                _sidebarItem(Icons.dashboard, 'Dashboard'),
                _sidebarItem(Icons.build, 'Services'),
                _sidebarItem(Icons.people, 'Clients'),
                _sidebarItem(Icons.person, 'Employees'),
                _sidebarItem(Icons.money, 'Office Expenses'),
                _sidebarItem(Icons.account_balance, 'Bank'),
                _sidebarItem(Icons.attach_money, 'Cash Flow'),
              ],
            ),
          ),

          // Main content area
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Column(
                  children: [
                    Container(
                      height: 70,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: const Color(0xFF0F3460),
                      child: Row(
                        children: [
                          // Company logo on the left
                          Image.asset(
                            'assets/logo.png', // use SvgPicture.asset(...) for SVGs
                            height: 40,
                            width: 40,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 30),

                          // Centered search bar
                          Expanded(
                            child: Center(
                              child: Container(
                                width: 400,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: const Row(
                                  children: [
                                    Icon(Icons.search, color: Colors.red),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Search...',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(color: Colors.red),
                                        ),
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),

                    // Red line below the top bar
                    Container(height: 2, color: Colors.red),
                  ],
                ),

                // Main body content
                Expanded(
                  child: Container(
                    color: const Color(0xFF16213E),
                    child: const Center(
                      child: Text(
                        'Welcome to the Dashboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: () {
        // Navigation logic here
      },
    );
  }
}
