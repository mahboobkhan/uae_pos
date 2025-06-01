import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _selectedSidebarIndex = -1;
  int _selectedExpandableIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            // ya bar ha
            height: 70,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // ya Logo ke image ha
                SvgPicture.asset(
                  'images/home/ic_yahya_chodrary.svg',
                  height: 50,
                  width: 50,
                ),
                const Spacer(),
                // ya  Search bar ha
                Container(
                  width: 300,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Color(0xfff4f5f7),
                    border: Border.all(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Expanded(
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Container(
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    showProfileDialog(context);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.perm_identity_sharp, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // Red line bar k nichy wali
          Container(height: 1, color: Colors.red),
          // Body with sidebar and main content
          Expanded(
            child: Row(
              children: [
                // Sidebar logo k nichy
                Container(
                  width: 225,
                  decoration: const BoxDecoration(
                    color: Colors.white38,
                    border: Border(
                      right: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  child: ListView(
                    padding: EdgeInsets.only(left: 0),
                    children: [
                      const SizedBox(height: 10),
                      _sidebarItem(Icons.dashboard_outlined, 'Dashboard', 0),
                      _expandableSidebarItem(
                        context,
                        Icons.home_repair_service_outlined,
                        'Services',
                        ['Short Service', 'Projects', 'Create Orders'],
                        1,
                      ),
                      _expandableSidebarItem(
                        context,
                        Icons.people_alt_outlined,
                        'Clients',
                        ['Company ', 'Individuals', 'Finance History'],
                        2,
                      ),
                      _expandableSidebarItem(
                        context,
                        Icons.person_pin_outlined,
                        'Employees',
                        ['Finance', 'Bank Detail'],
                        3,
                      ),
                      _expandableSidebarItem(
                        context,
                        Icons.attach_money,
                        'Banking',
                        ['Add payment method', 'Statement History'],
                        4,
                      ),
                      _expandableSidebarItem(
                        context,
                        Icons.auto_graph_sharp,
                        'Office Expenses',
                        [
                          'Fixed office expanse',
                          'Office maintainance',
                          'Office Supplies',
                          'Maisullius',
                          'Others',
                        ],
                        5,
                      ),
                      _sidebarItem(
                        Icons.notification_add_outlined,
                        'Notifications',
                        6,
                      ),
                      _sidebarItem(
                        Icons.file_download_done_sharp,
                        'Files Cash Flow',
                        7,
                      ),
                      _sidebarItem(Icons.settings_outlined, 'Settings', 8),
                    ],
                  ),
                ),
                // Main content
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildCustomCard(
                                title: 'Employee Card',
                                icons: const [
                                  Icons.edit,
                                  Icons.delete,
                                  Icons.visibility,
                                ],
                                bottomTexts: ['Draft', 'Process', 'countable'],
                              ),
                              const SizedBox(width: 7),
                              buildCustomCard(
                                title: 'Client Card',
                                icons: const [Icons.print, Icons.download,Icons.notifications_active_outlined],
                                bottomTexts: [
                                  'Draft',
                                  'Status',
                                  'Report',
                                ],
                              ),
                              const SizedBox(width: 7),
                              buildCustomCard(
                                title: 'Banking Card',
                                icons: const [Icons.visibility],
                                bottomTexts: ['Bank', 'Detail', 'Withdraw'],
                              ),
                              const SizedBox(width: 7),
                              buildCustomCard(
                                title: 'Service Card',
                                icons: const [Icons.edit],
                                bottomTexts: ['Service', 'Type', 'Edit'],
                              ),
                              const SizedBox(width: 7),
                              buildCustomCard(
                                title: 'Client Card',
                                icons: const [Icons.edit, Icons.delete],
                                bottomTexts: [
                                  'Client Info',
                                  'Status',
                                  'Report',
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                flex: 2, // 2 out of 5 (40%)
                                child: Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Image.asset(
                                    'images/home/graph.png',
                                    width: double.infinity,
                                    height:200,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 3, // 3 out of 5 (60%)
                                child: Container(
                                  height: 200,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.asset(
                                    'images/home/graph.png',
                                    width: double.infinity,
                                    height:200,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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

  Widget _sidebarItem(IconData icon, String label, int index) {
    bool isSelected = _selectedSidebarIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedSidebarIndex = index;
          _selectedExpandableIndex = -1;
        });
      },
      child: Container(
        color: isSelected ? Colors.white : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.red : Colors.black, size: 18),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.red : Colors.black,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _expandableSidebarItem(
    BuildContext context,
    IconData icon,
    String title,
    List<String> children,
    int index,
  ) {
    bool isExpandableSelected = _selectedExpandableIndex == index;

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        iconTheme: const IconThemeData(size: 16), // icon size kam ho ga yaha sy
      ),
      child: ExpansionTile(
        initiallyExpanded: isExpandableSelected,
        leading: Icon(
          icon,
          color: isExpandableSelected ? Colors.red : Colors.black,
          size: 18,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isExpandableSelected ? Colors.red : Colors.black,
            fontSize: 12,
            fontWeight:
                isExpandableSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.only(left: 40),
        iconColor: isExpandableSelected ? Colors.red : Colors.black,
        collapsedIconColor: isExpandableSelected ? Colors.red : Colors.black,
        onExpansionChanged: (expanded) {
          setState(() {
            _selectedExpandableIndex = expanded ? index : -1;
            _selectedSidebarIndex = -1;
          });
        },
        children:
            children
                .map(
                  (child) => ListTile(
                    dense: true,
                    title: Text(
                      child,
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    onTap: () {
                      // Handle submenu tap
                    },
                  ),
                )
                .toList(),
      ),
    );
  }
}

Widget buildCustomCard({
  required String title,
  List<IconData>? icons,
  required List<String> bottomTexts,
}) {
  return Container(
    height: 120,
    width: 197,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.red, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Icons
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            if (icons != null && icons.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children:
                    icons
                        .map(
                          (icon) => Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Icon(icon, size: 16),
                          ),
                        )
                        .toList(),
              ),
          ],
        ),

        const Spacer(),

        // Divider and Texts in Stack
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            const Divider(thickness: 1, color: Colors.grey, height: 30),

            Center(
              child: SizedBox(
                width: 140,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(bottomTexts[0], style: const TextStyle(fontSize: 10)),
                    Container(width: 1, height: 15, color: Colors.grey),
                    Text(bottomTexts[1], style: const TextStyle(fontSize: 10)),
                    Container(width: 1, height: 15, color: Colors.grey),
                    Text(bottomTexts[2], style: const TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
