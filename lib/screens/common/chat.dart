import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:konnectjob/firbase_Services/apis.dart';
import 'package:konnectjob/firbase_Services/firebase_auth_funtions.dart';
import '../../firbase_Services/modelClasses/job.dart';
import '../../firbase_Services/modelClasses/message.dart';
import '../../firbase_Services/modelClasses/user.dart';
import '../../widgets/widgets_components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatScreen extends StatefulWidget {

  const ChatScreen({Key? key,
  }):super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchCon = TextEditingController();
  List<UserModelClass> userClassList=[];

  /// for searching
  List<UserModelClass> searchUser=[];

  bool isSearching=false;

  String? currentUserId;

  getCurentUser(){
    FirebaseAuthService auth = FirebaseAuthService();
    String? id = APIs.user.uid;
    setState(() {
      currentUserId = id;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurentUser();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations langLocal = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: appBarWhiteTitle(
          langLocal.chat,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color(0xff0077B5),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldWidget(
              trailingFn: () {
                _searchCon.clear();
              },
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
                searchUser.clear();

                for(var i in userClassList){
                  if(i.name!.toLowerCase().contains(val.toLowerCase())){
                    searchUser.add(i);
                  }
                  setState(() {
                    searchUser;
                  });
                }

              },
            ),
            sizedBoxH10,
            TextWidget(
              text: langLocal.messages,
              fontSize: 15,
              isBold: true,
            ),
            sizedBoxH10,
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Users").where("userId",isNotEqualTo: APIs.user.uid).snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final dataList = snapshot.data?.docs;
                      userClassList = dataList
                          ?.map((e) => UserModelClass.fromJSON(e.data()))
                          .toList() ?? [];
                      if (userClassList.isNotEmpty) {
                        return ListView.builder(
                          itemCount: isSearching? searchUser.length: userClassList.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            /// call message card
                            return ChatUserCard(
                              userModelClass: isSearching?searchUser[index]: userClassList[index],
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: TextWidget(
                            text: "No user found!",
                            isBold: true,
                          ),
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),

      ),
    );
  }
}

///Chat Room Screen
class ChatRoomScreen extends StatefulWidget {
  final UserModelClass userModelClass;
  const ChatRoomScreen({Key? key, required this.userModelClass})
      : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  List<Message> messageList = [];

  final TextEditingController _sendMessageCon = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            title: Row(
              children: [
                CachedNetworkImage(
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
                      radius: 20, // You can adjust the radius of the circle avatar
                      backgroundImage: imageProvider, // Set the image provider directly
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(), // Show loading indicator
                  errorWidget: (context, url, error) => const Icon(Icons.error), // Show error icon if image fails to load
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    widget.userModelClass.name ?? '',
                  ),
                ),
              ],
            ),
            actions: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  /// phone call
                  FlutterPhoneDirectCaller.callNumber(widget.userModelClass.phoneNumber!);
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(
                    Icons.call,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
            centerTitle: true,
            titleTextStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            backgroundColor: const Color(0xff0077B5),
            elevation: 0.0,
          ),
          body: Padding(
            padding: const EdgeInsets.only(bottom: 100, top: 10),
            child: StreamBuilder(
              stream: APIs.getAllMessages(widget.userModelClass),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    messageList = data
                        ?.map((e) => Message.fromJson(e.data()))
                        .toList() ??
                        [];


                    if (messageList.isNotEmpty) {
                      return ListView.builder(
                          itemCount: messageList.length,
                          padding: const EdgeInsets.all(10.0),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) =>
                           MessageCard(message: messageList[index])
                             );
                    } else {
                      return Center(
                          child: TextWidget(
                              text: "Say Hi👋 Aly!",
                              fontSize: 18,
                              isBold: true));
                    }
                }
              },
            ),
          ),
          bottomSheet: SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.add,
                    color: Color(0xff0077B5),
                    size: 30,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: _sendMessageCon,
                        expands: true,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          // hintMaxLines: 10,
                          hintText: "Type Something.......",
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      if(_sendMessageCon.text.isNotEmpty){
                        APIs.sendMessage(widget.userModelClass, _sendMessageCon.text.toString());
                        _sendMessageCon.clear();
                        
                      }else{
                        print("Print Null meessage");
                      }
                    },
                    child: const Icon(
                      Icons.send,
                      color: Color(0xff0077B5),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

/// Message Card
class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({
    Key? key,
    required this.message,
  });

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return FirebaseAuthService.user.uid == widget.message.fromId
        ? senderMessage()
        : receiverMessage();
  }

  ///sender or user message
  Widget receiverMessage() {
    if(widget.message.read.isNotEmpty){
      APIs.updateMessageReadStatus(widget.message);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
      child: Row(
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(left: 10, right: 150),
              decoration: const BoxDecoration(
                  color: Color(0xFFE2F4FF),
                  // border: Border.all(
                  //   color: Colors.black,
                  // ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Text(
                widget.message.msg,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: TextWidget(
              text: MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
              fontSize: 13, color: Colors.black54,
            ),
          )
        ],
      ),
    );
  }

  Widget senderMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if(widget.message.read.isNotEmpty)
          const Icon(Icons.done_all_sharp,color: Colors.blue,size:
            15,),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextWidget(
              text: MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
              fontSize: 13, color: Colors.black54,
            ),
          ),

          Flexible(
            child: Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color:  const Color(0xff0077B5),
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Text(
                widget.message.msg,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
