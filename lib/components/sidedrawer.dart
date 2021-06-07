import 'package:abccompany/screens/login.dart';
import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  bool isDarkMode = false;
  final ScrollController _scrollController = ScrollController();

  Widget build(BuildContext context) {
    // final provider = Provider.of<MainAppProvider>(context, listen: false);
    return Drawer(
        child: Stack(
      children: [
        Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.75,
            child: Scrollbar(
                controller: _scrollController,
                isAlwaysShown: true,
                child: ListView(
                  controller: _scrollController,
                  children: [
                    DrawerHeader(
                        margin: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // image:
                        ),
                        child: Container(
                            // height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(child: Row(children: <Widget>[])))),
                    SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(Icons.home, size: 20),
                      title: Text('Home'),
                      // onTap: () => pushNavigation(RouteList.cart),
                    ),
                    ListTile(
                      leading: const Icon(Icons.home, size: 20),
                      title: Text('Logout'),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login())),
                    ),
                  ],
                )))
      ],
    ));
  }
}
