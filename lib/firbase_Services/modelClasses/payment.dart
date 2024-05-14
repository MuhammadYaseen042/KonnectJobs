import 'package:konnectjob/firbase_Services/modelClasses/user.dart';

class TransferMoneyModel{
  UserModelClass? currentUser;
  String? receiverName;
  String? receiverCard;
  String? receiverPhoneNumber;
  String? receiverCnic;
  String? amount;


  TransferMoneyModel({
   this.currentUser,
   this.receiverName,
   this.receiverCard,
    this.receiverPhoneNumber,
    this.receiverCnic,
    this.amount,

});

  factory TransferMoneyModel.fromJSON(Map<String,dynamic> json){
    return TransferMoneyModel(
      currentUser: UserModelClass.fromJSON(json['sender']),
      receiverName: json['receiverName'],
      receiverCard: json["receiverCard"],
      receiverCnic: json["receiverCnic"],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender']=this.currentUser!.toJSON();
    data['receiverName']=this.receiverName;
    data['receiverCard']=this.receiverCard;
    data['receiverCnic']=this.receiverCnic;
    data['amount']=this.amount;
    return data;
  }
}


class WithDrawMoneyRequestsModel{
  UserModelClass? currentUser;
  String? card;
  String? amount;

  WithDrawMoneyRequestsModel({
    this.currentUser,
    this.card,
    this.amount,
  });

  factory WithDrawMoneyRequestsModel.fromJSON(Map<String,dynamic> json){
    return WithDrawMoneyRequestsModel(
      currentUser: UserModelClass.fromJSON(json['userInfo']),
      card: json["card"],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userInfo']=this.currentUser!.toJSON();
    data['card']=this.card;
    data['amount']=this.amount;
    return data;
  }
}

