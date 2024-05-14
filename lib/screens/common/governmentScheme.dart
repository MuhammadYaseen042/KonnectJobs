import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../firbase_Services/modelClasses/job.dart';
import '../../widgets/widgets_components.dart';

class GovernmentSchemes extends StatefulWidget {
  const GovernmentSchemes({super.key});

  @override
  State<GovernmentSchemes> createState() => _GovernmentSchemesState();
}

class _GovernmentSchemesState extends State<GovernmentSchemes> {
 List<GovernmentSchemesModel>? govermentSchemes;

 Future<void> _launchUrl(String url) async {
   if (!await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication)) {
   }else{
     throw Exception('Could not launch $url');

   }
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarWhiteTitle("Government Schemes"),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color(0xff0077B5),
        elevation: 0.0,
      ),
      body: Column(
        children: [
      StreamBuilder(
      stream: FirebaseFirestore.instance.collection("schemes").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No data found'));
        } else {
          //var data= snapshot.data?.docs;
           govermentSchemes = snapshot.data!.docs.map((e) => GovernmentSchemesModel.fromJSON(e.data())).toList();
           print(govermentSchemes);
         return Flexible(
           child: ListView.builder(
             itemCount: govermentSchemes?.length,
               itemBuilder: (context, index){
               return Card(
                 margin: EdgeInsets.all(5.0),
                 color: const Color(0xFFE2F4FF),
                 elevation: 0.5,
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                 child: ListTile(
                   onTap: (){
                     _launchUrl(govermentSchemes![index].link.toString());
                   },
                   leading: CachedNetworkImage(
                     imageUrl: govermentSchemes?[index].image ?? '',
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
                   title: TextWidget(text:govermentSchemes?[index].title ?? '',fontSize: 14,isBold: true,),
                   subtitle: Container(
                     margin: EdgeInsets.only(top: 8.0), // Optional: Adjust the top margin
                     child: Text(
                       govermentSchemes?[index].description ?? '',
                       maxLines: 4, // Limit to 4 lines
                       overflow: TextOverflow.ellipsis, // Handle overflow text
                     ),
                   ),
                 ),
               );

               }
           ),
         );
        }
      },
    )
        ],
      ),
    );
  }
}
