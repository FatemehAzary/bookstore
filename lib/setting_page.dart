import 'package:flutter/material.dart';
import 'package:project1/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  double _value = 16;
  late SharedPreferences _pref;
  String prefKey = "value";
  void saveOnPref(double value) async {
    _pref = await SharedPreferences.getInstance();
    _pref.setDouble(prefKey, value);
  }

  void loadFonts() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _value = _pref.getDouble(prefKey) ?? 16.0;
    });
  }

  @override
  void initState() {
    loadFonts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ListTile(
              title: const Text('Dark/Light Theme'),
              trailing: Switch(
                activeColor: Colors.white,
                value: Provider.of<ThemeProvider>(context).themeMode ==
                    ThemeMode.dark,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                },
              ),
            ),
            const Divider(
              height: 10,
              thickness: 5,
              color: Colors.green,
            ),
            Container(
              margin: const EdgeInsets.only(right: 10, top: 10, left: 10),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Slider(
                thumbColor: Colors.red.shade900,
                value: _value,
                activeColor: Colors.black,
                inactiveColor: Colors.grey.shade400,
                min: 14.0,
                max: 24.0,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                  saveOnPref(value);
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "this is a test for fontsize...",
              style: TextStyle(
                fontSize: _value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
