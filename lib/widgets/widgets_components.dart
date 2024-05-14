import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_picker/country_picker.dart';
import 'package:konnectjob/firbase_Services/modelClasses/user.dart';
import 'package:konnectjob/screens/common/chat.dart';
import 'package:konnectjob/screens/common/profile_details.dart';


///appBar white title
Text appBarWhiteTitle(String title){
  return Text(title,
    style: const TextStyle(
      color: Colors.white,
    ),

  );
}


/// 1)Button Widget
class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {Key? key,
      this.isloading = false,
      this.title = '',
      this.fontsize = 18.0,
      this.width = double.infinity,
      this.height = 50.0,
      this.color = const Color(0xff0077B5),
      this.titleColor = Colors.white,
      required this.onPress})
      : super(key: key);

 final bool isloading;
  final String title;
  final double fontsize;
  final double height;
  final double width;
  final Color titleColor;
  final Color color;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {
        onPress();
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: color),
        child: Center(
            child: isloading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : TextWidget(
                    text: title,
                    color: titleColor,
                    fontSize: fontsize,
                    isBold: true,
                  )),
      ),
    );
  }
}

///2) Text Widget Component

class TextWidget extends StatelessWidget {
   TextWidget({
    Key? key,
    required this.text,
    this.fontSize,
    this.color = Colors.black,
    this.fontStyle = FontStyle.normal,
    this.isBold=false,
  }) : super(key: key);
  final String text;
  final double? fontSize;
  final Color color;
  final FontStyle fontStyle;
  bool isBold;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      maxLines: 5,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        letterSpacing: 0.5,
        fontWeight:isBold? FontWeight.bold:FontWeight.normal,
        fontStyle: fontStyle,
      ),
    );
  }
}

/// 3) TextField Widget

class TextFieldWidget extends StatefulWidget {
  //Constructor
  const TextFieldWidget({
    Key? key,
    required this.controller,
    this.leadingIcon,
    this.trailingIcon,
    this.fillColor =const Color(0xFFEDF1FC),
    this.textInputType = TextInputType.text,
    this.secure = false,
    this.readOnly=false,
    this.initialValue,
    this.radius=10,
    this.hintText = " ",
    this.labelText,
    this.errorText,
    this.onChanged,
    this.onTap,
    this.trailingFn,
    this.isCNIC = false,
  }) : super(key: key);


  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
  final  bool secure, isCNIC,readOnly;
  final String? labelText;
  final String? initialValue;
  final String hintText;
  final String? errorText;
  final double radius;
  final TextInputType textInputType;
  final Color fillColor;
  final TextEditingController controller;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final void Function(String)? onChanged;
  final VoidCallback?  onTap;
  final VoidCallback? trailingFn;
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      keyboardType: widget.isCNIC ? TextInputType.number : widget.textInputType,
      inputFormatters: widget.isCNIC
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(13),
              CNICFormatter(),
            ]
          : null,
      obscureText: widget.secure,
      controller: widget.controller,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        errorText: widget.errorText,
        labelText: widget.labelText,
        contentPadding: const EdgeInsets.only(left: 5.0, right: 10),
        border:  OutlineInputBorder(
          borderSide: BorderSide.none,
            /*(
            color: Colors.black,
            width: .0,
            style: BorderStyle.solid
          ),*/
           borderRadius: BorderRadius.circular(widget.radius),
            ),
        filled: true,
        fillColor: widget.fillColor,
        prefixIcon: widget.leadingIcon == null
            ? null
            : Icon(widget.leadingIcon, color: Colors.black38, size: 25.0),
        suffixIcon: widget.trailingIcon == null
            ? null
            : InkWell(
                onTap: widget.trailingFn,
                child:
                    Icon(widget.trailingIcon, color: Colors.black38, size: 25.0),
              ),
        hintText: widget.hintText,
      ),

    );
  }
}

class CNICFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove non-digits
    String text = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (text.length >= 5 && text.length <= 13) {
      // Add hyphen at the 12th position for CNIC format
      text =
          '${text.substring(0, 5)}-${text.substring(5, min(12, text.length))}${text.length > 12 ? '-${text.substring(12)}' : ''}';
    }
    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// 4) Blue Color Container

class BlueContainer extends StatelessWidget {
  const BlueContainer({
    super.key,
    required this.child,
    this.height = 0,
    this.color = const Color(0xFFB3E7FA),
  });

  final Widget child;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      //margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20.0),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: child,
    );
  }
}

/// 5) Phone Number Text Field
class PhoneTextField extends StatefulWidget {
  const PhoneTextField({
    super.key,
    required this.controller,
    required this.onChanged,
  });
  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
  final TextEditingController controller;
  final Function(String) onChanged;
}
class _PhoneTextFieldState extends State<PhoneTextField> {
  Country selectedCountry = Country(
    phoneCode: "92",
    countryCode: "PK",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Pakistan",
    example: "Pakistan",
    displayName: "Pakistan",
    displayNameNoCountryCode: "PK",
    e164Key: " ",
  );
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: widget.controller,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      onChanged: widget.onChanged,
      maxLength: 10,
      decoration: InputDecoration(
          hintText: "3135586233",
          counterText: " ",
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15.0),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Container(
            width: 70,
            padding: const EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            child: InkWell(
              highlightColor: const Color(0xff0077B5),
              onTap: () {
                showCountryPicker(
                    context: context,
                    onSelect: (value) {
                      setState(() {
                        selectedCountry = value;
                        //debugPrint("${selectedCountry.phoneCode} is code of country");
                      });
                    },
                    countryListTheme: const CountryListThemeData(
                        margin: EdgeInsets.all(10.0),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        bottomSheetHeight: 400));
              },
              child: Text(
                "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          suffixIcon: widget.controller.text.length == 10
              ? const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )
              : null),
    );
  }
}

/// 6) SizedBox Widget with 10 height

Widget sizedBoxH10 = const SizedBox(
  height: 10,
);
Widget sizedBoxH20 = const SizedBox(
  height: 20,
);


/// CheckBox widget

Widget checkBoxTile(String title, bool isSelected) {
  return ListTile(
    trailing: isSelected
        ? const CircleAvatar(
            radius: 15,
            backgroundColor: Color(0xff0077B5),
            child: Icon(Icons.check),
          )
        : Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff0077B5), width: 2),
                borderRadius: BorderRadius.circular(10)),
          ),
    title: Text(title),
  );
}




/// dropdown widget
class DropdownButtonWidget extends StatefulWidget {
  DropdownButtonWidget({
    Key? key,
    this.selectedValue,
    required this.hint,
    this.leadingIcon,
    required this.dropdownItems,
    this.onChanged,
  }) : super(key: key);

  @override
  State<DropdownButtonWidget> createState() => _DropdownButtonWidgetState();

  String? selectedValue;
  String hint;
  IconData? leadingIcon;
  final List<String> dropdownItems;
  final void Function(String)? onChanged;
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      hint: Text(widget.hint),
      value: widget.selectedValue,
      decoration: InputDecoration(
        prefixIcon: Icon(widget.leadingIcon),
        prefixIconColor: Colors.black38,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color(0xFFEDF1FC),
      ),
      menuMaxHeight: 350,
      onChanged: (newValue) {
        setState(() {
          widget.selectedValue = newValue;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(newValue!);
        }
      },
      items: widget.dropdownItems
          .map(
            (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
          .toList(),
    );
  }
}



///help widget
helperWidget(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
       TextWidget(
        text: "Let our Instructor to help you",//معلومات کے لئے مائک کی بٹن پر کلک کریں
        fontSize: 13,
      ),
      const Icon(Icons.arrow_forward,size: 20.0,),
      voiceMessageButton(false),
    ],
  );
}

CupertinoButton voiceMessageButton(bool isVisible) {

  return CupertinoButton(
      padding: EdgeInsets.zero,
        onPressed: () {
          isVisible=!isVisible;
        },
        child:  Icon(
          isVisible?Icons.record_voice_over: Icons.voice_over_off,
          size: 45,
          color: Colors.white,
        ));
}

class AlertDialogWidget extends StatelessWidget {
  final String message;
  final String onCancelName;
  final String onDeleteName;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  const AlertDialogWidget({
    required this.message,
    required this.onCancelName,
    required this.onDeleteName,
    required this.onCancel,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmation'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: onCancel,
          child: Text(onCancelName),
        ),
        TextButton(
          onPressed: onDelete,
          child: Text(onDeleteName),
        ),
      ],
    );
  }
}



/// Chat card
class ChatUserCard extends StatefulWidget {
  final UserModelClass userModelClass;

    const ChatUserCard({
     Key? key,

     required this.userModelClass
  }) :super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //last message info (if null --> no message)


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(2.0),
       color: Colors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_)=>
                ChatRoomScreen(userModelClass: widget.userModelClass,)));
          },
          child: ListTile(
            leading: CachedNetworkImage(
              imageUrl: widget.userModelClass.imageUrl.toString(),
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
              placeholder: (context, url) => const CircularProgressIndicator(), // Show loading indicator
              errorWidget: (context, url, error) => const Icon(Icons.error), // Show error icon if image fails to load
            ),
              title: Text(widget.userModelClass.name ??''),
              subtitle: Text(widget.userModelClass.city ??'',),
              trailing: const Text("12:00 PM",style: TextStyle(color: Colors.black26),),
          )
      ),
    );
  }
}


class WorkerCard extends StatefulWidget {

   final UserModelClass userModelClass;
final WorkerSkillsDataModelClass workerSkills;

   const WorkerCard({Key? key,

    required this.userModelClass,
     required this.workerSkills
  }) : super(key: key);

  @override
  State<WorkerCard> createState() => _WorkerCardState();
}

class _WorkerCardState extends State<WorkerCard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewProfile(userModelClass: widget.userModelClass, workerModelClass: widget.workerSkills)));
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.userModelClass.imageUrl??'',
                          imageBuilder: (context, imageProvider) =>  Container(
                            width: width*(2/8),
                            height: height*(0.1),
                            decoration:  BoxDecoration(
                              borderRadius: const BorderRadius.only( topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(widget.userModelClass.imageUrl??''),
                              ),
                            ),
                          ),
                          placeholder: (context, url) => const CircularProgressIndicator(), // Show loading indicator
                          errorWidget: (context, url, error) => const Icon(Icons.error), // Show error icon if image fails to load
                        ),

                        Container(
                          width: width*(3/8),
                          height: height*(2/19),
                          padding: const EdgeInsets.only(top: 20),
                          margin: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(text: widget.userModelClass.name??'', fontSize: 13,isBold: true,),
                              const SizedBox(height: 5,),
                              TextWidget(text: widget.workerSkills.workCategory??'',),
                            ],
                          ),
                        ),
                        Container(
                            height: 30,width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.blue,
                            ),
                            child: Center(child: TextWidget(text: "Hire",isBold: true,color: Colors.white,))
                        ),
                      ],
                    ),
                  ),
                ),
              );
        }
}



/*
* ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 10,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){

                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                    child: Row(
                      children: [
                        Container(
                          width: Width*(2/8),
                          height: Height*(0.1),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only( topLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/konnectjob-95430.appspot.com/o/Images%2F1714739929555955?alt=media&token=454f4da4-ecc7-454c-9d86-1a675dd89418"),
                            ),
                          ),
                        ),
                        Container(
                          width: Width*(3/8),
                          height: Height*(2/19),
                          padding: const EdgeInsets.only(top: 20),
                          margin: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(text: "Saqlain Aly Shah", fontSize: 13,isBold: true,),
                              const SizedBox(height: 5,),
                              TextWidget(text: "Electrician",),
                            ],
                          ),
                        ),
                        Container(
                            height: 30,width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.blue,
                            ),
                            child: Center(child: TextWidget(text: "Hire",isBold: true,color: Colors.white,))
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),*/