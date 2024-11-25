import 'package:flutter/material.dart';
import 'package:frontend/theme/colors.dart';

class JoinActivityTile extends StatelessWidget {
  final String title;
  final String location;
  final String startTime;
  final String endTime;
  final List<String> userProfilePicturePaths;
  final int minParticipants;
  final VoidCallback onJoin;

  const JoinActivityTile({
    Key? key,
    required this.title,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.userProfilePicturePaths,
    required this.minParticipants,
    required this.onJoin,
  }) : super(key: key);

  final double _avatarSize = 22.0;
  final double _avatarImageSize = 20.0;

  @override
  Widget build(BuildContext context) {
    TextStyle subtitleStyle = const TextStyle(
      fontSize: 12,
    );
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
            color: Color.fromARGB(255, 217, 217, 217), width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_pin,
                        size: 16.0,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        location.length > 30
                            ? location.substring(0, 30) + '...'
                            : location,
                        style: subtitleStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
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
                  const SizedBox(height: 8.0),
                  Container(
                    height: _avatarSize,
                    child: Row(
                      children: [
                        SizedBox(
                          width: (userProfilePicturePaths.length + 0.5) *
                              _avatarImageSize,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: List.generate(
                                userProfilePicturePaths.length, (index) {
                              return Positioned(
                                width: _avatarSize,
                                left: (userProfilePicturePaths.length -
                                        index -
                                        1) *
                                    _avatarImageSize * 0.8,
                                child: CircleAvatar(
                                  radius: _avatarSize / 2,
                                  backgroundColor: AppColors.surfaceColor,
                                  child: CircleAvatar(
                                    radius: _avatarImageSize / 2,
                                    backgroundImage: AssetImage(
                                        userProfilePicturePaths[
                                            userProfilePicturePaths.length -
                                                index -
                                                1]),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        Text(
                          '${userProfilePicturePaths.length}/$minParticipants',
                          style: subtitleStyle,
                        ),
                      ],
                    ),
                  )],
              ),
            ),
            GestureDetector(
              onTap: onJoin,
              child: Container(
                height: 27,
                width: 90,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Center(
                  child: Text(
                    'Join',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                        fontSize: 12),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
