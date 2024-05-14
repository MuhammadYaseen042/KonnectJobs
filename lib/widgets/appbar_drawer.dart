import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konnectjob/New%20User/user_number_screen.dart';
import 'package:konnectjob/Worker/my%20jobs.dart';
import 'package:konnectjob/currentUser/user_profile.dart';
import 'package:konnectjob/firbase_Services/apis.dart';
import 'package:konnectjob/firbase_Services/firebase_auth_funtions.dart';
import 'package:konnectjob/firbase_Services/modelClasses/user.dart';
import 'package:konnectjob/payment/payment_screen.dart';
import 'package:konnectjob/screens/common/drawer_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:konnectjob/widgets/widgets_components.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/common/governmentScheme.dart';
import '../screens/common/youtube_screen.dart';


/// 1) Drawer

class DrawerWidget extends ConsumerStatefulWidget {

  const DrawerWidget({Key?key,


  }):super(key: key);

  @override
  DrawerWidgetState createState() => DrawerWidgetState();
}

class DrawerWidgetState extends ConsumerState<DrawerWidget> {

UserModelClass? userModelClass;

 @override
  void initState() {
    // TODO: implement initState
  }
  @override
  Widget build(BuildContext context) {
    double radius = MediaQuery.of(context).size.aspectRatio;

    final AppLocalizations langLocal = AppLocalizations.of(context)!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Users").where("userId", isEqualTo: APIs.user.uid).snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            final userDocs = snapshot.data?.docs;

            if (userDocs != null && userDocs.isNotEmpty) {
              final userData = userDocs[0].data();
              userModelClass = UserModelClass.fromJSON(userData);

              return Drawer(
                backgroundColor: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CachedNetworkImage(
                            imageUrl: userModelClass?.imageUrl ??'',
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blue, // You can customize the border color
                                  width: 1, // You can customize the border width
                                ),
                              ),
                              child: CircleAvatar(
                                radius: radius*100, // You can adjust the radius of the circle avatar
                                backgroundImage: imageProvider, // Set the image provider directly
                              ),
                            ),
                            placeholder: (context, url) => CircularProgressIndicator(), // Show loading indicator
                            errorWidget: (context, url, error) => const Icon(Icons.error), // Show error icon if image fails to load
                          ),
                          Text(userModelClass?.name ??'',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.08,
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {

                          Navigator.push(context,
                              MaterialPageRoute(builder: (_)=>const GovernmentSchemes()));

                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(width: 1.5, color: Colors.teal),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage("assets/images/pak.jpg"))),

                            ),
                            Text(langLocal.govSchemes,
                              style: TextStyle(color: Colors.teal, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                    ListTileWidget(
                        color: Colors.lightBlue,
                        text: langLocal.myprof,
                        icon: Icons.account_box_rounded,
                        onTap:(){
                          Navigate(context,  ManageProfile(userModelClass: userModelClass!,));
                        }
                    ),
                    ListTileWidget(
                        color: Colors.purple,
                        text: langLocal.learnNewSkill,
                        icon:  Icons.payments_rounded,
                        onTap: (){
                          /// Youtube screen
                          Navigate(context, YoutubePlayerDemoApp());

                        }
                    ),
                    ListTileWidget(
                        color:  Colors.lightBlue,
                        text:  langLocal.myjobs,
                        icon:  Icons.manage_history,
                        onTap: (){
                          Navigate(context,MyJobsScreen(userModelClass: userModelClass!,));
                        }
                    ),
                    ListTileWidget(
                        color: Colors.teal,
                        text:  langLocal.payment,
                        icon:  Icons.payments_rounded,
                        onTap: (){
                          Navigate(context,  PaymentScreen(userModelClass: userModelClass!));
                        }
                    ),
                    const Divider(
                      color: Color(0xffE5E5E5),
                      thickness: 0.5,
                    ),
                    ListTileWidget(
                        color:Colors.lightBlue,
                        text:langLocal.changeLang,
                        icon:Icons.language,
                        onTap: (){
                          Navigate(context, LanguageScreen());
                        },
                        trailingWidget: Icon(Icons.arrow_forward),
                        isBold: true,
                        fontSize: 15),
                    const Divider(
                      color: Color(0xffE5E5E5),
                      thickness: 0.5,
                    ),
                    ListTileWidget(
                        color: Colors.purple,
                        text: langLocal.accountSet,
                        icon: Icons.settings,
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>const AccountSetting()));
                        }
                    ),
                    ListTileWidget(color: Colors.blue,
                      text: langLocal.helpFeed,
                      icon: Icons.help_center_rounded,
                      onTap: () async{
                        String url = "https://wa.me/+923135586233";

                        // Check if WhatsApp is installed on the device
                        if (await canLaunchUrl(Uri.parse(url))) {
                          // Open the WhatsApp chat
                          await launchUrl(Uri.parse(url));
                        } else {
                          // If WhatsApp is not installed, display an error message
                          throw 'Could not launch $url';
                        }
                      },

                    ),
                    ListTileWidget(
                        color:  Colors.deepOrangeAccent,
                        text:  langLocal.logout,
                        icon: Icons.exit_to_app,
                        onTap: (){

                          // Show the custom alert dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialogWidget(
                                message: 'Are you sure you want to Sign Out?',
                                onCancelName: "Cancel",
                                onCancel: () {
                                  // Handle cancel action
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                onDeleteName: "SignOut",
                                onDelete: (){
                                  FirebaseAuthService _auth=FirebaseAuthService();
                                  _auth.signOut();
                                  Navigator.of(context).pop();
                                  Navigator.push(context, MaterialPageRoute(builder:  (_) => const UserNumber()));
                                  // Close the dialog
                                },
                              );
                            },
                          );

                        }

                    ),
                  ],
                ),
              );
            }else {
              return Center(child: TextWidget(text: "No job is found!", isBold: true));
            }
        }
      },
    );


  }
}

class ListTileWidget extends StatelessWidget {
  final Color color;
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final bool isBold;
  final double? fontSize;
  final Widget? trailingWidget; // Changed from IconData to Widget

  const ListTileWidget({
    Key? key,
    required this.color,
    required this.text,
    required this.icon,
    required this.onTap,
    this.isBold = false,
    this.fontSize,
    this.trailingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: const Color(0xFFE8EFFD),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : null,
        ),
      ),
      trailing: trailingWidget != null ? trailingWidget : null, // Use trailingWidget if provided
    );
  }
}

Navigate(BuildContext context, Widget widget) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (builder) => widget));
}
