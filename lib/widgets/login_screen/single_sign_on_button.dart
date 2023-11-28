import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Button used for single sign on.
/// Logo is displayed to the left of the 'Sign In' text.
class SingleSignOnButton extends StatelessWidget {
  const SingleSignOnButton({
    super.key,
    required this.providerLogoAsset,
    required this.logoSemanticLabel,
    required this.onPressed,
  });
  final String providerLogoAsset;
  final String logoSemanticLabel;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        style: AppThemes.entrySecondaryButtonTheme,
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              providerLogoAsset,
              semanticsLabel: logoSemanticLabel,
              height: 20,
            ),
            Text(AppLocalizations.of(context)!.signIn),
          ],
        ),
      ),
    );
  }
}
