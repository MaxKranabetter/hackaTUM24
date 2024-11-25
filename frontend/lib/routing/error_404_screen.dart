import 'package:flutter/material.dart';
import 'package:frontend/common_widgets/solid_button.dart';
import 'package:frontend/routing/app_routing.dart';
import 'package:go_router/go_router.dart';

class Error404Screen extends StatelessWidget {
  const Error404Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error 404: Seite nicht gefunden.'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error 404 - Seite nicht gefunden.',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            SolidButton(
                text: "Zurück zur Homepage",
                onPressed: () {
                  context.goNamed(AppRouting.home);
                })
          ],
        ),
      ),
    );
  }
}
