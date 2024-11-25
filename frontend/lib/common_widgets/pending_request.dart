import 'package:flutter/material.dart';
import 'package:frontend/theme/colors.dart';

class PendingActivityRequest extends StatelessWidget {
  final String title, location, startTime, endTime;
  final int minParticipants, maxParticipants;
  final VoidCallback onOpen;

  final bool includeOpenButton;

  const PendingActivityRequest({
    super.key,
    required this.title,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.minParticipants,
    required this.maxParticipants,
    required this.onOpen,
    this.includeOpenButton = true,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle subtitleStyle = const TextStyle(
      fontSize: 12,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 2.0),
        Row(
          children: [
            const Icon(
              Icons.location_pin,
              size: 16.0,
            ),
            const SizedBox(width: 4.0),
            Text(
              location.length > 30
                  ? '${location.substring(0, 30)}...'
                  : location,
              overflow: TextOverflow.ellipsis,
              style: subtitleStyle,
            ),
          ],
        ),
        const SizedBox(height: 6.0),
        Row(
          children: [
            const Icon(
              Icons.access_time,
              size: 16.0,
            ),
            const SizedBox(width: 4.0),
            Text('$startTime - $endTime', style: subtitleStyle),
          ],
        ),
        const SizedBox(height: 12.0),
        Text(
          'Min: $minParticipants Max: $maxParticipants',
          style: subtitleStyle,
        ),
        const SizedBox(height: 12.0),
        if (includeOpenButton)
          GestureDetector(
            onTap: onOpen,
            child: Container(
              height: 27,
              width: 128,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.25),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(
                child: Text(
                  'Let others join',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      fontSize: 12),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class CollapsablePendingActivityRequest extends StatefulWidget {
  final String title, location, startTime, endTime;
  final int minParticipants, maxParticipants;
  final VoidCallback onOpen;

  final bool includeOpenButton;

  const CollapsablePendingActivityRequest({
    super.key,
    required this.title,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.minParticipants,
    required this.maxParticipants,
    required this.onOpen,
    this.includeOpenButton = true,
  });

  @override
  _CollapsablePendingActivityRequestState createState() =>
      _CollapsablePendingActivityRequestState();
}

class _CollapsablePendingActivityRequestState
    extends State<CollapsablePendingActivityRequest> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    TextStyle subtitleStyle =
        const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              IconButton(
                icon: Icon(_expanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ],
          ),
        ),
        if (_expanded)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2.0),
              Row(
                children: [
                  const Icon(
                    Icons.location_pin,
                    size: 18.0,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                      widget.location.length > 30
                          ? '${widget.location.substring(0, 30)}...'
                          : widget.location,
                      overflow: TextOverflow.ellipsis,
                      style: subtitleStyle)
                ],
              ),
              const SizedBox(height: 6.0),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 18.0,
                  ),
                  const SizedBox(width: 4.0),
                  Text('${widget.startTime} - ${widget.endTime}',
                      style: subtitleStyle),
                ],
              ),
              const SizedBox(height: 12.0),
              Text(
                'Min: ${widget.minParticipants} Max: ${widget.maxParticipants}',
                style: subtitleStyle,
              ),
              const SizedBox(height: 12.0),
              if (widget.includeOpenButton)
                GestureDetector(
                  onTap: widget.onOpen,
                  child: Container(
                    height: 27,
                    width: 128,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Center(
                      child: Text(
                        'Let others join',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                            fontSize: 12),
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
