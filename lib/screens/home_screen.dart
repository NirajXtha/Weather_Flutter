import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/screens/setting_screen.dart';
import 'package:weather/utils/api_call.dart';
import '../models/settings_provider.dart';

class HomeScreen extends StatefulWidget {
  final dynamic toggleTheme;

  const HomeScreen({super.key, required this.toggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String location;
  bool isLoading = false;
  dynamic data;

  final _locationController = TextEditingController();
  final apiCall = ApiCall();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    setState(() {
      settingsProvider = settingsProvider;
    });

    Future<void> loadCurrentWeather() async {
      try {
        data = await apiCall.getWeatherData(settingsProvider.location);
        // currentWeather.getStatus();
        setState(() {
          isLoading = false;
          settingsProvider.updateWeatherData(data!);
          settingsProvider.getPreData();
        });
      } catch (e) {
        print("Error: $e");
        rethrow;
      }
    }

    forecastWidget(int index) {
      String time;
      String temp;
      if (index > 10) {
        time = "$index";
      } else {
        time = "0$index";
      }
      if(settingsProvider.temperatureUnit == "C") {
        temp = settingsProvider.forecast[index][0];
      } else {
        temp = settingsProvider.forecast[index][1];
      }
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "$time:00",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Image.network(
              "${settingsProvider.forecast[index][3]}",
            ),
            Text(
                "$temp°${settingsProvider.temperatureUnit}",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                )),
            Text("${settingsProvider.forecast[index][2]}",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                )),
          ]),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(settingsProvider.location),
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
            // Location Btn
            IconButton(
              onPressed: () => {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(children: [
                        Expanded(
                          child: TextField(
                            controller: _locationController,
                            decoration: const InputDecoration(
                              hintText: "Enter Location",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            setState(() {
                              settingsProvider
                                  .updateLocation(_locationController.text);
                            });
                            loadCurrentWeather();
                            _locationController.clear();
                            Navigator.pop(context);
                          },
                        ),
                      ])),
                )
              },
              icon: const Icon(Icons.location_on),
            ),
            // Settings Btn
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SettingsScreen(toggleTheme: widget.toggleTheme),
                    ));
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(
                                settingsProvider.icon,
                                width: 100,
                                height: 100,
                              ),
                              Row(
                                spacing: 16,
                                children: [
                                  Text(
                                    "${settingsProvider.temp}°${settingsProvider.temperatureUnit}",
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await loadCurrentWeather();
                                      setState(() {
                                        isLoading = true;
                                      });
                                    },
                                    icon: const Icon(Icons.restart_alt_rounded),
                                  ),
                                ],
                              ),
                              Text(settingsProvider.condition,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ))
                            ],
                          ),
                        ]),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          forecastWidget(0),
                          forecastWidget(1),
                          forecastWidget(2),
                          forecastWidget(3),
                          forecastWidget(4),
                          forecastWidget(5),
                          forecastWidget(6),
                          forecastWidget(7),
                          forecastWidget(8),
                          forecastWidget(9),
                          forecastWidget(10),
                          forecastWidget(11),
                          forecastWidget(12),
                          forecastWidget(13),
                          forecastWidget(14),
                          forecastWidget(15),
                          forecastWidget(16),
                          forecastWidget(17),
                          forecastWidget(18),
                          forecastWidget(19),
                          forecastWidget(20),
                          forecastWidget(21),
                          forecastWidget(22),
                          forecastWidget(23),
                        ],
                      ),
                    ),
                  ),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      weatherCard(
                        context,
                        icon: Icons.air,
                        title: "Wind Pressure",
                        value: "${settingsProvider.windSpeed} ${settingsProvider.windSpeedUnit}",
                      ),
                      weatherCard(
                        context,
                        icon: Icons.explore,
                        title: "Wind Direction",
                        value: settingsProvider.windDirection.toString(),
                      ),
                      weatherCard(
                        context,
                        icon: Icons.water_drop,
                        title: "Humidity",
                        value: "${settingsProvider.humidity}%",
                      ),
                      weatherCard(
                        context,
                        icon: Icons.speed,
                        title: "Pressure",
                        value: "${settingsProvider.presssure} ${settingsProvider.pressureUnit}",
                      ),
                      weatherCard(
                        context,
                        icon: Icons.wb_sunny,
                        title: "UV Index",
                        value: settingsProvider.uv.toString(),
                      ),
                      weatherCard(
                        context,
                        icon: Icons.remove_red_eye,
                        title: "Visibility",
                        value: "${settingsProvider.visibility} ${settingsProvider.visibilityUnit}",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget weatherCard(BuildContext context,
      {required IconData icon, required String title, required String value}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
