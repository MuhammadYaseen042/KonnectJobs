import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../firbase_Services/firebase_crud_funtions.dart';
import '../firbase_Services/modelClasses/user.dart';
import '../widgets/widgets_components.dart';

class ManageProfile extends StatefulWidget {
  const ManageProfile({
    super.key,
    required this.userModelClass,
  });

  final UserModelClass userModelClass;

  @override
  State<ManageProfile> createState() => _ManageProfileState();
}

class _ManageProfileState extends State<ManageProfile> {
  late final TextEditingController _nameCon;
  late final TextEditingController _cnicCon;
  late final TextEditingController _bdateCon;

  late String? gender;
  late DateTime selectedDate;
  String? profileUrl;
  Uint8List? image;
  late String? selectedCountry;
  late String? selectedState;
  late String? selectedCity;
  late String? userType;

  @override
  void initState() {
    super.initState();
    _nameCon = TextEditingController(text: widget.userModelClass.name);
    _cnicCon = TextEditingController(text: widget.userModelClass.cnicNumber);
    _bdateCon = TextEditingController(text: widget.userModelClass.dateOfBirth);
    gender = widget.userModelClass.gender;
    final DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    selectedDate =
        dateFormat.parse(widget.userModelClass.dateOfBirth.toString());
    selectedCountry = widget.userModelClass.country;
    selectedState = widget.userModelClass.state;
    selectedCity = widget.userModelClass.city;
  }

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

  bool isLoading = false;

  updateUserdData() async {
    setState(() {
      isLoading = true;
    });

    ///Model to handle Date
    UserModelClass userData = UserModelClass(
      userId: widget.userModelClass.userId,
      phoneNumber: widget.userModelClass.phoneNumber,
      imageUrl: profileUrl.toString(),
      name: _nameCon.text.trim(),
      cnicNumber: _cnicCon.text,
      gender: gender,
      dateOfBirth: _bdateCon.text,
      country: selectedCountry,
      state: selectedState,
      city: selectedCity,
    );

    ///ADD user data to firebase
    FirebaseUserServices firebaseService = FirebaseUserServices();
    try{
      await firebaseService.updateUser(widget.userModelClass.userId.toString(), userData )
        .whenComplete(() {
          isLoading=false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your data has been updated successfully'),
        ),
      );
    }
    );

    }catch(ex){
      setState(() {
        isLoading=false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text('Something went wrong! please try again '+ex.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: appBarWhiteTitle("Update Your Profile"),
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
                    child:CachedNetworkImage(
                      imageUrl: image != null ? '' : widget.userModelClass.imageUrl!,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue, // You can customize the border color
                            width: 1, // You can customize the border width
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 100, // You can adjust the radius of the circle avatar
                          backgroundImage: image != null ? MemoryImage(image!) : imageProvider,
                          // Set the image provider to memory image if image is not null, otherwise use the network image
                        ),
                      ),
                      placeholder: (context, url) => const CircularProgressIndicator(), // Show loading indicator
                      errorWidget: (context, url, error) => const CircleAvatar(
                        radius: 100,
                        child: Icon(Icons.error_outline_outlined,size:70,color: Colors.red,),// You can adjust the radius of the circle avatar
                        // Set the image provider to memory image if image is not null, otherwise use the network image
                      ), // Show error icon if image fails to load
                    )
                  ),
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
                          Icons.edit,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
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
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    radioListTileWidget("Male", "Male"),
                    radioListTileWidget("Female", "Female"),
                  ],
                ),
              ),
              sizedBoxH10,
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(langLocal.dateOfBirth),
              ),
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
                disabledDropdownDecoration: BoxDecoration(
                  color: const Color(0xFFEDF1FC),
                  borderRadius: BorderRadius.circular(10),
                ),
                selectedItemStyle: const TextStyle(
                  fontSize: 14,
                ),
                dropdownDialogRadius: 10.0,
                searchBarRadius: 20.0,
              ),

              sizedBoxH20,
              ButtonWidget(
                onPress: () {
                   updateUserdData();
                  ///DATA TO UPLOAD ON FIREBASE
                },
                title: langLocal.update,isloading: isLoading,
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
        value: value,
        groupValue: value == "Male" || value == "Female" ? gender : userType,
        title: Text(text),
        onChanged: (val) {
          setState(() {
            if (value == "Male" || value == "Female") {
              gender = val;
            } else {
              userType = val;
            }
          });
        },
      ),
    );
  }
}
