import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather/models/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  final dynamic toggleTheme;

  const SettingsScreen({super.key, required this.toggleTheme});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final Uri url = Uri.parse("https://github.com/NirajXtha");

  _launchUrl() async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          actions: [
            // Dark Mode Btn
            IconButton(
              onPressed: widget.toggleTheme,
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
            ),
          ],
        ),
        body: Container(
          color: Theme.of(context).colorScheme.surface,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Measurement Unit Options Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: const Text(
                          "Units",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      ListTile(
                        title: const Text("Temperature"),
                        trailing: DropdownButton<String>(
                          value: settingsProvider.temperatureUnit,
                          items: const [
                            DropdownMenuItem(
                              value: "C",
                              child: Text("Celsius"),
                            ),
                            DropdownMenuItem(
                              value: "F",
                              child: Text("Fahrenheit"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              settingsProvider.updateTemperatureUnit(value!);
                              settingsProvider.updateData();
                            });
                          },
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text("Wind Speed"),
                        trailing: DropdownButton<String>(
                          value: settingsProvider.windSpeedUnit,
                          items: const [
                            DropdownMenuItem(
                              value: "km/h",
                              child: Text("km/h"),
                            ),
                            DropdownMenuItem(
                              value: "mph",
                              child: Text("mph"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              settingsProvider.updateWindSpeedUnit(value!);
                              settingsProvider.updateData();
                            });
                          },
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text("Pressure"),
                        trailing: DropdownButton<String>(
                          value: settingsProvider.pressureUnit,
                          items: const [
                            DropdownMenuItem(
                              value: "hPa",
                              child: Text("hPa"),
                            ),
                            DropdownMenuItem(
                              value: "inHg",
                              child: Text("inHg"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              settingsProvider.updatePressureUnit(value!);
                              settingsProvider.updateData();
                            });
                          },
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text("Visibility"),
                        trailing: DropdownButton<String>(
                          value: settingsProvider.visibilityUnit,
                          items: const [
                            DropdownMenuItem(
                              value: "km",
                              child: Text("km"),
                            ),
                            DropdownMenuItem(
                              value: "miles",
                              child: Text("miles"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              settingsProvider.updateVisibilityUnit(value!);
                              settingsProvider.updateData();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // About Section Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text("About"),
                  onTap: _launchUrl,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
