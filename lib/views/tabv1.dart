import 'package:MyPharmacie/views/Navigations/all_events.dart';
import 'package:MyPharmacie/views/Navigations/myProfile.dart';
import 'package:MyPharmacie/views/Navigations/qr_code.dart';
import 'package:MyPharmacie/views/Navigations/reservations.dart';
import 'package:flutter/material.dart';

class NavigationRailPage extends StatefulWidget {
  const NavigationRailPage({Key? key}) : super(key: key);

  @override
  State<NavigationRailPage> createState() => _NavigationRailPageState();
}

const _navBarItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outline_rounded),
    activeIcon: Icon(Icons.person_rounded),
    label: 'Profile',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.calendar_month),
    activeIcon: Icon(Icons.calendar_today_outlined),
    label: 'Evenement',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.qr_code),
    activeIcon: Icon(Icons.qr_code_2_rounded),
    label: 'Mon QR Code',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.check_box_outlined),
    activeIcon: Icon(Icons.check_box_rounded),
    label: 'Mes Reservations',
  ),
];

class _NavigationRailPageState extends State<NavigationRailPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isSmallScreen = width < 600;
    final bool isLargeScreen = width > 800;

    return Scaffold(
      bottomNavigationBar: isSmallScreen
          ? BottomNavigationBar(
              backgroundColor: Colors
                  .white, // Assurez-vous que la couleur de fond est définie
              selectedItemColor: const Color.fromARGB(
                  255, 112, 118, 124), // Couleur des items sélectionnés
              unselectedItemColor:
                  Colors.grey, // Couleur des items non sélectionnés
              items: _navBarItems,
              currentIndex: _selectedIndex,
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            )
          : null,
      body: Row(
        children: <Widget>[
          if (!isSmallScreen)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              extended: isLargeScreen,
              destinations: _navBarItems
                  .map((item) => NavigationRailDestination(
                        icon: item.icon,
                        selectedIcon: item.activeIcon,
                        label: Text(item.label!),
                      ))
                  .toList(),
            ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: const [
                Myprofile(),
                AllEvents(),
                MyQrCode(),
                MesReservations(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
