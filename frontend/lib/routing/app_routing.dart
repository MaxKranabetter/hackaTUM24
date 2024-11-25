import 'package:frontend/data/models/activity_model.dart';
import 'package:frontend/screens/activity_details/activity_details_screen.dart';
import 'package:frontend/screens/activity_selection/activity_selection_screen.dart';
import 'package:frontend/screens/create_activity/create_activity_screen.dart';
import 'package:frontend/screens/home_screen/home_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouting {
  // static names
  static const home = '/';
  static const createActivity = '/create-activity';
  static const selectActivity = '/select-activity';
  static const activityDetails = '/activity-details';
  static const error404 = '/error-404';
  // static const variable = "/location"

  static final router = GoRouter(
    initialLocation: home,
    routes: <GoRoute>[
      GoRoute(
          name: home,
          path: home,
          builder: (context, state) => const HomeScreen(),
          routes: [
            /*GoRoute(
              name: variable,
              path: variable
              builder: (context, state) => VariableScreen(state.params['location']))*/

            GoRoute(
                name: createActivity,
                path: createActivity,
                builder: (context, state) => const CreateActivityScreen()),
            GoRoute(
              name: selectActivity,
              path: selectActivity,
              builder: (context, state) {
                if (state.extra == null) {
                  return ActivitySelectionScreen();
                }

                try {
                  final activityModel = state.extra as ActivityModel;
                  return ActivitySelectionScreen(activityModel: activityModel);
                } on Exception catch (e) {
                  print(e);
                  return ActivitySelectionScreen();
                }
              },
            ),
            GoRoute(
                name: activityDetails,
                path: '$activityDetails/:id',
                builder: (context, state) {
                  // get id from pathParameters
                  final id = state.pathParameters['id'];
                  return ActivityDetailsScreen(activityID: id!);
                })
          ])
    ],
  );
}
