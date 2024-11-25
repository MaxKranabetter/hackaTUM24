import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common_widgets/free_text_input.dart';
import 'package:frontend/constants/app_spacing.dart';
import 'package:frontend/data/models/activity_model.dart';
import 'package:frontend/data/models/user_model.dart';
import 'package:frontend/providers/activity_model_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/routing/app_routing.dart';
import 'package:frontend/screens/create_activity/widgets/choose_popular_activities_widget.dart';
import 'package:frontend/screens/create_activity/widgets/choose_when_widget.dart';
import 'package:frontend/screens/create_activity/widgets/choose_who_widget.dart';
import 'package:frontend/screens/create_activity/widgets/event_tile.dart';
import 'package:frontend/theme/colors.dart';
import 'package:http/http.dart' as httpreq;
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class CreateActivityScreen extends ConsumerStatefulWidget {
  const CreateActivityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateActivityScreenState();
}

class _CreateActivityScreenState extends ConsumerState<CreateActivityScreen> {
  final _formKey = GlobalKey<FormState>();

  final double _sidePadding = 16.0;
  // Controllers for the text fields
  final TextEditingController _whatController = TextEditingController();
  final TextEditingController _whereController = TextEditingController();
  final TextEditingController _whoMinController = TextEditingController();
  final TextEditingController _whoMaxController = TextEditingController();

  final TimeOfDay _selectedStartTime = TimeOfDay.now();
  final TimeOfDay _selectedEndTime = TimeOfDay.fromDateTime(
    DateTime.now().add(const Duration(hours: 1)),
  );

  double _selectedRadius = 0.0;

  LatLng? _selectedLocation; // Stores the chosen location

  final popularActivitiesList = [
    "Grab lunch",
    "Football",
    "Beerpong match",
    "Chess",
    "Jogging",
    "Calisthenics",
  ];

  final popularEventsList = [
    {
      "name": "Christmas Market",
      "imgUrl":
          "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1d/9f/2c/40/caption.jpg?w=1200&h=-1&s=1",
    },
    {
      "name": "New Year's Eve Party",
      "imgUrl":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrgv-R96ZE15l_J8_o9dnKK_mSogq5gnnYZg&s",
    },
    {
      "name": "Karaoke Night",
      "imgUrl":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQt5jlERDoa8QeG3PZfpJHisjeJpOuoyUBMPw&s",
    },
    {
      "name": "Open Mic Night",
      "imgUrl":
          "data:image/jpeg;base64,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",
    },
  ];

  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _selectedLocation = LatLng(48.265454, 11.669124); // Default to Munich
  }

  void _nextScreen() {
    setState(() {
      if (currentIndex < _buildScreens(screenWidth).length - 1) {
        currentIndex++; // Go to the next screen
        pressedNext = true;
      }
    });
  }

  bool pressedNext = true;

  void _previousScreen() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--; // Go to the previous screen
        pressedNext = false;
      }
    });
  }

  @override
  void dispose() {
    // Dispose of controllers when no longer needed
    _whatController.dispose();
    _whereController.dispose();
    _whoMinController.dispose();
    _whoMaxController.dispose();
    _pageController.dispose();

    super.dispose();
  }

  late double screenWidth;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: _buildScreens(screenWidth).map((screen) {
          return screen.withKey(currentIndex);
        }).toList(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: // Back and Continue Buttons
            Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: ElevatedButton(
              onPressed: () async {
                if (currentIndex == 0) {
                  if (_whatController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Please enter a description of the activity'),
                      ),
                    );
                    return;
                  }
                }

                if (currentIndex == 3) {
                  if (_formKey.currentState!.validate()) {
                    // Get location name from lat/lon

                    // Create the activity using the provider
                    final activity = ActivityModel(
                      description: _whatController.text,
                      minParticipants: int.parse(_whoMinController.text),
                      maxParticipants: int.parse(_whoMaxController.text),
                      timeRange: {
                        "startTime": _selectedStartTime,
                        "endTime": _selectedEndTime,
                      },
                      location: {
                        "lat": _selectedLocation!.latitude,
                        "lon": _selectedLocation!.longitude,
                        "radius": _selectedRadius,
                      },
                      participants: [],
                    );

                    // go to the activity selection screen and pass the activity as extra

                    context.goNamed(AppRouting.selectActivity, extra: activity);
                  }
                }

                _pageController.animateToPage(
                  currentIndex + 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor, // Green button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: _sidePadding,
                  vertical: 24.0,
                ),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            )),
            gapW8
          ],
        ),
      ),
    );
  }

  List<Widget> _buildScreens(screenWidth) {
    return [
      chooseWhatWidget(screenWidth),
      chooseWhereWidget(),
      ChooseWhenWidget(
        startTime: _selectedStartTime,
        endTime: _selectedEndTime,
      ),
      ChooseWhoWidget(
          minParticipantsController: _whoMinController,
          maxParticipantsController: _whoMaxController,
          formKey: _formKey),
    ];
  }

  Widget chooseWhatWidget(screenWidth) {
    return Center(
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 24, 16, 18),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.go(AppRouting.home),
                  icon: const Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.black,
                    size: 32,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  "Start Activity",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      fontSize: 28),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: const Color.fromARGB(255, 217, 217, 217),
          height: 1,
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "Choose a popular activity" section
                const Padding(
                  padding: EdgeInsets.fromLTRB(22, 13, 0, 15),
                  child: Text(
                    "Popular activities",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 5, 22, 17),
                  child: ChoosePopularActivitiesWidget(
                    activities: popularActivitiesList,
                    index: currentIndex,
                    pageController: _pageController,
                    whatController: _whatController,
                  ),
                ),
                Container(
                  height: 1,
                  width: screenWidth,
                  color: const Color.fromARGB(255, 217, 217, 217),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(22, 17, 0, 12),
                  child: Text(
                    "Events near you",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 22, 28),
                  child: recommendedEventsWidget(),
                ),
                Container(
                  height: 1,
                  width: screenWidth,
                  color: const Color.fromARGB(255, 217, 217, 217),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(22, 20, 0, 14),
                  child: Text(
                    "Something in mind?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
                    child: FreeTextInputBox(
                      textEditingController: _whatController,
                      hintText: "Describe your activity",
                    )),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget chooseWhereWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 24, 16, 18),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => {
                    _pageController.animateToPage(
                      currentIndex - 1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    )
                  },
                  icon: const Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.black,
                    size: 32,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  "Select a Location",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      fontSize: 28),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: const Color.fromARGB(255, 217, 217, 217),
          height: 1,
        ),
        // Map
        Expanded(
          child: FlutterMap(
            options: MapOptions(
              initialCenter: _selectedLocation ??
                  LatLng(48.265454, 11.669124), // Default to Munich City
              initialZoom: 15.0,
              onTap: (tapPosition, point) {
                setState(() {
                  _selectedLocation = point;
                  _updateWhereController();
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              if (_selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_pin,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),

              // Add a circle to show the search radius
              if (_selectedLocation != null)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: _selectedLocation!,
                      color: Colors.blue.withOpacity(0.3),
                      borderStrokeWidth: 2,
                      borderColor: Colors.blue,
                      radius: _selectedRadius * 100,
                    ),
                  ],
                ),
            ],
          ),
        ),

        // Radius selection
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Set Search Radius: ${_selectedRadius.toStringAsFixed(1)} km",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Slider(
                value: _selectedRadius,
                min: 0.0,
                max: 20.0,
                divisions: 49,
                label: "${_selectedRadius.toStringAsFixed(1)} km",
                onChanged: (value) {
                  setState(() {
                    _selectedRadius = value;
                    _updateWhereController();
                  });
                },
              ),
            ],
          ),
        ),

        // Selected location display
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
          child: TextField(
            controller: _whereController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: "Selected Location:",
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  void _updateWhereController() {
    if (_selectedLocation != null) {
      _whereController.text =
          "Lat: ${_selectedLocation!.latitude.toStringAsFixed(4)}, "
          "Lng: ${_selectedLocation!.longitude.toStringAsFixed(4)} "
          "(Radius: ${_selectedRadius.toStringAsFixed(1)} km)";
    } else {
      _whereController.text = "No location selected";
    }
  }

  Widget recommendedEventsWidget() {
    return Column(children: [
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two items per row
          crossAxisSpacing: 12.0, // Spacing between items horizontally
          mainAxisSpacing: 12.0, // Spacing between items vertically
          mainAxisExtent: 99.0, // Fixed height of each item
        ),
        itemCount: popularEventsList.length,
        itemBuilder: (context, index) {
          final event = popularEventsList[index];
          return GestureDetector(
              onTap: () {
                _whatController.text = event["name"]!;
                _pageController.animateToPage(
                  currentIndex + 1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: EventTile(
                imgPath: event["imgUrl"]!,
                title: event["name"]!,
              ));
        },
      )
    ]);
  }

  Future<String?> getLocationName(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1');
    final response = await httpreq.get(url, headers: {
      'User-Agent': 'Flutter App',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['display_name']; // Full location name
    } else {
      return null; // Handle error appropriately
    }
  }
}

extension WithKey on Widget {
  Widget withKey(int index) {
    return KeyedSubtree(
      key: ValueKey<int>(index),
      child: this,
    );
  }
}
