import 'package:flutter/material.dart';
import 'package:frontend/theme/colors.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key,
      required this.text,
      required this.name,
      required this.messageTimestamp,
      required this.imageURL,
      required this.isSender});
  final String text;
  final String name;
  final String messageTimestamp;
  final String imageURL;
  final bool isSender;

  Widget getContextRow() {
    List<Widget> items = [
      Text(
        messageTimestamp,
        style: const TextStyle(
            fontSize: 12, color: Color.fromARGB(255, 128, 128, 128)),
      ),
      const SizedBox(width: 6),
      Text(
        name,
        style: const TextStyle(
            fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600),
      ),
      const SizedBox(width: 6),
      CircleAvatar(
        radius: 10,
        backgroundImage: AssetImage(imageURL),
      ),
      const SizedBox(
        width: 6,
      ),
    ];
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: isSender ? items : items.reversed.toList(),
    );
  }

  Widget getMessage() {
    return Container(
      decoration: BoxDecoration(
        color: isSender
            ? AppColors.primaryColor.withOpacity(0.25)
            : const Color.fromARGB(255, 217, 217, 217),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //margin: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            getContextRow(),
            const SizedBox(
              height: 6,
            ),
            getMessage()
          ],
        ));
  }
}
