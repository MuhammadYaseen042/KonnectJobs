import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konnectjob/firbase_Services/firebase_crud_funtions.dart';
import 'package:konnectjob/widgets/appbar_drawer.dart';
import 'package:provider/provider.dart';
import '../../New User/user_number_screen.dart';
import '../../firbase_Services/firebase_auth_funtions.dart';
import '../../main.dart';
import '../../widgets/widgets_components.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {

  String? userId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }

  getUserId() async{
    FirebaseAuthService firebaseAuth = FirebaseAuthService();
    String? userID = await firebaseAuth.getUserIdIfAuthenticated(); // Get user ID if authenticated
    print("User ID is=======>>>>>>>>"+userID.toString()+"=======<<<<<<<");

    setState(() {
      userId=userID;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: appBarWhiteTitle(
          "Account Setting",
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color(0xff0077B5),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          sizedBoxH20,
       ListTileWidget(
           color: Colors.red,
           text: "Delete Account",
           icon: Icons.delete,
           onTap: (){
             showDialog(
               context: context,
               builder: (BuildContext context) {
                 return AlertDialogWidget(
                   message: 'Are you sure you want to delete the account?',
                   onCancelName: "Cancel",
                   onCancel: () {
                     // Handle cancel action
                     Navigator.of(context).pop(); // Close the dialog
                   },
                   onDeleteName: "Delete",
                   onDelete: () async{
                     print(userId);
                     FirebaseUserServices db=FirebaseUserServices();
                     if(userId!=null){
                       await db.deleteUser(userId.toString());
                       Navigator.push(context, MaterialPageRoute(builder:  (_) => const UserNumber()));
                     }else{
                       print("obb worng");
                       Navigator.of(context).pop();
                     }
                     // Close the dialog
                   },
                 );
               },
             );

           },
         trailingWidget: const Icon(Icons.arrow_forward),
         isBold: true,
           )
       ],
      ),
    );
  }
}


class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  bool isUrdu = false;
  bool isEnglish = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: appBarWhiteTitle("Change Language"),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color(0xff0077B5),
        elevation: 0.0,

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            ListTileWidget(
              color: Colors.teal,
              text: "Change into Urdu",
              icon: Icons.language,
              onTap: () {
                setState(() {
                  isUrdu = true;
                  isEnglish = false;
                });
                ref.read(languageControllerProvider).changeLang(Locale('ur'));
              },
              trailingWidget: Switch(
                value: isUrdu,
                inactiveTrackColor: Colors.white,
                inactiveThumbColor: Colors.blueAccent,
                activeColor: Colors.green,
                onChanged: (bool value) {
                  setState(() {
                    isUrdu = value;
                    isEnglish = !value;
                  });
                  ref.read(languageControllerProvider).changeLang(Locale('ur'));
                },
              ),
            ),
            ListTileWidget(
              color: Colors.deepOrange,
              text: "Change into English",
              icon: Icons.language,
              onTap: () {
                setState(() {
                  isUrdu = false;
                  isEnglish = true;
                });
                ref.read(languageControllerProvider).changeLang(Locale('en'));
              },
              trailingWidget: Switch(
                value: isEnglish,
                inactiveTrackColor:Colors.white,
                inactiveThumbColor: Colors.blueAccent,
                activeColor: Colors.green,
                onChanged: (bool value) {
                  setState(() {
                    isUrdu = !value;
                    isEnglish = value;
                  });
                  ref.read(languageControllerProvider).changeLang(Locale('en'));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}