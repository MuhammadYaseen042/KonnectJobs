import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konnectjob/cubit/accepted_jobs_cubit.dart';
import 'package:konnectjob/firbase_Services/apis.dart';
import 'package:konnectjob/riverpord_providers/providers.dart';
import 'package:paymob_pakistan/paymob_payment.dart';
import 'New User/user_number_screen.dart';
import 'screens/common/home.dart';

// Define the provider for LanguageController
final languageControllerProvider =
    ChangeNotifierProvider((ref) => LanguageController());
void main() async {
  PaymobPakistan.instance.initialize(
    apiKey:
        "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRRME5qWXdMQ0p1WVcxbElqb2lhVzVwZEdsaGJDSjkuT192TEg4ZzVfMlRibGx1UXJDS3Z6VTR1TG5nY2llc2hyQTB6Q3lPbUJ0cTY4VDlCbXAwNXZ1S3FTMUhKQ05KT2JhWjg3LVlTUjRFSWstd29VRU4zTlE=", // from dashboard Select Settings -> Account Info -> API Key
    jazzcashIntegrationId:
        154785, // From Dashboard select Developers -> Payment Integrations -> JazzCash Integration ID
    easypaisaIntegrationID:
        154785, // From Dashboard select Developers -> Payment Integrations -> EasyPaisa Integration ID
    integrationID:
        165960, // from dashboard Select Developers -> Payment Integrations -> Online Card ID
    iFrameID: 175518, // from paymob Select Developers -> iframes
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    print(currentUser.uid);
  }
  var currtUser = APIs.auth.currentUser;
  // If user ID is available, navigate to home screen; otherwise, navigate to user number screen
  Widget initialScreen = currtUser != null ? HomeScreen() : const UserNumber();
  runApp(
    ProviderScope(
      child: MyApp(initialScreen),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final Widget initialScreen;

  MyApp(this.initialScreen);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageController = ref.watch(languageControllerProvider);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AcceptedJobsCubit>(
          create: (BuildContext context) => AcceptedJobsCubit(),
        ),
      ],
      child: MaterialApp(
        locale: languageController.appLocale,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'), // English
          Locale('ur'), // Urdu
        ],
        debugShowCheckedModeBanner: false,
        home: APIs.auth.currentUser != null
            ? StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .where("userId", isEqualTo: APIs.user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        return const HomeScreen();
                      } else {
                        return const Center(child: Text("hello"));
                      }
                    default:
                  }
                  return const SizedBox(); // Default return statement
                },
              )
            : const UserNumber(),
      ),
    );
  }
}
