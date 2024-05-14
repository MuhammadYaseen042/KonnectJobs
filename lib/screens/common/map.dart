import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:konnectjob/firbase_Services/firebase_crud_funtions.dart';
import 'package:konnectjob/firbase_Services/modelClasses/user.dart';
import 'package:konnectjob/screens/common/chat.dart';

import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;



/// this can be used for both side
/// if user is employer then he can  view workers on map,
/// if user is worker then  he can see jobs on map.

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  // AuthController authController = Get.find<AuthController>();
  final Completer<GoogleMapController> _controller = Completer();

  static const kPlACES_API_KEY = "AIzaSyCqnVZG59mquZ8GCSr-0C6Ujvl3rw1mHOg";

  static const CameraPosition _KGooglePlex = CameraPosition(
      target: LatLng(33.783029199247075, 72.35289827351733), zoom: 14.4746);

//Polyline
  LatLng? source;
  LatLng? destination;
  List<LatLng> polylineCoordinates = [];

  double stAddressLat = 0.0;
  double stAddressLong = 0.0;
  String _sessionToken = "112233";
  List<dynamic> _placesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //authController.getUserInfo();
    _marker.addAll(_list);
    _circle.addAll(_list1);

    getCurrentLocation();
   getUsers();
    //getUsersLocation();
  }
  List<UserModelClass>? userModelList;
  getUsers() async{

    FirebaseUserServices db= FirebaseUserServices();

      userModelList=await db.getAllUsers();
      setState(() {
        userModelList;
        print("First latitdue ============>>>>${userModelList?[0].longitude}");

      });


  }


  void onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(destinationController.text);
    polylineCoordinates.clear();
  }

  void getSuggestion(String input) async {
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPlACES_API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    //print(response.body.toString());
    if (response.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception("Failed to load data");
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final List<Marker> _marker = [];
  final List<Circle> _circle = [];
  final List<Marker> _list = [

    const Marker(
      markerId: MarkerId('geo_fense_1'),
      position: LatLng(33.777887165258456, 72.35111511045322),
      infoWindow: InfoWindow(title: 'Railway Station'),
    ),
    // const Marker(
    //   markerId: MarkerId('2'),
    //   position: LatLng(35.920834, 74.308334),
    //   infoWindow: InfoWindow(title: 'Gilgit'),
    // ),
  ];

  //Geofencing location
  LatLng? geoFenceLocation = const LatLng(33.7831924, 72.3515611);
  final List<Circle> _list1 = [

  /*  Circle(
      circleId: const CircleId('COMSATS'),
      center: const LatLng(33.7831924, 72.3515611),

      ///to change size of circle
      radius: 500,
      strokeWidth: 2,
      strokeColor: Colors.green,
      fillColor: Colors.green.withOpacity(0.15),
    ),*/

  ];

  //Get current Location function

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true);
  }

  LatLng? currentLocation;

//Audio Player Initializzer
  //final _player = AudioPlayer();
  void getCurrentLocation() {
    _determinePosition().then((value) async {
      currentLocation = LatLng(value.latitude, value.longitude);
      var distanceBetween = haversineDistance(
          LatLng(currentLocation!.latitude, currentLocation!.longitude),
          LatLng(geoFenceLocation!.latitude, geoFenceLocation!.longitude));
      print('distance between... ${distanceBetween}');
      if (distanceBetween < 1000) {
        print('user reached to the destination...');

      }
    });
  }

  var uuid = const Uuid();

  // variable for suggested place
  String place = '';

  /// Haversine Distance function that will calculate the distance betweent
  /// two coordinates and return the shortest distance between these two points in meters
  /// player1 will be our source and player2 will be destination LatLng
  dynamic haversineDistance(LatLng player1, LatLng player2) {
    double lat1 = player1.latitude;
    double lon1 = player1.longitude;
    double lat2 = player2.latitude;
    double lon2 = player2.longitude;

    //var R = 6371e3; // metres
    var R = 1000;
    var phi1 = (lat1 * pi) / 180; // φ, λ in radians
    var phi2 = (lat2 * pi) / 180;
    var deltaPhi = ((lat2 - lat1) * pi) / 180;
    var deltaLambda = ((lon2 - lon1) * pi) / 180;

    var a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);

    var c = 2 * atan2(sqrt(a), sqrt(1 - a));

    var d = R * c; // in metres

    return d;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      // drawer: buildDrawer(),
      body: Stack(children: [
        //map display function
        GoogleMap(
          zoomControlsEnabled: false,
          myLocationEnabled: false,
          compassEnabled: false,
          initialCameraPosition: _KGooglePlex,
          markers: Set<Marker>.of(_marker),
          circles: Set<Circle>.of(_circle),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          polylines: {
            Polyline(
              polylineId: const PolylineId("route"),
              points: polylineCoordinates,
              color: Colors.purple,
              width: 6,
            ),
          },
        ),
        //mapProfileTile(),
        mapSearchTextField(),
        //current location button
        //mapNotificationIcon(),
      ]),
      floatingActionButton:  GestureDetector(
          onTap: () async {
            getCurrentLocation();
            print("current location pressed");
             _determinePosition().then((value) async {
               print("latvalue "+value.toString());


               for(int i=0; i<userModelList!.length; i++){

                 _marker.add(Marker(
                   onTap: (){

                     Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatRoomScreen(userModelClass: userModelList![i])));
                   },
                   markerId:  MarkerId("user$i"),
                   position: LatLng(double.parse(userModelList![i].latitude.toString()??''),
                     double.parse(userModelList![i].longitude.toString()??''), ),
                   infoWindow:  InfoWindow(title: "${userModelList![i].name}"),
                 ));

               }
               _marker.add(Marker(
                 markerId:  const MarkerId("Me"),
                 position: LatLng(value.latitude,
                   value.longitude ),
                 infoWindow: const InfoWindow(title: "My Location"),
               ));
              source = LatLng(value.latitude, value.longitude);

              _circle.add(
                Circle(
               circleId: const CircleId("1"),
              center: LatLng(value.latitude, value.longitude),
                   radius: 1500,
                   strokeWidth: 1,
                  fillColor: const Color(0xFF006491).withOpacity(0.2),
                ),
               );
              // polylineCoordinates.add(
              //   LatLng(value.latitude, value.longitude),
              // );

              CameraPosition cameraPosition1 = CameraPosition(
                  target: LatLng(value.latitude, value.longitude), zoom: 14.0);

              final GoogleMapController controller = await _controller.future;

              setState(() {
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(cameraPosition1));
              });
            });
          },
          child: const Icon(Icons.location_on,size: 70,)
        //mapCurrentLocationIcon(),
      ),
    );
  }



  TextEditingController destinationController = TextEditingController();
  bool showSourceField = false;

  Widget mapSearchTextField() {
    return Positioned(
      top: 10,
      left: 20,
      right: 20,
      child: Container(
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 2,
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: TextFormField(
            controller: destinationController,
            readOnly: false,
            onTap: () async {
            _marker.add(
                Marker(
                  markerId: const MarkerId("destination"),
                  position: LatLng(stAddressLat, stAddressLong),
                  infoWindow: const InfoWindow(title: "searched workers"),
                ),
              );
              CameraPosition cameraPosition1 = CameraPosition(
                  target: LatLng(stAddressLat, stAddressLong), zoom: 14.0);
              final GoogleMapController controller = await _controller.future;

              setState(() {
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(cameraPosition1));
                //print("animating search place");
              });
            },
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.6),
            ),
            //AppColors.greyColor),
            decoration: InputDecoration(
              fillColor: Colors.teal,
              border: InputBorder.none,
              hintText: 'Search ',
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.3),
              ),
              suffixIcon: const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.search,
                  color: Colors.teal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}