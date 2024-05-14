import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:konnectjob/firbase_Services/firebase_auth_funtions.dart';
import 'package:konnectjob/firbase_Services/modelClasses/job.dart';
import 'package:konnectjob/firbase_Services/modelClasses/user.dart';

class FirebaseUserServices {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('Users');

  Future<String> registerUser(
      String userId, UserModelClass userModelClass) async {
    try {
      // Assuming userId is part of the UserModelClass
      DocumentReference docRef = _userCollection.doc(userId);
      // Set the data with the custom document ID
      await docRef.set(userModelClass.toJSON());

      // Return the custom document ID
      return userId;
    } catch (e) {
      print("Error uploading user data: $e");
      throw e;
    }
  }

  getUserById(String userId) async {
    try {
      DocumentSnapshot snapshot = await _userCollection.doc(userId).get();

      if (snapshot.exists) {
        return UserModelClass.fromJSON(snapshot.data() as Map<String, dynamic>);
      } else {
        // User with the provided ID does not exist
        return "No user found";
      }
    } catch (e) {
      print("Error fetching user: $e");
      throw e; // Rethrow the error for handling in the UI
    }
  }

  Future<void> updateUser(String userId, UserModelClass updatedData) async {
    try {
      await _userCollection.doc(userId).update(updatedData.toJSON());
    } catch (e) {
      print("Error updating client details: $e");
      throw e; // Rethrow the error for handling in the UI
    }
  }

  /// add subcollection

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsersData(
      String userId) {
    return FirebaseFirestore.instance
        .collection("Users")
        .where("userId", isEqualTo: userId)
        .snapshots();
  }

  Future<List<UserModelClass>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await _userCollection.get();
      List<UserModelClass> users = [];
      snapshot.docs.forEach((doc) {
        users.add(UserModelClass.fromJSON(doc.data() as Map<String, dynamic>));
      });
      return users;
    } catch (e) {
      print("Error fetching clients: $e");
      throw e; // Rethrow the error for handling in the UI
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _userCollection.doc(userId).delete();
    } catch (e) {
      print("Error deleting worker: $e");
      throw e; // Rethrow the error for handling in the UI
    }
  }
}

///FIREBASE Workers Services
class FirebaseWorkersServices {
  final CollectionReference _workersCollection =
      FirebaseFirestore.instance.collection('Workers');

  Future<String> registerWorker(String userId,
      WorkerSkillsDataModelClass workerSkillsDataModelClass) async {
    try {
      // Assuming userId is part of the UserModelClass
      DocumentReference docRef = _workersCollection.doc(userId);

      // Set the data with the custom document ID
      await docRef.set(workerSkillsDataModelClass.toJSON());

      // Return the custom document ID
      return userId;
    } catch (e) {
      print("Error uploading user data: $e");
      throw e;
    }
  }

  Future<void> updateWorker(
      String workerId, Map<String, dynamic> updatedData) async {
    try {
      await _workersCollection.doc(workerId).update(updatedData);
    } catch (e) {
      print("Error updating worker details: $e");
      throw e; // Rethrow the error for handling in the UI
    }
  }

  Future<List<UserModelClass>> getAllWorkers() async {
    try {
      QuerySnapshot snapshot = await _workersCollection.get();
      List<UserModelClass> workers = [];
      snapshot.docs.forEach((doc) {
        workers
            .add(UserModelClass.fromJSON(doc.data() as Map<String, dynamic>));
      });
      return workers;
    } catch (e) {
      print("Error fetching workers: $e");
      throw e; // Rethrow the error for handling in the UI
    }
  }

  Future<void> deleteWorker(String workerId) async {
    try {
      await _workersCollection.doc(workerId).delete();
    } catch (e) {
      print("Error deleting worker: $e");
      throw e; // Rethrow the error for handling in the UI
    }
  }
}

///Firebase Job services
class FirebaseJobsServices {
  final CollectionReference _jobsCollection =
      FirebaseFirestore.instance.collection('Jobs');

  Future<void> createJob(JobModelClass jobModelClass) async {
    try {
      // Upload job document to jobs collection
      DocumentReference docRef =
          await _jobsCollection.add(jobModelClass.toJSON());
    } catch (e) {
      print("Error uploading job details: $e");
      throw e; // Rethrow the error for handling in the UI
    }
  }

  Future<void> updateJobDetails(
      String jobId, Map<String, dynamic> updatedData) async {
    try {
      await _jobsCollection.doc(jobId).update(updatedData);
    } catch (e) {
      print("Error updating job details: $e");
      throw e; // Rethrow the error for handling in the UI
    }
  }

  Future<List<JobModelClass>> getAllJobs() async {
    try {
      QuerySnapshot snapshot = await _jobsCollection.get();
      List<JobModelClass> jobs = [];
      snapshot.docs.forEach((doc) {
        jobs.add(JobModelClass.fromJSON(doc.data() as Map<String, dynamic>));
      });
      return jobs;
    } catch (e) {
      print("Error fetching jobs: $e");
      throw e; // Rethrow the error for handling in the UI
    }
  }

  Future<void> deleteJob(String jobId) async {
    try {
      await _jobsCollection.doc(jobId).delete();
    } catch (e) {
      print("Error deleting job: $e");
      throw e; // Rethrow the error for handling in the UI
    }
  }

  Future<String?> getDocumentIds() async {
    String? documentId;
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Jobs').get();
      querySnapshot.docs.forEach((doc) {
        // Access the document ID using the id property
        documentId = doc.id;

        // Now you can use the document ID as needed
        print('Document ID==========?>>>>>>>: $documentId');
      });
      return documentId;
    } catch (e) {
      print('Error getting documents: $e');
      return null;
    }
  }
}

/// saved jobs
class FirebaseSavedJobService {
  final CollectionReference _savedJobCollection =
      FirebaseFirestore.instance.collection('SavedJobs');

  Future<void> savedJob(SavedJobsModelClass savedJobsModelClass) async {
    try {
      // Upload job document to jobs collection
      DocumentReference docRef =
          await _savedJobCollection.add(savedJobsModelClass.toJSON());
    } catch (e) {
      print("Error uploading job details: $e");
      throw e; // Rethrow the error for handling in the UI
    }
  }

  Future<List<SavedJobsModelClass>> getSavedJobs() async {
    List<SavedJobsModelClass> savedJobs = [];
    try {
      // Query the collection for saved jobs
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('SavedJobs').get();

      // Iterate over the documents and parse them into SavedJobsModelClass instances
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        SavedJobsModelClass savedJob =
            SavedJobsModelClass.fromJSON(data as Map<String, dynamic>);
        savedJobs.add(savedJob);
      });

      print('Retrieved ${savedJobs.length} saved jobs');
    } catch (e) {
      print('Error retrieving saved jobs: $e');
    }

    return savedJobs;
  }

  Future<void> deleteSavedJob(String jobId) async {
    try {
      await _savedJobCollection.doc(jobId).delete();
    } catch (e) {
      print("Error deleting job: $e");
      throw e; // Rethrow the error for handling in the UI
    }
  }

  Future<void> addToSavedJobs(
      String curentUserId, JobModelClass job, UserModelClass user) async {
    try {
      // Create an instance of SavedJobsModelClass with the job and user instances
      SavedJobsModelClass savedJob = SavedJobsModelClass(
        userId: curentUserId,
        jobModelClass: job,
        userModelClass: user,
      );
      // Convert the savedJob instance to a JSON-compatible map
      Map<String, dynamic> jsonData = savedJob.toJSON();

      // Upload the JSON data to Firebase Firestore
      await FirebaseFirestore.instance.collection('SavedJobs').add(jsonData);

      print('Saved job data uploaded successfully!');
    } catch (e) {
      print('Error uploading saved job data: $e');
    }
  }
}

///Applicants

class ApplicantsService {
  final CollectionReference _applicantsCollection =
      FirebaseFirestore.instance.collection('applicants');

  // Create operation
  Future<void> addApplicant(ApplicantsModel applicant) async {
    try {
      await _applicantsCollection.add(applicant.toJSON());
    } catch (e) {
      print("Error adding applicant: $e");
    }
  }

  // Read operation
  Stream<List<ApplicantsModel>> getApplicants() {
    return _applicantsCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) =>
            ApplicantsModel.fromJSON(doc.data() as Map<String, dynamic>))
        .toList());
  }

  // Update operation
  Future<void> updateApplicant(ApplicantsModel applicant) async {
    try {
      await _applicantsCollection
          .doc(applicant.applicantId)
          .update(applicant.toJSON());
    } catch (e) {
      print("Error updating applicant: $e");
    }
  }

  // Delete operation
  Future<void> deleteApplicant(String id) async {
    try {
      await _applicantsCollection.doc(id).delete();
    } catch (e) {
      print("Error deleting applicant: $e");
    }
  }
}

///Accepted proposals

class FirebaseAcceptedApplicationsService {
  final CollectionReference db =
      FirebaseFirestore.instance.collection('acceptedApplications');

  Future<String> addAcceptedApplication(
      AcceptedApplications acceptedApplication) async {
    try {
      // Add the accepted application to Firestore
      DocumentReference doc = await db.add(acceptedApplication.toJSON());
      // Return the document ID generated by Firestore
      return doc.id;
    } catch (e) {
      print("Error adding accepted application: $e");
      throw e;
    }
  }

  Future<void> updateAcceptedApplication(
      String documentId, Map<String, dynamic> updatedData) async {
    try {
      // Update the accepted application in Firestore
      await db.doc(documentId).update(updatedData);
      print('Accepted application updated successfully!');
    } catch (e) {
      print("Error updating accepted application: $e");
      throw e;
    }
  }

  Future<List<AcceptedApplications>> getAllAcceptedApplications() async {
    try {
      // Fetch all accepted applications from Firestore
      QuerySnapshot snapshot = await db.get();
      List<AcceptedApplications> acceptedApplications = [];
      snapshot.docs.forEach((doc) {
        acceptedApplications.add(
            AcceptedApplications.fromJSON(doc.data() as Map<String, dynamic>));
      });
      return acceptedApplications;
    } catch (e) {
      print("Error fetching accepted applications: $e");
      throw e;
    }
  }

  Future<void> deleteAcceptedApplication(String documentId) async {
    try {
      // Delete the accepted application from Firestore
      await db.doc(documentId).delete();
      print('Accepted application deleted successfully!');
    } catch (e) {
      print("Error deleting accepted application: $e");
      throw e;
    }
  }
}
