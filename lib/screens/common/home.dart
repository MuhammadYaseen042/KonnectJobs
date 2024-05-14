import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konnectjob/firbase_Services/apis.dart';
import 'package:konnectjob/firbase_Services/modelClasses/user.dart';
import 'package:konnectjob/screens/common/chat.dart';
import 'package:konnectjob/screens/common/notification.dart';
import 'package:konnectjob/screens/workers/jobs_tab_bar.dart';
import 'package:konnectjob/widgets/widgets_components.dart';
import '../../widgets/appbar_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../employer/create_job_screen.dart';
import '../employer/view_workers.dart';
import 'map.dart';


class HomeScreen extends ConsumerStatefulWidget  {
  const HomeScreen({super.key,
  });
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  String appBarTitle = "Find Jobs";
  UserModelClass? userModelClass;
  WorkerSkillsDataModelClass? workingDetails;

  int bIndex = 0;
  String userType="Client";

 bool isLoading=true;



  List<Widget> workerVewList = [
    const WorkerTabBar(),
    GoogleMapScreen(),
    NotificationsScreen(),

  ];
  List<Widget> clientViewList = [
    const EmployerViewScreen(),
    const CreateJobScreen(),
    GoogleMapScreen(),
    NotificationsScreen(),

  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //var mediaQuery = MediaQuery.of(context);
    final AppLocalizations langLocal = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer:  DrawerWidget(),//userModelClass: userModelClass,),
      appBar: AppBar(
        title: appBarWhiteTitle(appBarTitle),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color(0xff0077B5),
        elevation: 0.0,
        actions: [
          CupertinoButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ChatScreen()));
            },
            child: const Stack(
              children: [
                //  RiveAnimationIcons(list: iconList,index: 0,),
                Icon(Icons.chat,color: Colors.white,),

              ],
            ),
          ),
        ],
      ),

      ///body widget
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").where("userId", isEqualTo: APIs.user.uid).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              if(snapshot.hasData){
                final userDocs = snapshot.data?.docs;
                final userData = userDocs![0].data();
                userModelClass = UserModelClass.fromJSON(userData);
                if(userModelClass?.userType=="Client"){
                  return clientViewList[bIndex];
                } else {
                  return workerVewList[bIndex];
                }
              } else {
                return Center(child: TextWidget(text: "No User is found!", isBold: true));
              }
            default:
              return SizedBox(); // Default return statement
          }
        },
      ),

      ///bottom NavigationBar
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            if(userModelClass?.userType=="Worker"){
              setState(() {
                bIndex=index;
              });
              if (bIndex == 0) {
                appBarTitle = userModelClass!.userType.toString();
              } else if (bIndex == 1) {
                appBarTitle = "Google Map";
              } else if (bIndex == 2) {
                appBarTitle = "Google Map";
              } else if (bIndex == 3) {
                appBarTitle = "Notifications";
              }
            }else{
              setState(() {
                bIndex=index;
              });
              if (bIndex == 0) {
                appBarTitle = "Find Worker";
              } else if (bIndex == 1) {
                appBarTitle = "Google Map";
              } else if (bIndex == 2) {
                appBarTitle = "Notifications";
              }

            }

          },
          type: BottomNavigationBarType.fixed,
          selectedIconTheme: const IconThemeData(size: 30),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white60,
          currentIndex: bIndex,
          backgroundColor: const Color(0xff0077B5),
          items:   [
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              activeIcon: Icon(Icons.person),
              label: langLocal.worker),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: langLocal.post),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined),
              activeIcon: Icon(Icons.location_on),
              label: langLocal.map),
          BottomNavigationBarItem(
              icon: Icon(Icons.notification_add),
              activeIcon: Icon(Icons.notifications),
              label: langLocal.notifications),
          ]
      ),
    );
  }

/*
:  [
            BottomNavigationBarItem(
                icon: Icon(Icons.work),
                activeIcon: Icon(Icons.work_history),
                label: langLocal.jobs),
            BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined),
                activeIcon: Icon(Icons.location_on),
                label: langLocal.map),
            BottomNavigationBarItem(
                icon: Icon(Icons.notification_add),
                activeIcon: Icon(Icons.notifications),
                label: langLocal.notifications),
          ]
*/

}
