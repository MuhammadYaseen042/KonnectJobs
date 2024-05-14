import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:konnectjob/firbase_Services/apis.dart';
import 'package:konnectjob/firbase_Services/firebase_auth_funtions.dart';
import 'package:konnectjob/firbase_Services/modelClasses/user.dart';
import '../../firbase_Services/firebase_crud_funtions.dart';
import '../../firbase_Services/modelClasses/job.dart';
import '../../widgets/widgets_components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'job_details_screen.dart';

class WorkerTabBar extends StatefulWidget {
  //final UserModelClass currentUser;
  const WorkerTabBar({
    Key?key,
    // required this.currentUser,
  }):super(key: key);

  @override
  State<WorkerTabBar> createState() => _WorkerTabBarState();
}
class _WorkerTabBarState extends State<WorkerTabBar> {
  final TextEditingController _searchCon = TextEditingController();

  List<JobModelClass> jobModelClassList=[];
  List<SavedJobsModelClass> savedJobs=[];


  List<String> jobId=[];
  /// for searching
  List<JobModelClass> searchJobList=[];

  bool isSearching=false;

  deleteSavedJobbyId(String id) async{
    FirebaseSavedJobService db=FirebaseSavedJobService();
    db.deleteSavedJob(id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final AppLocalizations langLocal = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: TextFieldWidget(
            controller: _searchCon,
            radius: 10.0,
            leadingIcon: Icons.search,
            hintText: langLocal.search,
            trailingIcon: Icons.clear,
            onChanged: (val){
              if(_searchCon.text.length>0){
                setState(() {
                  isSearching=true;
                });
              }else{
                setState(() {
                  isSearching=false;
                });
              }
              searchJobList.clear();

              for(var i in jobModelClassList){
                if(i.title!.toLowerCase().contains(val.toLowerCase())){
                  searchJobList.add(i);
                }
                setState(() {
                  searchJobList;
                });
              }

            },
          ),
          bottom:  TabBar(
              indicatorColor: Colors.blue,
              dividerHeight: 0.0,
              isScrollable: true,
              //controller: _tabController,
              // onTap: (index) {},
              unselectedLabelColor: Colors.black38,
              labelColor: Colors.black,
              dividerColor: const Color(0xff0077B5),
              tabs: [
                Tab(
                  text: langLocal.bestMatches,
                ),
                Tab(
                  text: langLocal.mostRecent,
                ),
                Tab(
                  text: langLocal.savedJobs,
                )
              ]),
        ),
        body: TabBarView(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("Jobs").snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final jobDocsIds = snapshot.data?.docs;

                    /// Store jobIds in a list
                    List<String> jobIdsList = jobDocsIds?.map((e) => e.id).toList() ?? [];

                    /// store job informations

                    jobModelClassList = jobDocsIds
                        ?.map((e) => JobModelClass.fromJSON(e.data()))
                        .toList() ?? [];
                    if(jobModelClassList.isNotEmpty){
                      return ListView.builder(
                        itemCount: isSearching? searchJobList.length: jobModelClassList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          print("=============>>>>"+jobIdsList.length.toString());
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance.collection("Users")
                                .where("userId", isEqualTo: isSearching? searchJobList[index].creatorId: jobModelClassList[index].creatorId)
                                .snapshots(),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (userSnapshot.hasError) {
                                return Center(child: Text('Error: ${userSnapshot.error}'));
                              } else if (userSnapshot.data!.docs.isEmpty) {
                                return Center(child: Text('No user found'));
                              } else {
                                var userModel = UserModelClass.fromJSON(userSnapshot.data!.docs.first.data());
                                return JobContainer(
                                  jobId: jobIdsList[index],
                                  userModelClass: userModel,
                                  jobModelClass: isSearching? searchJobList[index]:jobModelClassList[index],
                                );
                              }
                            },
                          );
                        },
                      );
                    } else {
                      return Center(child: TextWidget(text: "No job is found!", isBold: true));
                    }
                }
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("Jobs").snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                  case ConnectionState.active:
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.data?.docs.isEmpty ?? true) {
                      return Center(child: Text('No recent jobs found!'));
                    } else {

                      final jobDocsIds = snapshot.data?.docs;

                      /// Store jobIds in a list
                      List<String> jobIdsList = jobDocsIds?.map((e) => e.id).toList() ?? [];

                      var jobDataList = snapshot.data!.docs.map((e) => JobModelClass.fromJSON(e.data())).toList();

                      DateTime currentTime = DateTime.now();

                      ///Change time to see most Recent Jobs
                      DateTime oneHourAgo = currentTime.subtract(const Duration(hours: 3));
                      List<JobModelClass> recentJobs = jobDataList.where((job) {
                        DateTime jobTime = DateTime.parse(job.createdTime!);
                        return jobTime.isAfter(oneHourAgo);
                      }).toList();
                      return ListView.builder(
                        itemCount: recentJobs.length,
                        itemBuilder: (context, index) {
                          var job = recentJobs[index];
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance.collection("Users")
                                .where("userId", isEqualTo: job.creatorId)
                                .snapshots(),
                            builder: (context, userSnapshot) {
                              switch (userSnapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Center(child: CircularProgressIndicator());
                                case ConnectionState.done:
                                case ConnectionState.active:
                                  if (userSnapshot.hasError) {
                                    return Center(child: Text('Error: ${userSnapshot.error}'));
                                  } else if (userSnapshot.data?.docs.isEmpty ?? true) {
                                    return Center(child: Text('No user found'));
                                  } else {
                                    var userModel = UserModelClass.fromJSON(userSnapshot.data!.docs.first.data());
                                    return JobContainer(
                                      jobId: jobIdsList[index],
                                      userModelClass: userModel,
                                      jobModelClass: job,
                                    );
                                  }
                                default:
                                  return SizedBox.shrink();
                              }
                            },
                          );
                        },
                      );
                    }
                  default:
                    return SizedBox.shrink();
                }
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("SavedJobs").snapshots(),
              builder: (context, jobsnapshot) {
                switch (jobsnapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                  case ConnectionState.active:
                    if (jobsnapshot.hasError) {
                      return Center(child: Text('Error: ${jobsnapshot.error}'));
                    } else if (jobsnapshot.data?.docs.isEmpty ?? true) {
                      return Center(child: Text('No recent jobs found!'));
                    } else {
                      savedJobs = jobsnapshot.data!.docs.map((e) => SavedJobsModelClass.fromJSON(e.data())).toList();

                      final jobDocsIds = jobsnapshot.data?.docs;

                      /// Store jobIds in a list
                      List<String> jobIdsList = jobDocsIds?.map((e) => e.id).toList() ?? [];

                      return ListView.builder(
                        itemCount: savedJobs.length,
                        itemBuilder: (context, index) {
                          var job = savedJobs[index];
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance.collection("Users")
                                .where("userId", isEqualTo: job.userModelClass?.userId)
                                .snapshots(),
                            builder: (context, userSnapshot) {
                              switch (userSnapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Center(child: CircularProgressIndicator());
                                case ConnectionState.done:
                                case ConnectionState.active:
                                  if (userSnapshot.hasError) {
                                    return Center(child: Text('Error: ${userSnapshot.error}'));
                                  } else if (userSnapshot.data?.docs.isEmpty ?? true) {
                                    return Center(child: Text('No user found'));
                                  } else {
                                    var userModel = UserModelClass.fromJSON(userSnapshot.data!.docs.first.data());
                                    return JobContainer(
                                      jobId: jobIdsList[index],
                                      userModelClass: userModel,
                                      jobModelClass: job.jobModelClass!,
                                      iconData: Icons.delete,
                                      onIconPressed: (){
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialogWidget(
                                              message: 'Are you sure you want to remove this job?',
                                              onCancelName: "No",
                                              onCancel: () {
                                                // Handle cancel action
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                              onDeleteName: "Yes",
                                              onDelete: (){
                                                deleteSavedJobbyId(jobIdsList[index]);
                                                Navigator.of(context).pop();
                                                // Close the dialog
                                              },
                                            );
                                          },
                                        );

                                      },
                                    );
                                  }
                                default:
                                  return SizedBox.shrink();
                              }
                            },
                          );
                        },
                      );
                    }
                  default:
                    return SizedBox.shrink();
                }
              },
            ),


          ],
        ),

      ),
    );
  }
}

///

///JOB Container widget
class JobContainer extends StatefulWidget {
  // int qty;
  IconData iconData;
  String jobId;
  UserModelClass userModelClass;
  JobModelClass jobModelClass;
  VoidCallback? onIconPressed;
  // New parameter for user name

  JobContainer({
    Key? key,
    this.onIconPressed,
    required this.jobId,
    this.iconData=Icons.favorite_outline_sharp,
    required this.userModelClass,
    required this.jobModelClass,
  }) : super(key: key);
  @override
  State<JobContainer> createState() => _JobContainerState();
}

class _JobContainerState extends State<JobContainer> {
  bool isFav = false;


  saveJobs(String id,JobModelClass job, UserModelClass user) async{
    FirebaseSavedJobService firbaseServices=FirebaseSavedJobService();
    try{
      await firbaseServices.addToSavedJobs(id,job,user)
          .then((value) => ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text('This job is saved.'),
        ),
      ));
    }catch(ex){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Opps something went wrong. Please try again.'),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations langLocal = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        color: const Color(0xFFEDF1FC),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.userModelClass.imageUrl??'',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue, // You can customize the border color
                        width: 1, // You can customize the border width
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 25, // You can adjust the radius of the circle avatar
                      backgroundImage: imageProvider, // Set the image provider directly
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(), // Show loading indicator
                  errorWidget: (context, url, error) => const Icon(Icons.error), // Show error icon if image fails to load
                ),
                const SizedBox(
                  width: 4.0,
                ),
                TextWidget(text: widget.userModelClass.name ??'',isBold: true,),
                const Spacer(),
                InkWell(
                  child: Icon(
                    isFav ? widget.iconData : widget.iconData,
                    color: isFav ? Colors.redAccent : null,
                    size: 30,
                  ),
                  onTap: () {
                    widget.onIconPressed!=null? widget.onIconPressed!():showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialogWidget(
                          message: 'Are you sure you want to save this job?',
                          onCancelName: "No",
                          onCancel: () {
                            // Handle cancel action
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          onDeleteName: "Yes",
                          onDelete: (){
                            saveJobs(APIs.user.uid.toString(), widget.jobModelClass, widget.userModelClass);
                            Navigator.of(context).pop();
                            // Close the dialog
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            TextWidget(
              text:widget.jobModelClass.title ??'',fontSize: 15,isBold: true,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  TextWidget(text: langLocal.hourAgo,
                    fontSize: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: TextWidget(text: GetTimeAgo.parse(DateTime.parse(widget.jobModelClass.createdTime??'')),
                        isBold: true,
                        fontSize: 11,
                      )
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  TextWidget(
                    text:langLocal.budget,
                    fontSize: 10,
                  ),
                  const SizedBox(
                    width: 2.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: TextWidget(
                      text: widget.jobModelClass.maxBudget??'',
                      fontSize: 11,
                      isBold: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.jobModelClass.description ??'',
              textAlign: TextAlign.justify,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    width: 100,
                    height: 40,
                    child: ButtonWidget(
                      onPress: () {
                        print(widget.userModelClass.name);

                        print("pressed");
                         Navigator.push(context,
                            MaterialPageRoute(builder: (context)
                            => JobDetails(
                              jobId: widget.jobId,
                              userModelClass: widget.userModelClass,
                              jobModelClass: widget.jobModelClass,
                            )
                            )
                        );
                      },
                      fontsize: 15,
                      title: langLocal.detailsButton,
                    )),
                const Spacer(),
                Text(langLocal.verified),
                const SizedBox(
                  width: 2.0,
                ),
                const Icon(Icons.check_circle, color: Colors.green)
              ],
            )
          ],
        ),
      ),
    );
  }
}
