import 'package:flutter/material.dart';
import 'package:todo_flutter_firebase/providers/preference_user.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _secondaryColor = false;

  int _sex = 1;

  final _prefs = PreferenceUser();

  @override
  void initState() {
    super.initState();

    _secondaryColor = _prefs.secondaryColor;
    _sex = _prefs.sex;
  }

  _setSelectedRadio(dynamic value) {
    _prefs.sex = value;

    setState(() {
      _sex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuraciones'),
        backgroundColor: _prefs.secondaryColor ? Colors.green : Colors.blue,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(6.0),
            child: const Text(
              'Tus configuraciones',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Color secundario'),
            value: _secondaryColor,
            onChanged: (value) {
              setState(() {
                _secondaryColor = value;
                _prefs.secondaryColor = value;
              });
            },
          ),
          const Divider(),
          RadioListTile(
            value: 1,
            title: const Text('Masculino'),
            groupValue: _sex,
            onChanged: _setSelectedRadio,
          ),
          RadioListTile(
            value: 2,
            title: const Text('Femenino'),
            groupValue: _sex,
            onChanged: _setSelectedRadio,
          )
        ],
      ),
    );
  }
}
