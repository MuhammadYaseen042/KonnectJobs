import 'dart:async';
// import 'package:konnectjob/firbase_Services/modelClasses/firebase_crud_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:konnectjob/cubit/accepted_jobs_cubit.dart';
import 'package:konnectjob/firbase_Services/firebase_crud_funtions.dart';
import 'package:konnectjob/firbase_Services/modelClasses/job.dart';
import 'package:konnectjob/firbase_Services/modelClasses/user.dart';
import '../firbase_Services/apis.dart';
import '../widgets/widgets_components.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MyJobsScreen extends StatefulWidget {
  final UserModelClass userModelClass;
  const MyJobsScreen({
    Key? key,
    required this.userModelClass,
  });

  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  /*List<JobModelClass>? jobModelList;
 
 UserModelClass? userModel;
 List<ApplicantsModel>? applicantsList;*/

  @override
  Widget build(BuildContext context) {
    final AppLocalizations langLocal = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: TextWidget(
            text: langLocal.myjobs,
          ),
          centerTitle: true,
          elevation: 0.0,
          bottom: const TabBar(
              indicatorColor: Colors.blue,
              dividerHeight: 0.0,
              isScrollable: true,

              //controller: _tabController,
              // onTap: (index) {},
              unselectedLabelColor: Colors.black38,
              labelColor: Colors.black,
              unselectedLabelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0),
              dividerColor: Colors.deepPurpleAccent,
              tabs: [
                Tab(
                  text: "Posts",
                ),
                Tab(
                  text: "Progressing Jobs",
                ),
              ]),
        ),
        body: TabBarView(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Jobs")
                  .where("creatorId", isEqualTo: APIs.user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final jobData = snapshot.data?.docs;

                    List<String> jobIdsList =
                        jobData?.map((e) => e.id).toList() ?? [];

                    ///stored in jobmodellist
                    List<JobModelClass> jobModelList = jobData
                            ?.map((e) => JobModelClass.fromJSON(e.data()))
                            .toList() ??
                        [];
                    print("======>.." + jobModelList.length.toString());
                    if (jobModelList.isNotEmpty) {
                      return ListView.builder(
                          itemCount: jobModelList.length,
                          itemBuilder: (context, index) {
                            return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("applicants")
                                  .where("jobId",
                                      isEqualTo: jobIdsList[index].toString())
                                  .snapshots(),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                  case ConnectionState.none:
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  case ConnectionState.active:
                                  case ConnectionState.done:
                                    final applicantData = snapshot.data?.docs;

                                    if (snapshot.hasData) {
                                      List<String> applicantDocIds =
                                          applicantData
                                                  ?.map((e) => e.id)
                                                  .toList() ??
                                              [];

                                      List<ApplicantsModel> applicantsList;

                                      ///stored in jobmodellist
                                      applicantsList = applicantData
                                              ?.map((e) =>
                                                  ApplicantsModel.fromJSON(
                                                      e.data()))
                                              .toList() ??
                                          [];
                                      print("======>.." +
                                          jobModelList.length.toString());
                                      return StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection("Users")
                                            .where("userId",
                                                isEqualTo:
                                                    APIs.user.uid.toString())
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                            case ConnectionState.none:
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            case ConnectionState.active:
                                            case ConnectionState.done:
                                              if (snapshot.hasData) {
                                                //   List<String> applicantIds = applicantData?.map((e) => e.id).toList() ?? [];
                                                ///stored in jobmodellist
                                                final userData =
                                                    snapshot.data?.docs.first;
                                                UserModelClass? userModel;
                                                userModel = userData != null
                                                    ? UserModelClass.fromJSON(
                                                        userData.data())
                                                    : null;

                                                print("======>.." +
                                                    jobModelList.length
                                                        .toString());

                                                return Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 8.0),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                                  color:
                                                      const Color(0xFFEDF1FC),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ListTile(
                                                        leading:
                                                            CachedNetworkImage(
                                                          imageUrl: userModel!
                                                                  .imageUrl ??
                                                              '',
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .blue, // You can customize the border color
                                                                width:
                                                                    1, // You can customize the border width
                                                              ),
                                                            ),
                                                            child: CircleAvatar(
                                                              radius:
                                                                  25, // You can adjust the radius of the circle avatar
                                                              backgroundImage:
                                                                  imageProvider, // Set the image provider directly
                                                            ),
                                                          ),
                                                          placeholder: (context,
                                                                  url) =>
                                                              const CircularProgressIndicator(), // Show loading indicator
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(Icons
                                                                  .error), // Show error icon if image fails to load
                                                        ),
                                                        title: Text(userModel
                                                            .name
                                                            .toString()),
                                                        subtitle: const Text(
                                                            "2 minutes ago"),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        jobModelList[index]
                                                            .description
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.justify,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      const Divider(),
                                                      ButtonWidget(
                                                          title:
                                                              "${applicantsList.length.toString()} "
                                                              "proposals",
                                                          onPress: () {
                                                            viewProposals(
                                                                context,
                                                                applicantsList,
                                                                jobIdsList[
                                                                    index],
                                                                applicantDocIds);
                                                          }),
                                                      const Divider(),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return const Center(
                                                  child: Text("No user found"),
                                                );
                                              }
                                          }
                                        },
                                      );
                                    } else {
                                      return const Center(
                                        child: Text("No proposal"),
                                      );
                                    }
                                }
                              },
                            );
                          });
                    } else {
                      return Center(
                          child: TextWidget(
                              text: "No job is found!", isBold: true));
                    }
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<AcceptedJobsCubit, AcceptedJobsState>(
                builder: (context, state) {
                  return FutureBuilder(
                      future:
                          getAcceptedApplication(state.acceptedApplicationId),
                      builder: (context, snapshot) {
                        //TODO: Data ismein hai..
                        final applicationData = snapshot.data!;
                        return FutureBuilder(
                          future: getJobs(applicationData['jobId']),
                          builder: (context, snapshot) {
                            final jobData = snapshot.data;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: "About Job",
                                  fontSize: 16,
                                  isBold: true,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      jobData?['title'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      jobData?['maxBudget'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Text(jobData?['description']),
                                const SizedBox(height: 5),
                                TextWidget(
                                  text: "About Hired Person",
                                  fontSize: 16,
                                  isBold: true,
                                ),
                                FutureBuilder(
                                  future: getUserData(
                                      applicationData['applicantId']),
                                  builder: (context, snapshot) {
                                    final applicant = snapshot.data;
                                    return Row(
                                      children: [
                                        // TODO: Picture Idhr lagani hai..
                                        // imageUrl
                                        const CircleAvatar(),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(applicant?['name']),
                                        const Spacer(),
                                        // Text("200 PKR"),
                                      ],
                                    );
                                  },
                                ),
                                FutureBuilder(
                                    future: getApplicantDetail(
                                        applicationData['applicantionId']),
                                    builder: (context, snapshot) {
                                      final applicantDatails = snapshot.data;
                                      return Text(
                                          applicantDatails?['proposal']);
                                    }),
                                const Divider(),
                                ButtonWidget(
                                    title: "Is this job completed? ",
                                    onPress: () {
                                      reviewWidget(context,
                                          applicationData['applicantId']);
                                    }),
                                const Divider(),
                              ],
                            );
                          },
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void viewProposals(
      BuildContext context,
      List<ApplicantsModel> applicantsModel,
      String jobId,
      List<String> applicantionId) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              sizedBoxH20,
              TextWidget(
                text: "Proposals",
                fontSize: 14,
              ),
              Flexible(
                  child: ListView.builder(
                      itemCount: applicantsModel.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Users")
                              .where("userId",
                                  isEqualTo: applicantsModel[index]
                                      .applicantId
                                      .toString())
                              .snapshots(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                              case ConnectionState.none:
                                return const Center(
                                    child: CircularProgressIndicator());
                              case ConnectionState.active:
                              case ConnectionState.done:
                                final userData = snapshot.data?.docs.first;
                                UserModelClass? applicantsData;
                                applicantsData = userData != null
                                    ? UserModelClass.fromJSON(userData.data())
                                    : null;

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 8.0),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  color: const Color(0xFFEDF1FC),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        leading: CachedNetworkImage(
                                          imageUrl:
                                              applicantsData!.imageUrl ?? '',
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors
                                                    .blue, // You can customize the border color
                                                width:
                                                    1, // You can customize the border width
                                              ),
                                            ),
                                            child: CircleAvatar(
                                              radius:
                                                  25, // You can adjust the radius of the circle avatar
                                              backgroundImage:
                                                  imageProvider, // Set the image provider directly
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(), // Show loading indicator
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons
                                                  .error), // Show error icon if image fails to load
                                        ),
                                        title: Text(
                                            applicantsData.name.toString()),
                                        subtitle: const Text("2 minutes ago"),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        applicantsModel[index]
                                            .proposal
                                            .toString(),
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        jobId.toString(),
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        applicantionId[index].toString(),
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ButtonWidget(
                                              width: 100,
                                              height: 40,
                                              fontsize: 14,
                                              color: const Color.fromRGBO(
                                                  76, 175, 80, 1),
                                              title: "Accept",
                                              onPress: () async {
                                                FirebaseAcceptedApplicationsService
                                                    db =
                                                    FirebaseAcceptedApplicationsService();

                                                AcceptedApplications data =
                                                    AcceptedApplications(
                                                        jobId: jobId,
                                                        jobCreatorId: APIs
                                                            .user.uid
                                                            .toString(),
                                                        applicantionId:
                                                            applicantionId[
                                                                index],
                                                        applicantId:
                                                            applicantsModel[
                                                                    index]
                                                                .applicantId);
                                                try {
                                                  String
                                                      acceptedApplicationDocId =
                                                      await db
                                                          .addAcceptedApplication(
                                                              data);
                                                  if (!context.mounted) return;
                                                  context
                                                      .read<AcceptedJobsCubit>()
                                                      .workRequestAccepted(
                                                          acceptedApplicationDocId);
                                                } catch (ex) {
                                                  debugPrint("Error$ex");
                                                }
                                                Navigator.pop(context);
                                              }),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                            }
                          },
                        );
                      }))
            ],
          ),
        ),
      ),
    );

    // addAcceptedProposal(String jobId, String applicationId,String applicantId,String jobCreatorId) async{

    // }
  }

  void reviewWidget(
    BuildContext context,
    String workerId,
  ) {
    double rating = 0;
    final TextEditingController _feedbackCon = TextEditingController();
    showModalBottomSheet(
      backgroundColor: Colors.white,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              sizedBoxH20,
              TextWidget(
                text: "Give a review based on Worker performance",
                fontSize: 14,
                isBold: true,
              ),
              TextFieldWidget(
                controller: _feedbackCon,
                leadingIcon: Icons.rate_review,
                hintText: "Write a review",
              ),
              TextWidget(
                text: "Rating",
                fontSize: 14,
                isBold: true,
              ),
              RatingBar.builder(
                initialRating: 0,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    rating = rating;
                  });
                },
              ),
              sizedBoxH10,
              ButtonWidget(
                onPress: () {
                  FirebaseFirestore.instance
                      .collection('Workers')
                      .doc(workerId)
                      .collection('reviews')
                      .add({
                    'stars': rating.toString(),
                    'description': _feedbackCon.text
                  });
                  Navigator.pop(context);
                },
                title: "Pay Cash",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>?> getAcceptedApplication(
    String? acceptedApplicationId) async {
  final documentSnapshot = await FirebaseFirestore.instance
      .collection('acceptedApplications')
      .doc(acceptedApplicationId)
      .get();
  final data = documentSnapshot.data();
  return data;
}

Future<Map<String, dynamic>?> getJobs(String? acceptedJobId) async {
  final documentSnapshot = await FirebaseFirestore.instance
      .collection('Jobs')
      .doc(acceptedJobId)
      .get();
  final data = documentSnapshot.data();
  return data;
}

Future<Map<String, dynamic>?> getUserData(String? applicantId) async {
  final documentSnapshot = await FirebaseFirestore.instance
      .collection('Users')
      .doc(applicantId)
      .get();
  final data = documentSnapshot.data();
  return data;
}

Future<Map<String, dynamic>?> getApplicantDetail(String? applicantId) async {
  final documentSnapshot = await FirebaseFirestore.instance
      .collection('applicants')
      .doc(applicantId)
      .get();
  final data = documentSnapshot.data();
  return data;
}
