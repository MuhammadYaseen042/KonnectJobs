import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:konnectjob/firbase_Services/firebase_crud_funtions.dart';
import 'package:konnectjob/firbase_Services/modelClasses/job.dart';
import 'package:konnectjob/utils/utils.dart';
import '../../Models/small_models.dart';
import '../../firbase_Services/apis.dart';
import '../../translation/translation_api.dart';
import '../../widgets/widgets_components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {

  final TextEditingController _descriptionCon=TextEditingController();

  final TextEditingController _budgetCon=TextEditingController();
  String? userId;
  String? jobTitle;
  String? experience;
  String? workDuration;
  bool isLoading=false;

  clearFields(){
    jobTitle=null;
    _descriptionCon.clear();
    _budgetCon.clear();
    experience=null;
    workDuration=null;
  }

  addJobData() async{
    if(jobTitle.toString().isNotEmpty && _descriptionCon.text.isNotEmpty &&
        _budgetCon.text.isNotEmpty && experience.toString().isNotEmpty
        && workDuration.toString().isNotEmpty
    ){
      JobModelClass jobData=JobModelClass(
        creatorId: APIs.user.uid.toString(),
        title: jobTitle,
        description: _descriptionCon.text,
        maxBudget: _budgetCon.text,
        createdTime: DateTime.now().toString(),
        experience: experience,
        workDuration: workDuration,
      );
      FirebaseJobsServices db=FirebaseJobsServices();
      EventDialogues.showEvent(context, "Posting Job", "Wait it'll takes few minutes", "assets/images/loading.json");
     GoogleApi.checkForBadWords(_descriptionCon.text.toString()).then((value) async {
        int result = value;
      if(result==0){
        try {
          await db.createJob( jobData)
              .whenComplete(() {
            Navigator.pop(context);
            EventDialogues.showEvent(context, "Great", "Your job is posted!", "assets/images/success.json");
          }).then((value) => clearFields());
        } catch (e) {
          print('Error posting job: $e');
        }
      }else if(result==1){
        Navigator.pop(context);
        EventDialogues.showEvent(context, "Bad words in Post", "We detect bad words in your post. Kindly remove it! ", "assets/images/failer.json");
      }
        // Store the result in a variable if needed
      });


    }else{
     EventDialogues.showEvent(context, "Failed", "Oops Something went wrong!", "assets/images/failer.json");
    }

  }

  /// Google Translation
  final apiKey = 'AIzaSyCqnVZG59mquZ8GCSr-0C6Ujvl3rw1mHOg';
  final urduLanguage = 'ur'; //
  final englishLanguage = 'en';
  String translatedUrduText=" waiting";

  ///
  String buttonUrdu="Translate into Urdu";
  String buttonEnglish="Translate into English";
  ///Translate text
  bool isUrdu=true;
  getTranslatedText(String target) async{
    var translatedText = await GoogleApi.translateText( _descriptionCon.text.toString(),target, apiKey);
    setState(() {
      //translatedUrduText=translatedText!;
      _descriptionCon.text=translatedText!;
    });
    print('Translated text: $translatedText');
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   // _classifier = Classifier();
    //_descriptionCon=TextEditingController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final AppLocalizations langLocal = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 20.0,bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelText(langLocal.selectTitleCreatJob),
            DropdownButtonWidget(
              hint: langLocal.selectTitle,
              selectedValue: jobTitle,
              dropdownItems: titleList,
              onChanged: (value){
                jobTitle=value;
              },
              leadingIcon: Icons.menu_open_rounded,),
            sizedBoxH10,
            labelText(langLocal.tellUsBudget),
            TextFieldWidget(controller: _budgetCon,hintText: langLocal.maxBudget,leadingIcon: Icons.paid_outlined,textInputType: TextInputType.number,),
            sizedBoxH10,
            labelText(langLocal.selectLevelExp),
            DropdownButtonWidget(hint: langLocal.selectLevelExp,
              selectedValue: experience,
              onChanged: (value){
                experience=value;
              },
              dropdownItems: experienceLevel,leadingIcon: Icons.menu_open_rounded,),
            sizedBoxH10,
            labelText(langLocal.howLongWork),
            DropdownButtonWidget(hint: langLocal.workDuration,
              selectedValue: workDuration,
              onChanged: (value){
                workDuration=value;
              },
              dropdownItems: workDurationList,leadingIcon: Icons.menu_open_rounded,),
            sizedBoxH10,
            labelText(langLocal.jobDescrip),
            TextFormField(
              maxLines: 20,
              maxLength: 5000,
              controller: _descriptionCon,
              onChanged: (value){
                setState(() {
                  _descriptionCon.text=value;
                });
              },
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                counterStyle: const TextStyle(color: Colors.lightBlue),
                hintText: langLocal.hintJobDes,
                border: OutlineInputBorder( // Use OutlineInputBorder for a border
                  borderSide: const BorderSide(color: Colors.blue), // Set the border color
                  borderRadius: BorderRadius.circular(5.0), // Adjust the border radius as needed
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: (){
                    getTranslatedText(urduLanguage);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white70,),
                  child:  TextWidget(
                    text: "Translate into Urdu",
                    isBold: true,
                    color: Colors.black,
                  ),),
                OutlinedButton(
                  onPressed: (){
                    getTranslatedText(englishLanguage);
                  },
                  child:  TextWidget(
                    text: "Translate into English",
                    isBold: true,
                    color: Colors.black,
                  ),),
              ],
            ),
            sizedBoxH20,
            ButtonWidget(
              onPress: () {
                 /// Machine modal to predict hate speeches
                addJobData();
              },
              title: "Post",isloading: isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Padding labelText(String text) {
    return  Padding(
      padding:const EdgeInsets.only(bottom: 5.0),
      child: Text(text),
    );
  }
}
