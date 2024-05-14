import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../firbase_Services/firebase_auth_funtions.dart';
import '../widgets/widgets_components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserNumber extends StatefulWidget {
  const UserNumber({Key? key}) : super(key: key);

  @override
  State<UserNumber> createState() => _UserNumberClassState();
}

class _UserNumberClassState extends State<UserNumber> {
  final FirebaseAuthService _firebaseAuth = FirebaseAuthService(); // Instance of FirebaseAuthService
  bool isLoading = false;
  final TextEditingController _numCon = TextEditingController();
  String phoneNumber = "";
  String completePhoneNumber = "";
  Country selectedCountry = Country(
    phoneCode: "92",
    countryCode: "PK",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Pakistan",
    example: "Pakistan",
    displayName: "Pakistan",
    displayNameNoCountryCode: "PK",
    e164Key: " ",
  );


  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final AppLocalizations appLocalization = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xff0077B5),
        title: appBarWhiteTitle("Konnect Jobs"),
        centerTitle: true,
        actions: [
          const SizedBox(width: 5),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextWidget(text: appLocalization.getStarted, fontSize: 20, isBold: true),
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                TextWidget(text: 'السَّلاَمُ عَلَيْكُمْ ', fontSize: 30, isBold: true),
                TextWidget(text: appLocalization.lilBit, fontSize: 15),
                sizedBoxH20,
                BlueContainer(
                  color: const Color(0xFFE2F4FF),
                  height: mediaQuery.size.height * 0.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      sizedBoxH20,
                      TextWidget(text: appLocalization.enterNo, fontSize: 15),
                      sizedBoxH20,
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: PhoneTextField(
                          controller: _numCon,
                          onChanged: (value) {
                            phoneNumber = value;
                            setState(() {
                              completePhoneNumber = "+${selectedCountry.phoneCode}$phoneNumber";
                            });
                          },
                        ),
                      ),
                      ButtonWidget(
                        onPress: () async {
                          if (_numCon.text.length == 10) {

                            // Call the sendOtpOnNumber function from FirebaseAuthService
                            await _firebaseAuth.sendOtpOnNumber(context, completePhoneNumber);
                          } else {
                            print("Please enter phone number");
                          }
                        },
                        title: appLocalization.verifyButton,
                        isloading: isLoading,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

void otpShowModelBottomSheet(BuildContext context, String verificationId,String phoneNumber) {
  final AppLocalizations langLocal = AppLocalizations.of(context)!;
  bool isLoading=false;
  final TextEditingController otpCon = TextEditingController();

  showModalBottomSheet(
    backgroundColor: Colors.white,
    useSafeArea: true,
    isScrollControlled: true,
    context: context,
    builder: (context) => Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20,),
            TextWidget(text: langLocal.sendCode, fontSize: 14,),
            sizedBoxH10,
            Center(
              child: TextWidget(
                text: phoneNumber.toString(),
                fontSize: 14,
                isBold: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: otpCon,
                textAlign: TextAlign.center,
                maxLength: 6,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                keyboardType: TextInputType.number,
              ),
            ),
            sizedBoxH20,
            ButtonWidget(
              onPress: () async {
                isLoading=true;

               FirebaseAuthService firebaseAuth=FirebaseAuthService();
               firebaseAuth.checkOtp(context, verificationId, otpCon,phoneNumber);

               Future.delayed(const Duration(seconds: 3),(){
                 isLoading=false;

               });
              },
              title: langLocal.verifyButton,isloading: isLoading,
            ),
          ],
        ),
      ),
    ),
  );
}

