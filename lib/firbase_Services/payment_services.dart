import 'package:cloud_firestore/cloud_firestore.dart';

import 'modelClasses/payment.dart';

class TransferMoneyService {
  final CollectionReference _transferMoneyCollection =
  FirebaseFirestore.instance.collection('transfer_money_requests');

  // Add a new transfer money record
  Future<void> addTransferMoney(TransferMoneyModel transferMoneyModel) async {
    await _transferMoneyCollection.add(transferMoneyModel.toJSON());
  }

/*  // Get all transfer money records
  Stream<List<TransferMoney>> getTransferMoney() {
    return _transferMoneyCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => TransferMoney.fromJSON(doc.data()))
        .toList());
  }*/

  // Update an existing transfer money record
/*  Future<void> updateTransferMoney(,TransferMoney transferMoney) async {
    await _transferMoneyCollection
        .doc(transferMoney.id)
        .update(transferMoney.toJSON());
  }*/

  // Delete a transfer money record
 /* Future<void> deleteTransferMoney(String transferMoneyId) async {
    await _transferMoneyCollection.doc(transferMoneyId).delete();
  }*/
}


/// Withdraw money requests
class WithdrawMoneyRequestServices {
  final CollectionReference _transferMoneyCollection =
  FirebaseFirestore.instance.collection('withdraw_money_requests');

  // Add a new transfer money record
  Future<void> addWithdrawRequests(
      WithDrawMoneyRequestsModel withDrawMoneyRequestsModel) async {
    await _transferMoneyCollection.add(withDrawMoneyRequestsModel.toJSON());
  }
}