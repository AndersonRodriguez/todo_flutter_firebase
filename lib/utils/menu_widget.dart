import 'package:flutter/material.dart';
import 'package:todo_flutter_firebase/screens/offline/offline_screen.dart';
import 'package:todo_flutter_firebase/screens/product/product_screen.dart';
import 'package:todo_flutter_firebase/screens/settings/settings_screen.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://cdn.pixabay.com/photo/2022/08/28/09/29/bee-7416162_960_720.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
            ),
            title: const Text('Inicio'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.shopping_cart,
            ),
            title: const Text('Productos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.offline_pin,
            ),
            title: const Text('Offiline'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OffileneScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
            ),
            title: const Text('Configuraciones'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
