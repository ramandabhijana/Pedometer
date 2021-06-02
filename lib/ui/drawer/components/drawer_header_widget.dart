import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DrawerHeaderWidget extends StatelessWidget {
  final String accountName;
  final String accountEmail;
  final String imageUrl;

  const DrawerHeaderWidget({
    Key key,
    this.accountName,
    this.accountEmail,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loggedIn) {
      return UserAccountsDrawerHeader(
        decoration: BoxDecoration(color: Colors.white),
        currentAccountPicture: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl ?? '',
            placeholder: (context, _) => _placeholderAvatar(context),
            errorWidget: (_, __, error) => Icon(Icons.error),
          ),
        ),
        accountName: Text(
          accountName,
          style: TextStyle(
            fontFamily: 'Futura',
            color: Colors.black,
          ),
        ),
        accountEmail: Text(
          accountEmail,
          style: TextStyle(
            fontFamily: 'Futura',
            color: Colors.black54,
          ),
        ),
      );
    } else {
      return Container(width: 0.0, height: AppBar().preferredSize.height);
    }
  }

  bool get loggedIn {
    return accountName != null && accountEmail != null;
  }

  Widget _placeholderAvatar(BuildContext context) {
    return CircleAvatar(
      child: Icon(Icons.person),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
    );
  }
}
