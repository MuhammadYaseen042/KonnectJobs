import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:konnectjob/firbase_Services/apis.dart';
import 'package:konnectjob/firbase_Services/firebase_crud_funtions.dart';
import 'package:konnectjob/firbase_Services/modelClasses/notifications.dart';
import 'package:konnectjob/firbase_Services/modelClasses/user.dart';
import 'package:konnectjob/firbase_Services/notifications.dart';
import 'package:konnectjob/screens/common/profile_details.dart';
import 'package:konnectjob/utils/utils.dart';
import 'package:konnectjob/widgets/widgets_components.dart';
import '../../firbase_Services/firebase_auth_funtions.dart';
import '../../firbase_Services/modelClasses/job.dart';
import '../../translation/translation_api.dart';



///this screen show the details of job like jobd description creator details etc.
///this screen provide apply now button for a worker to send proposal to employer

class JobDetails extends StatefulWidget {
  final UserModelClass userModelClass;
  final JobModelClass jobModelClass;
  final String jobId;
  const JobDetails({
    Key? key,
    required this.jobId,
    required this.userModelClass,
    required this.jobModelClass

  }) : super(key: key);

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {

  UserModelClass? currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();

  }
  void getCurrentUser() async {
    // Add a delay of 2 seconds before executing the code inside the function
    FirebaseUserServices db = FirebaseUserServices();
    try {
      UserModelClass? user = await db.getUserById(APIs.user.uid.toString());
      setState(() {
        currentUser = user!;
        print("user data"+ user.toString());
      });
    } catch (e) {
      print("Failed to fetch current user: $e");
    }

  }

  /// Google Translation
  final apiKey = 'AIzaSyCqnVZG59mquZ8GCSr-0C6Ujvl3rw1mHOg';
  final urduLanguage = 'ur';
  final englishLanguage = 'en';
  String translatedUrduText=" waiting";
  ///Translate text
  getTranslatedText( String targetLanguage) async{

    var translatedText = await GoogleApi.translateText(widget.jobModelClass.description.toString(), targetLanguage, apiKey);
    setState(() {
      translatedUrduText=translatedText!;
    });
    print('Translated text: $translatedText');

  }
  bool isVisible=false;

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xff0077B5),
          iconTheme: const IconThemeData(color: Colors.white),
          title: appBarWhiteTitle("Job Details"),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding:  EdgeInsets.only(left: 8.0,top:8.0 ,right: 8.0,bottom: height*0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageContainer(height, width, widget.userModelClass.imageUrl!),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: "About the Client",
                              fontSize: 20,
                              isBold: true,
                            ),
                            sizedBoxH10,
                            TextWidget(
                              text: "Member since Feb 19, 2024",
                              fontSize: 14,
                            ),
                            sizedBoxH10,
                            boldText14(widget.userModelClass.name!),
                            sizedBoxH10,
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color(0xff0077B5),
                                ),
                                Flexible(child: boldText14("${widget.userModelClass.city}, " +"${widget.userModelClass.state}, "+"${widget.userModelClass.country}" )),
                              ],
                            ),
                            sizedBoxH10,
                            boldText14("2 jobs posted"),
                            sizedBoxH10,
                            Row(
                              children: [
                                for (int i = 0; i < 5; i++)
                                  const Icon(Icons.star,
                                      color: Color(0xFF14A800)),
                                TextWidget(
                                  text: "4.9/5",
                                  fontSize: 14,
                                  isBold: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                sizedBoxH10,
                const Divider(thickness: 1.0,color: Color(0xff0077B5),),
                TextWidget(
                  text: "About the Job",
                  fontSize: 20,
                  isBold: true,
                ),
                sizedBoxH10,
                TextWidget(
                  text: GetTimeAgo.parse(DateTime.parse(widget.jobModelClass.createdTime??'')),
                  fontSize: 15,
                ),
                sizedBoxH10,
                TextWidget(
                  text: "I need an ${widget.jobModelClass.title}",
                  fontSize: 18,
                  isBold: true,
                ),
                sizedBoxH10,
                Text(
                  "${widget.jobModelClass.description}",
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                sizedBoxH10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: (){

                        getTranslatedText(urduLanguage);
                        setState(() {
                          isVisible=!isVisible;
                        });

                      },
                      child:  TextWidget(
                        text: "Translate into Urdu",
                        isBold: true,
                        color: Colors.black,
                      ),),
                    OutlinedButton(
                      onPressed: (){
                        getTranslatedText(englishLanguage);
                        setState(() {
                          isVisible=!isVisible;
                        });

                      },
                      child:  TextWidget(
                        text: "Translate into English",
                        isBold: true,
                        color: Colors.black,
                      ),),
                  ],
                ),

                const Divider(thickness: 1.0,color: Color(0xff0077B5),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    iconWithTextRow(
                        Icons.monetization_on, "${widget.jobModelClass.maxBudget}", "Fixed-price"),
                    iconWithTextRow(Icons.work_history_sharp, "${widget.jobModelClass.experience}",
                        "Experience level"),
                    iconWithTextRow(Icons.access_time_filled, "${widget.jobModelClass.workDuration}",
                        "Project duration"),
                  ],
                ),
                const Divider(thickness: 1.0,color: Color(0xff0077B5),),
                Visibility(
                  visible: isVisible,
                  child:Text(translatedUrduText),
                ),
                sizedBoxH10,
                TextWidget(
                  text: "Activity on this job",
                  fontSize: 16,
                  isBold: true,
                ),
                TextWidget(
                  text: "More than 5 people applied",
                  fontSize: 13,
                ),
                sizedBoxH10,
              ],
            ),
          ),
        ),

        /// floating button
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonWidget(
            onPress: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>
                  ApplyForJob(
                    creator: widget.userModelClass,
                    job: widget.jobModelClass,
                    jobId: widget.jobId,
                    applicant: currentUser!,

                  )));
            },
            title: "Apply now",),
        )
    );
  }

  Text boldText14(String text) {
    return Text(
        text,
        softWrap: true,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,

        )
    );
  }

  Row iconWithTextRow(IconData icon, String text, String lable) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon, size: 15, color: const Color(0xff0077B5),
        ),
        const SizedBox(
          width: 3.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              lable,
            ),
          ],
        ),
      ],
    );
  }
}


/// second screen

class ApplyForJob extends StatefulWidget {
  final UserModelClass creator;
  final String jobId;
  final JobModelClass job;
  final UserModelClass applicant;

  const ApplyForJob({
    Key?key,
    required this.jobId,
    required this.creator,
    required this.job,
    required this.applicant,
  }):super(key: key);

  @override
  State<ApplyForJob> createState() => _ApplyForJobState();
}

class _ApplyForJobState extends State<ApplyForJob> {
  TextEditingController _budgetCon=TextEditingController();
  TextEditingController _proposalCon=TextEditingController();

  final apiKey = 'AIzaSyCqnVZG59mquZ8GCSr-0C6Ujvl3rw1mHOg';
  final urduLanguage = 'ur'; //
  final englishLanguage = 'en';
  String translatedUrduText=" waiting";

  bool isLoading=false;

  ///Translate text

  getTranslatedText(String target) async{
    final translatedText = await GoogleApi.translateText( _proposalCon.text.toString(),target, apiKey);
    setState(() {
      //translatedUrduText=translatedText!;
      _proposalCon.text=translatedText!;
    });
    print('Translated text: $translatedText');
  }

  /// Upload data
  Future<void>addCollection() async{

    ApplicantsService db=ApplicantsService();
    ApplicantsModel applicantsModel=ApplicantsModel(
      creatorId: widget.creator.userId,
      jobId: widget.jobId,
      applicantId: widget.applicant.userId,
      cost: _budgetCon.text.toString(),
      proposal: _proposalCon.text.toString(),

    );

    if(_proposalCon.text.isNotEmpty & _proposalCon.text.isNotEmpty){
      await db.addApplicant(applicantsModel);
    }else{
      print("Try again");
    }
  }

  Future <void> addNotification () async{
    FirebaseNotificationService db=FirebaseNotificationService();

    NotificationModel data= NotificationModel(
      jobId: widget.jobId,
      jobTitle: widget.job.title,
      senderName: widget.applicant.name,
      senderId: widget.applicant.userId,
      receiverId: widget.creator.userId,
      senderImage: widget.applicant.imageUrl,
      time: DateTime.now().toString(),
    );
    try{
      await db.addNotification(data);
    }catch(e){
      print("Wrong something");
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.currentUser.name);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff0077B5),
        iconTheme: const IconThemeData(color: Colors.white),
        title: appBarWhiteTitle("Apply Now"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(text: "Your charges",fontSize: 14),
                const SizedBox(height: 5.0,),
                TextFieldWidget(
                  controller: _budgetCon,
                  leadingIcon: Icons.attach_money,
                  hintText: "2000.00",
                  textInputType: TextInputType.number,
                ),
                sizedBoxH10,
                TextWidget(text: "Cover letter",fontSize: 14),
                sizedBoxH10,
                TextFormField(
                  controller: _proposalCon,
                  maxLines: 20,
                  maxLength: 5000,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    counterStyle: TextStyle(color: Colors.lightBlue),
                    hintText: "e.g Hello Saqlain! I'm here to assist you....",
                    border: OutlineInputBorder( // Use OutlineInputBorder for a border
                      borderSide: BorderSide(color: Colors.blue), // Set the border color
                      borderRadius: BorderRadius.circular(5.0), // Adjust the border radius as needed
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: (){
                        getTranslatedText(urduLanguage);
                        setState(() {

                        });
                      },
                      child:   TextWidget(
                        text: "English to Urdu",
                        isBold: true,                            ),),
                    OutlinedButton(
                      onPressed: (){
                        getTranslatedText(englishLanguage);
                        setState(() {

                        });
                      },
                      child:   TextWidget(
                        text: "Urdu to English",
                        isBold: true,                          //    color: Colors.white,
                        // style: OutlinedButton.styleFrom(backgroundColor:  const Color(0xff0077B5)),
                      ),),
                  ],
                ),
                sizedBoxH10,
                ButtonWidget(
                  onPress: () {
                    //EventDialogues.showEvent(context,"","","assets/images/loading.json");
                    setState(() {
                      isLoading=true;
                    });
                    addCollection().then((value) {
                      addNotification().whenComplete(() => ScaffoldMessenger
                          .of(context).showSnackBar(

                        const SnackBar(
                          content: Text('You applied on this job'),
                        ),
                      )
                      );
                    }
                    );
                    setState(() {
                      isLoading=false;
                    });
                    print("==== this is job id>>>>"+widget.jobId);
                  },
                  title: "Submit",isloading: isLoading,
                )
              ],
            ),
          )
      ),
    );
  }
}
