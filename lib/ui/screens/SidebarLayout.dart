import 'package:flutter/material.dart';
import '../Model/NavItem.dart';
import '../utils/utils.dart';

class SidebarLayout extends StatefulWidget {
  const SidebarLayout({super.key});

  @override
  State<SidebarLayout> createState() => _SidebarLayoutState();
}

class _SidebarLayoutState extends State<SidebarLayout> {
  bool isExpanded = true;
  NavItem selectedItem = NavItem.dashboard;

  int _selectedSidebarIndex = -1;
  int _selectedSubmenuIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isExpanded ? 230 : 70,
            color: Colors.white,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(isExpanded ? Icons.arrow_back_ios : Icons.menu),
                    onPressed: () => setState(() => isExpanded = !isExpanded),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: sidebarItems.length,
                    itemBuilder: (context, index) {
                      final item = sidebarItems[index];
                      final isSelected = _selectedSidebarIndex == index;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _selectedSidebarIndex =
                                    (_selectedSidebarIndex == index)
                                        ? -1
                                        : index;
                                _selectedSubmenuIndex = -1;
                                selectedItem = NavItem.values[index];
                              });
                            },
                            child: Container(
                              color:
                                  isSelected
                                      ? Colors.red.shade50
                                      : Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    item.icon,
                                    color:
                                        isSelected ? Colors.red : Colors.black,
                                    size: 18,
                                  ),
                                  if (isExpanded) ...[
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Text(
                                        item.title,
                                        style: TextStyle(
                                          color:
                                              isSelected
                                                  ? Colors.red
                                                  : Colors.black,
                                          fontSize: 12,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    if (item.submenus.isNotEmpty)
                                      Icon(
                                        isSelected
                                            ? Icons.keyboard_arrow_down
                                            : Icons.keyboard_arrow_right,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          if (isSelected && isExpanded)
                            ...List.generate(item.submenus.length, (i) {
                              final submenu = item.submenus[i];
                              final submenuSelected =
                                  _selectedSubmenuIndex == i;
                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: 40,
                                  top: 4,
                                  bottom: 4,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() => _selectedSubmenuIndex = i);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: Text(
                                      submenu,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            submenuSelected
                                                ? Colors.red
                                                : Colors.black,
                                        fontWeight:
                                            submenuSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: _buildScreenFor(selectedItem),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenFor(NavItem item) {
    switch (item) {
      case NavItem.dashboard:
        return const Center(child: Text('Dashboard Screen'));
      case NavItem.services:
        return const Center(child: Text('Services Screen'));
      case NavItem.clients:
        return const Center(child: Text('Clients Screen'));
      case NavItem.employees:
        return const Center(child: Text('Employees Screen'));
      case NavItem.banking:
        return const Center(child: Text('Banking Screen'));
      case NavItem.expenses:
        return const Center(child: Text('Expenses Screen'));
      case NavItem.notifications:
        return const Center(child: Text('Notifications Screen'));
      case NavItem.files:
        return const Center(child: Text('Files Screen'));
      case NavItem.settings:
        return const Center(child: Text('Settings Screen'));
    }
  }
}
