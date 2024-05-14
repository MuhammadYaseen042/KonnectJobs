import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:konnectjob/widgets/widgets_components.dart';
import '../../firbase_Services/modelClasses/user.dart';

///List
///
/// List for creating buttons,
List<String> buttonsList = [
  "About",
  "Work",
  "Message",
];

/// list for creating success rate, teams, number of reviews etc
List<String> profileList = ["17", "92%", "5", "243"];
List<String> profileList2 = [
  "Projects done",
  "Success rate",
  "Teams",
  "Reviews & Feedback"
];

/// this class can be used for both workers and employers
/// this is a common class to showing all the details of workers or employers like reviews
/// feedback etc.
///
class ViewProfile extends StatefulWidget {
  UserModelClass userModelClass;
  WorkerSkillsDataModelClass workerModelClass;

  ViewProfile(
      {Key? key, required this.userModelClass, required this.workerModelClass})
      : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final PageController controller = PageController(initialPage: 0);
  int currentIndex = 0;

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    List<Widget> bottomWidgetList = [
      bottomAboutSection(userId: widget.userModelClass.userId),
      bottomWorkSection(),
      bottomAboutSection(),
    ];
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: const Color(0xFFE2F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xff0077B5),
        title: appBarWhiteTitle("My Profile"),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: currentIndex == 0
                  ? aboutTopSection(height, width, widget.userModelClass!)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.workerModelClass?.workCategory ?? '',
                                style: TextStyle(
                                  fontSize: 30,
                                  letterSpacing: 0.7,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                              sizedBoxH10,
                              labelText("Type"),
                              boldText(widget.userModelClass?.userType ?? ''),
                              sizedBoxH10,
                              labelText("Joined"),
                              boldText(
                                  widget.workerModelClass?.createdAt ?? ''),
                              sizedBoxH10,
                              labelText("Experience"),
                              boldText(
                                  widget.workerModelClass?.workExperience ??
                                      ''),
                            ],
                          ),
                        ),
                        imageContainer(height, width,
                            widget.userModelClass?.imageUrl ?? ''),
                      ],
                    ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              padding: const EdgeInsets.all(10.0),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: buttonsList.length,
                itemBuilder: (context, index) => CupertinoButton(
                  color: currentIndex == index
                      ? const Color(0xff0077B5)
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  onPressed: () {
                    setState(() {
                      currentIndex = index;
                      //Update currentIndex here
                      controller.animateToPage(currentIndex,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutSine);
                    });
                  },
                  child: TextWidget(
                    text: buttonsList[index],
                    color: currentIndex == index ? Colors.white : Colors.black,
                    isBold: currentIndex == index ? true : false,
                  ),
                ),
              ),
            ),
            sizedBoxH10,
            Expanded(
              child: PageView.builder(
                itemCount: bottomWidgetList.length,
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => bottomWidgetList[index],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget aboutTopSection(
  double height,
  double width,
  UserModelClass user,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      imageContainer(height, width, user.imageUrl.toString()),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name ?? '',
              style: TextStyle(
                fontSize: 30,
                letterSpacing: 0.7,
                fontWeight: FontWeight.bold,
                color: Colors.black45,
              ),
            ),
            sizedBoxH10,
            labelText("Date of Birth"),
            boldText("December,10, 2023"),
            sizedBoxH10,
            labelText("Address"),
            boldText(user.country ?? ''),
          ],
        ),
      ),
    ],
  );
}

Container imageContainer(double height, double width, String imageUrl) {
  return Container(
    height: height * (0.2 + 0.03),
    width: width * 0.4,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      image: DecorationImage(
        fit: BoxFit.cover,
        image: NetworkImage(
          imageUrl,
        ),
      ),
    ),
  );
}

/// bold text
Text boldText(String text, {double fontSize = 16}) {
  return Text(
    softWrap: true,
    text,
    style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
  );
}

Text labelText(String text) {
  return Text(
    text,
    style: const TextStyle(fontSize: 15),
  );
}

Widget bottomWorkSection() {
  return GridView.builder(
    padding: const EdgeInsets.symmetric(vertical: 10),
    physics: const BouncingScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 20.0, crossAxisSpacing: 20.0),
    itemCount: 4,
    itemBuilder: (_, index) => Container(
        padding: const EdgeInsets.all(10.0),
        height: 220,
        width: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              profileList[index],
              softWrap: true,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            sizedBoxH20,
            Text(
              profileList2[index],
              softWrap: true,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          ],
        )),
  );
}

///About Section start
///
Widget bottomAboutSection({String? userId}) {
  return Center(
      // child: StreamBuilder(
      //     stream: FirebaseFirestore.instance
      //         .collection('Workers')
      //         .doc(userId)
      //         .collection('reviews')
      //         .snapshots(),
      //     builder: (context, snapshot) {
      //       final worker = snapshot.data!.docs;
      //       return ListView.builder(
      //           itemCount: 10,
      //           itemBuilder: (context, index) {
      //             return ListTile(
      //               title: worker[index]['description'],
      //             );
      //           });
      //     }),
      );
}
