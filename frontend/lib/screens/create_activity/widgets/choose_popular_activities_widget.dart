import 'package:flutter/material.dart';
import 'package:frontend/theme/colors.dart';

class ChoosePopularActivitiesWidget extends StatelessWidget {
  TextEditingController whatController;
  PageController pageController;
  final List<String> activities;
  final int index;

  ChoosePopularActivitiesWidget(
      {super.key,
      required this.activities,
      required this.whatController,
      required this.index,
      required this.pageController});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 8.0,
        mainAxisExtent: 40.0,
      ),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            whatController.text = activities[index];
            pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },

          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
                child: Text(
              activities[index],
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            )),
          ), // Use the activity name as button text
        );
      },
    );
  }
}
