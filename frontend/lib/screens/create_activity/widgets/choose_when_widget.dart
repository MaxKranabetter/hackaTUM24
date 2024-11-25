import 'package:flutter/material.dart';
import 'package:frontend/theme/colors.dart';
import 'package:time_range_picker/time_range_picker.dart';

class ChooseWhenWidget extends StatefulWidget {
  TimeOfDay startTime;
  TimeOfDay endTime;

  ChooseWhenWidget({super.key, required this.startTime, required this.endTime});

  @override
  _ChooseWhenWidgetState createState() => _ChooseWhenWidgetState();
}

class _ChooseWhenWidgetState extends State<ChooseWhenWidget> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _startTime = widget.startTime;
    _endTime = widget.endTime;
  }

  Future<void> _pickTimeRange() async {
    TimeRange? result = await showTimeRangePicker(
      context: context,
      start: _startTime ?? TimeOfDay.now(),
      end:
          _endTime ?? TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1),
      interval: const Duration(minutes: 30),
      use24HourFormat: true,
      padding: 30,
      strokeWidth: 20,
      handlerRadius: 14,
      strokeColor: AppColors.primaryColor,
      handlerColor: AppColors.primaryColor,
      selectedColor: AppColors.primaryColor,
      backgroundColor: Colors.black.withOpacity(0.3),
      clockRotation: 180,
      ticks: 12,
      ticksColor: AppColors.surfaceColor,
      snap: true,
      labels: [
        "24/0",
        "3",
        "6",
        "9",
        "12",
        "15",
        "18",
        "21",
      ].asMap().entries.map((e) {
        return ClockLabel.fromIndex(idx: e.key, length: 8, text: e.value);
      }).toList(),
      labelOffset: -30,
      labelStyle: const TextStyle(
          fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w400),
      timeTextStyle: const TextStyle(
          color: AppColors.surfaceColor,
          fontSize: 24,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold),
      activeTimeTextStyle: const TextStyle(
          color: AppColors.surfaceColor,
          fontSize: 26,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold),
    );

    if (result != null) {
      setState(() {
        _startTime = result.startTime;
        _endTime = result.endTime;

        widget.startTime = _startTime!;
        widget.endTime = _endTime!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            left: 0,
            height: 80,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 18),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => {},
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
                      "Select Time",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        fontSize: 28
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 80,
            child: Container(
              color: const Color.fromARGB(255, 217, 217, 217),
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Row displaying FROM and TO times
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "FROM: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                                fontSize: 16),
                          ),
                          Text(
                            _startTime?.format(context) ?? "--:--",
                            style: const TextStyle(
                                fontSize: 16, color: AppColors.primaryColor),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.access_time,
                              color: AppColors.primaryColor),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "TO: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.primaryColor),
                          ),
                          Text(
                            _endTime?.format(context) ?? "--:--",
                            style: const TextStyle(
                                fontSize: 16, color: AppColors.primaryColor),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.access_time,
                              color: AppColors.primaryColor),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Change Time Range button
                ElevatedButton(
                  onPressed: _pickTimeRange,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Change Time Range",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
