import 'package:flutter/material.dart';

class DrawerItemWidget extends StatelessWidget {
  final IconData icon;
  final String name;
  final GestureTapCallback onTap;
  final isSelected;

  const DrawerItemWidget({
    Key key,
    this.icon,
    this.name,
    this.onTap,
    this.isSelected
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.15) : null,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: ListTile(
        title: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Theme.of(context).primaryColor : null,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                name,
                style: TextStyle(
                  color: isSelected ? Theme.of(context).primaryColor : null,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
