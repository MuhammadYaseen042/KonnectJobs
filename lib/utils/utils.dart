import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

import '../widgets/widgets_components.dart';

class EventDialogues{

  static showEvent(BuildContext context, String title, String message , String filepath) {
    final AppLocalizations langLocal = AppLocalizations.of(context)!;

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 200),
      content: Container(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            sizedBoxH20,
            TextWidget(
              text: title,
              fontSize: 20,
              isBold: true,
            ),
            Flexible(child: Center(child: Lottie.asset(filepath.toString(), repeat: true))),
            sizedBoxH10,
            TextWidget(
              text: message,
              fontSize: 14,
              isBold: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Handle action when the button is pressed
            Navigator.pop(context); // Close the dialog
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Set background color to blue
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set text color to white
          ),
          child: TextWidget(
            text: 'Close',
            color: Colors.white, // Customize the button text color
          ),
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}