import 'package:flutter/material.dart';

/// Child used for the loading indicator on a primary elevated button.
class PrimaryElevatedButtonLoadingChild extends StatelessWidget {
  const PrimaryElevatedButtonLoadingChild({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.onPrimary,
        ));
  }
}
