
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:konnectjob/New%20User/user_details_screen.dart';
import 'package:konnectjob/utils/utils.dart';
import '../New User/user_number_screen.dart';
import 'modelClasses/user.dart';

class FirebaseAuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static User get user=>_auth.currentUser!;

  Future sendOtpOnNumber(BuildContext context, String phoneNumber) async {
    // Show loading indicator
    EventDialogues.showEvent(context, "Sending OTP", "It takes few minutes to send OTP on your Number", "assets/images/loading.json");
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException ex) {
        EventDialogues.showEvent(context, "Failed", "Failed to send OTP on Number", "assets/images/failer.json");
        // Hide loading indicator
        Navigator.pop(context);
      },
      codeSent: (String verificationId, int? resendToken) {
        // Hide loading indicator
        Navigator.pop(context);
        otpShowModelBottomSheet(context, verificationId, phoneNumber);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }


  Future checkOtp(BuildContext context,String verificationId, TextEditingController controller,String phoneNumber) async{
    try{
      PhoneAuthCredential credential= await PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: controller.text.toString()
      );
      _auth.signInWithCredential(credential).then((value) => Navigator.push(context,
          MaterialPageRoute(builder: (_) =>   UserDetails(userPhoneNumber: phoneNumber,))));


    }catch (ex) {
      // If there's an error, handle it accordingly
      print("Error verifying OTP: $ex");
      // For example, you can show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect OTP. Please try again.'),
        ),
      );
      // Or navigate the user to a different screen based on the error
      Navigator.push(context, MaterialPageRoute(builder: (_) => const UserNumber()));
    }
  }


  ///
  Future<String?> getUserIdIfAuthenticated() async {
    try {
      // Check if there's a current user
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // User is authenticated, return user ID
        return currentUser.uid;
      } else {
        // User is not authenticated, show error message or navigate to login screen
        print('User is not authenticated');
        // Example: Navigate to the login screen
        return null;
      }
    } catch (e) {
      print("Error getting user ID: $e");
      throw e;
    }
  }


///
 // Function to sign out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      throw e;
    }
  }

  }
