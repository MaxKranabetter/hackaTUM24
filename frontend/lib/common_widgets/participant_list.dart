import 'package:flutter/material.dart';

class ActivityParticipant {
  final String name, gender, pfpUrl;
  final int age;

  const ActivityParticipant({
    required this.name,
    required this.gender,
    required this.pfpUrl,
    required this.age,
  });
}

class ParticipantRowItem extends StatelessWidget {
  final ActivityParticipant participant;

  const ParticipantRowItem({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 11, 0, 11),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(participant.pfpUrl),
          ),
          const SizedBox(width: 14.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                participant.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              Text(
                '${participant.gender} | ${participant.age}',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.black.withOpacity(0.4)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CollapsableParticipantList extends StatefulWidget {
  final List participants;
  final int denominator;

  const CollapsableParticipantList({
    super.key,
    required this.participants,
    required this.denominator,
  });

  @override
  State<CollapsableParticipantList> createState() =>
      _CollapsableParticipantListState();
}

class _CollapsableParticipantListState
    extends State<CollapsableParticipantList> {
  bool _expanded = false;
  List<ActivityParticipant> participants = [];

  @override
  void initState() {
    for (var participant in widget.participants) {
      participants.add(ActivityParticipant(
        name: participant['name'],
        gender: participant['gender'],
        pfpUrl: "user.png",
        age: participant['age'],
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                'People joined (${participants.length}/${widget.denominator})',
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
            children: participants
                .map((participant) =>
                    ParticipantRowItem(participant: participant))
                .toList(),
          ),
      ],
    );
  }
}
