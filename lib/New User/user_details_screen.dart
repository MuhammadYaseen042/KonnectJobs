import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:konnectjob/screens/common/home.dart';
import 'package:lottie/lottie.dart';
import '../Models/small_models.dart';
import '../firbase_Services/firebase_auth_funtions.dart';
import '../firbase_Services/firebase_crud_funtions.dart';
import '../firbase_Services/modelClasses/user.dart';
import '../widgets/widgets_components.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// 2nd screen of user details like name,cnic,country,state,city

class UserDetails extends StatefulWidget {
  const UserDetails({
    super.key,
    required this.userPhoneNumber,
  });
  @override
  State<UserDetails> createState() => _UserDetailsState();
  final String userPhoneNumber;
}

class _UserDetailsState extends State<UserDetails> {
  final TextEditingController _nameCon = TextEditingController();
  final TextEditingController _cnicCon = TextEditingController();
  final TextEditingController _bdateCon = TextEditingController();
  String? gender;
  DateTime selectedDate = DateTime.now();
  String? profileUrl;
  Uint8List? image;
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  String? userType;
  String? userId;


  ///date picker to pick date of birth
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(
          1940,
        ),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _bdateCon.text =
            "${selectedDate.day}/${selectedDate.month.toString()}/${selectedDate.year.toString()}";
      });
    }
  }

  ///image Picker
  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? file = await _imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    } else {
      return print("No image selected");
    }
  }

  void selectImage() async {
    Uint8List _image = await pickImage(ImageSource.gallery);
    setState(() {
      image = _image;
      postImageData();
    });
  }
///POST image in firebaseStorage and get downoadUrl of image
  Future<String?> postImageData() async {
    if (image == null) return null; // Handle no image selected

    String filename = DateTime.now().microsecondsSinceEpoch.toString();

    try {
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImage = referenceRoot.child("Images");

      Reference imageToUpload = referenceDirImage.child(filename);
      final uploadTask = imageToUpload
          .putData(image!); // Use the image data from your pickImage function
      await uploadTask;

      final downloadUrl = await imageToUpload.getDownloadURL();
      print(downloadUrl);
      setState(() {
        profileUrl = downloadUrl;
      });
      return downloadUrl;
    } on FirebaseException catch (e) {
      print('Upload error: $e');
      // Handle upload error (e.g., show a snackbar to the user)
      return null;
    }
  }
bool isLoading=false;


  /// upload the details of user in users collection.
  uplaodData(){
    setState(() {
      isLoading=true;
    });
    ///Model class  to handle Data
    UserModelClass userData = UserModelClass(
      userId: userId,
      phoneNumber: widget.userPhoneNumber.toString(),
      imageUrl: profileUrl.toString(),
      name: _nameCon.text.trim(),
      cnicNumber: _cnicCon.text,
      gender: gender,
      dateOfBirth: _bdateCon.text,
      country: selectedCountry,
      state: selectedState,
      city: selectedCity,
      userType: userType,

    );

    ///ADD user data to firebase
    FirebaseUserServices firebaseService =
    FirebaseUserServices();
    firebaseService.registerUser(userId.toString(),userData).whenComplete(() => setState(() {
      isLoading = false;
    })).then((value) {
      setState(() {
        userId=value;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User Registered successfully'),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
       if(userType=="Client"){
         Navigator.push(context,
             MaterialPageRoute(builder: (_) =>  HomeScreen()));
       }else{
         Navigator.push(context,
             MaterialPageRoute(builder: (_) =>  WorkerDetails(userId: userId,)));
       }
      });

    });
  }


  /// check the user is authenticated or not
  /// if authenticated then check user document is exist or not if yes then navigate to home screen
  /// if not then take the information of user and navigate to related screen
  Future<void> getUserId() async {
    FirebaseAuthService firebaseAuth = FirebaseAuthService();
    String? userID = await firebaseAuth.getUserIdIfAuthenticated();
    if (userID != null) {
      setState(() {
        userId = userID;
      });
      // Check if there's any document in the Users collection with this user ID
      FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get()
          .then((docSnapshot) {
        if (docSnapshot.exists) {
          // Document exists, handle accordingly
          print('Document with ID $userId exists in the Users collection');
          Navigator.push(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
          // You can access the data using docSnapshot.data()
        } else {
          // Document doesn't exist, handle accordingly
          print('Document with ID $userId does not exist in the Users collection');
        }
      }).catchError((error) {
        // Handle any errors that occur during the process
        print('Error fetching document: $error');
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();

  }

  @override
  Widget build(BuildContext context) {
    print(widget.userPhoneNumber);
    var mediaQuery = MediaQuery.of(context);
    final AppLocalizations langLocal = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xff0077B5),
        leading: CupertinoButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: appBarWhiteTitle("Signup"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Center(
                      child: image != null
                          ? CircleAvatar(
                              radius: 100,
                              backgroundColor: const Color(0xFFEDF1FC),
                              backgroundImage: MemoryImage(image!),
                            )
                          : const CircleAvatar(
                              radius: 100,
                              backgroundColor: Color(0xFFEDF1FC),
                              child: Icon(
                                Icons.person,
                                size: 170,
                              ),
                            )),
                  Positioned(
                      left: mediaQuery.size.width * (0.6 - 0.06),
                      bottom: mediaQuery.size.width * (0.01),
                      child: GestureDetector(
                        onTap: () {
                          selectImage();
                        },
                        child: Container(
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: const Color(0xff0077B5),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 25,
                            )),
                      ))
                ],
              ),
              sizedBoxH10,
              TextFieldWidget(
                onChanged: (value) {},
                leadingIcon: Icons.person,
                controller: _nameCon,
                hintText: langLocal.name,
              ),
              sizedBoxH10,
              TextFieldWidget(
                isCNIC: true,
                onChanged: (value) {},
                leadingIcon: Icons.credit_card,
                controller: _cnicCon,
                hintText: "71403-0359820-1",
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(langLocal.gender),
              ),
              Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFEDF1FC),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    radioListTileWidget("Male", "Male"),
                    radioListTileWidget("Female", "Female"),
                  ],
                ),
              ),
              sizedBoxH10,
              TextFieldWidget(
                controller: _bdateCon,
                readOnly: true,
                hintText: langLocal.dateOfBirth,
                leadingIcon: Icons.date_range_sharp,
                trailingIcon: Icons.arrow_drop_down,
                onTap: () {
                  _selectDate(context);
                },
              ),
              sizedBoxH10,
              CSCPicker(
                cityDropdownLabel: langLocal.city,
                stateDropdownLabel: langLocal.state,
                countryDropdownLabel: langLocal.country,
                layout: Layout.horizontal,
                flagState: CountryFlag.DISABLE,
                onCountryChanged: (country) {
                  setState(() {
                    selectedCountry = country;
                  });
                },
                onStateChanged: (state) {
                  setState(() {
                    selectedState = state;
                  });
                },
                onCityChanged: (city) {
                  setState(() {
                    selectedCity = city;
                  });
                },
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFEDF1FC),
                ),

                ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                disabledDropdownDecoration: BoxDecoration(
                  color: const Color(0xFFEDF1FC),
                  borderRadius: BorderRadius.circular(10),
                ),
                selectedItemStyle: const TextStyle(
                  fontSize: 14,
                ),

                ///Dialog box radius [OPTIONAL PARAMETER]
                dropdownDialogRadius: 10.0,

                ///Search bar radius [OPTIONAL PARAMETER]
                searchBarRadius: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(langLocal.joinAs),
              ),
              Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFEDF1FC),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    radioListTileWidget("Client", langLocal.client),
                    radioListTileWidget("Worker", langLocal.worker),
                  ],
                ),
              ),
              sizedBoxH20,
              ButtonWidget(
                onPress: () {
                  uplaodData();
                  ///DATA TO UPLOAD ON FIREBASE
                },
                title: langLocal.submitButton,isloading:isLoading ,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded radioListTileWidget(String value, String text) {
    return Expanded(
      child: RadioListTile(
        value: value, // Set value as string
        groupValue: value == "Male" || value == "Female" ? gender : userType,
        title: Text(text),
        onChanged: (val) {
          setState(() {
            if (value == "Male" || value == "Female") {
              gender = val; // Assign selected value to gender
            } else {
              userType = val; // Assign selected value to userType
            }
          });
        },
      ),
    );
  }
}

/// if user sign in as a worker then take working details of user
/// and create a collection of user by getting user id from authentication.
///Job finder related information /Worker skills screen

class WorkerDetails extends StatefulWidget {

  final String? userId;
   const WorkerDetails({super.key,
    this.userId,

  });

  @override
  State<WorkerDetails> createState() => _WorkerDetailsState();
}

class _WorkerDetailsState extends State<WorkerDetails> {
  final TextEditingController _otherSkillsCon = TextEditingController();
  List<String> cateIndex = [];
  List<String> hireCateIndex = [];
  String? selectedExp;
  String? experience, category;
  bool isLoading=false;
  void addCateToList(String idx, bool isHire) {
    isHire
        ? hireCateIndex.contains(idx)
            ? hireCateIndex.remove(idx)
            : hireCateIndex.add(idx)
        : cateIndex.contains(idx)
            ? cateIndex.remove(idx)
            : cateIndex.add(idx);
    setState(() {});
  }

/// Upload Worker Data
  uplaodData(){
    setState(() {
      isLoading=true;
    });
    if(widget.userId.toString().isNotEmpty && category.toString().isNotEmpty && cateIndex.length>0
    && experience.toString().isNotEmpty && _otherSkillsCon.text.isNotEmpty
    ){
      WorkerSkillsDataModelClass userData = WorkerSkillsDataModelClass(
        workerId: widget.userId,
        workCategory: category,
        skillsList: cateIndex,
        workExperience: experience,
        createdAt: DateTime.now().toString(),
        otherSkill: _otherSkillsCon.text.toString(),
      );

      ///ADD user data to firebase
      FirebaseWorkersServices firebaseService =
      FirebaseWorkersServices();
      firebaseService.registerWorker(widget.userId.toString(),userData).whenComplete(() => setState(() {
        isLoading = false;
      })).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Worker Registered successfully'),
          ),
        );
        Navigator.push(context,
            MaterialPageRoute(builder: (_) =>  HomeScreen()));
      });
    }else{
      setState(() {
        isLoading=false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
        ),
      );
    }
    ///Model to handle Date
  }
  @override
  Widget build(BuildContext context) {
    final AppLocalizations langLocal = AppLocalizations.of(context)!;

    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xff0077B5),
        leading: CupertinoButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: appBarWhiteTitle("Working Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizedBoxH10,
              DropdownButtonWidget(
                hint: langLocal.mainCategoryWorker,
                leadingIcon: Icons.work_history,
                dropdownItems: titleList,
                selectedValue: category,
                onChanged: (value) {
                  // Store the selected value in the newVal variable
                  category = value;
                },
              ),
              sizedBoxH10,
              TextWidget(
                text: langLocal.subCategoryWorker,
              ),
              Container(
                height: mediaQuery.size.height * 0.4,
                color: const Color(0xffEDF1FC),
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: WorkerCategory.workerCateList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          addCateToList(
                              WorkerCategory.workerCateList[index].titile,
                              false);
                          debugPrint(cateIndex.length.toString());
                        },
                        child: checkBoxTile(
                            WorkerCategory.workerCateList[index].titile,
                            cateIndex.contains(
                                WorkerCategory.workerCateList[index].titile)),
                      );
                    }),
              ),
              sizedBoxH10,
              DropdownButtonWidget(
                hint: langLocal.workExperience,
                leadingIcon: Icons.add_task_outlined,
                dropdownItems: experienceYearList,
                selectedValue: experience,
                onChanged: (value) {
                  // Store the selected value in the newVal variable
                  experience = value;
                },
              ),
              sizedBoxH10,
              TextFieldWidget(
                controller: _otherSkillsCon,
                hintText: langLocal.anySkill,
              ),
              sizedBoxH10,
              ButtonWidget(
                onPress: (){
                uplaodData();
                },
                title: langLocal.submitButton,isloading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


