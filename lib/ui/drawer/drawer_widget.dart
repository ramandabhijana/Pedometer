import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/drawer_header_widget.dart';
import 'components/drawer_item_widget.dart';
import 'drawer_state_manager.dart';

class DrawerWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawerStateManager>(builder: (context, drawerManager, child) {
      final currentIndex = drawerManager.getCurrentIndex;
      return Drawer(
        child: Ink(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.only(top: 16, right: 16),
            children: [
              DrawerHeaderWidget(
                imageUrl: drawerManager.imageUrl,
                accountName: drawerManager.accountName,
                accountEmail: drawerManager.accountEmail,
              ),
              DrawerItemWidget(
                icon: Icons.directions_walk,
                name: 'Today',
                isSelected: currentIndex == 0,
                onTap: () { _onTap(context, 0, currentIndex); },
              ),
              DrawerItemWidget(
                icon: Icons.history,
                name: 'My History',
                isSelected: currentIndex == 1,
                onTap: () { _onTap(context, 1, currentIndex); },
              ),
              DrawerItemWidget(
                icon: Icons.group,
                name: 'Ranking',
                isSelected: currentIndex == 2,
                onTap: () { _onTap(context, 2, currentIndex); },
              ),
              DrawerItemWidget(
                icon: Icons.settings,
                name: 'Settings',
                isSelected: currentIndex == 3,
                onTap: () { _onTap(context, 3, currentIndex); },
              ),
              Divider(height: 25, thickness: 1),
              // If logged in -> show log out,
              DrawerItemWidget(
                icon: Icons.logout,
                name: 'Log out',
                isSelected: false,
                onTap: () {

                },
              ),

            ],
          ),
        ),
      );
    });
    
  }

  void _onTap(BuildContext context, int tappedIndex, int currentIndex) {
    Navigator.of(context).pop();
    if (currentIndex == tappedIndex) return;
    final provider = Provider.of<DrawerStateManager>(context, listen: false);
    provider.setCurrentIndex(tappedIndex);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => provider.currentPage)
    );
  }
}
