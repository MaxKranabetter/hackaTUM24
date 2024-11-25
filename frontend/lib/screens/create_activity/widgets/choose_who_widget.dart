import 'package:flutter/material.dart';

class ChooseWhoWidget extends StatefulWidget {
  TextEditingController minParticipantsController;
  TextEditingController maxParticipantsController;
  final GlobalKey<FormState> formKey;

  ChooseWhoWidget(
      {super.key,
      required this.minParticipantsController,
      required this.maxParticipantsController,
      required this.formKey});

  @override
  State<ChooseWhoWidget> createState() => _ChooseWhoWidgetState();
}

class _ChooseWhoWidgetState extends State<ChooseWhoWidget> {
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
                      "Select Group Size",
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
            padding: const EdgeInsets.all(22.0),
            child: Form(
              key: widget.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Minimum participants input
                  TextFormField(
                    controller: widget.minParticipantsController,
                    decoration: InputDecoration(
                      labelText: "Minimum Group Size",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a minimum number of participants.";
                      }
                      final min = int.tryParse(value);
                      if (min == null || min <= 0) {
                        return "Minimum must be a positive number.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Maximum participants input
                  TextFormField(
                    controller: widget.maxParticipantsController,
                    decoration: InputDecoration(
                      labelText: "Maximum Group Size (optional)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        value = "100";
                        widget.maxParticipantsController.text = value;
                      }
                      final max = int.tryParse(value);
                      final min =
                          int.tryParse(widget.minParticipantsController.text) ??
                              0;
                      if (max == null || max <= 0) {
                        return "Maximum must be a positive number.";
                      }
                      if (max < min) {
                        return "Maximum cannot be less than Minimum.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
