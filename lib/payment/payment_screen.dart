import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:konnectjob/firbase_Services/modelClasses/payment.dart';
import 'package:konnectjob/firbase_Services/modelClasses/user.dart';
import 'package:paymob_pakistan/paymob_payment.dart';
import '../firbase_Services/payment_services.dart';
import '../widgets/appbar_drawer.dart';
import '../widgets/widgets_components.dart';


class PaymentScreen extends StatefulWidget {
  final UserModelClass userModelClass;
  const PaymentScreen({Key?key,
  required this.userModelClass,
  }):super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  PaymobResponse? response;

  bool isLoading=false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: appBarWhiteTitle(
          "Payment",
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color(0xff0077B5),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            sizedBoxH20,
            ListTileWidget(
              color: Colors.teal,
              text: "Transfer Money",
              icon: Icons.money,
              onTap: () async {
                transferMoney(context,widget.userModelClass);
              },
              trailingWidget: Icon(Icons.navigate_next),
            ),
            ListTileWidget(
              color: Colors.deepOrange,
              text: "Withdraw Money",
              icon: Icons.monetization_on,
              onTap: (){
              withdrawMoney(context,widget.userModelClass);
              },
              trailingWidget: Icon(Icons.navigate_next),
            ),
          ],
        ),
      ),
    );
  }

  void transferMoney(
      BuildContext context,
      UserModelClass userModelClass,
      ) {
    final TextEditingController _cardNumberCon = TextEditingController();
    final TextEditingController _nameCon = TextEditingController();
    final TextEditingController _cnicCon = TextEditingController();
    final TextEditingController _amount = TextEditingController();
    bool loading = false;
    showModalBottomSheet(
      backgroundColor: Colors.white,


      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20,),
              TextWidget(text: " Receiver Name", fontSize: 14,),
              sizedBoxH10,
              TextFieldWidget(
                textInputType: TextInputType.number,
                controller: _nameCon,
                leadingIcon: Icons.monetization_on,
                hintText: "Name",
              ),
              sizedBoxH20,
              TextWidget(text: "Receiver Account Number", fontSize: 14,),
              sizedBoxH10,
              TextFieldWidget(
                textInputType: TextInputType.number,
                controller: _cardNumberCon,
                leadingIcon: Icons.monetization_on,
                hintText: "1234 5543 4444 2222",
              ),
              sizedBoxH20,
              TextWidget(text: "Receiver CNIC Number", fontSize: 14,),
              sizedBoxH10,
              TextFieldWidget(
                isCNIC: true,
                textInputType: TextInputType.number,
                controller: _cnicCon,
                leadingIcon: Icons.monetization_on,
                hintText: "*****-*******-*",
              ),
              sizedBoxH20,
              TextWidget(text: " Amount", fontSize: 14,),
              sizedBoxH10,
              TextFieldWidget(
                textInputType: TextInputType.number,
                controller: _amount,
                leadingIcon: Icons.monetization_on,
                hintText: "20 PKR",
              ),
              sizedBoxH20,
              ButtonWidget(
                onPress: () async {
                  try {
                    // 1. Validate user input (assuming _amount is a TextEditingController)
                    double amountInCentsDouble = double.tryParse(_amount.text) ?? 0.0;
                    int amountInCents = (amountInCentsDouble * 100).toInt(); // Convert to cents

                    // 2. Consider using recommended jazzcash_flutter package

                    // Assuming PaymobPakistan.instance.initializePayment exists
                    PaymentInitializationResult response = await PaymobPakistan.instance.initializePayment(
                      currency: "PKR",
                      amountInCents: amountInCents.toString(),
                    );

                    String authToken = response.authToken;
                    int orderID = response.orderID;

                    // Assuming PaymobPakistan.instance.makePayment exists
                    PaymobPakistan.instance.makePayment(
                      context,
                      currency: "PKR",
                      amountInCents: amountInCents.toString(),
                      paymentType: PaymentType.card,
                      authToken: authToken,
                      orderID: orderID,
                      onPayment: (response) => setState(() => this.response = response),
                    );
                  } catch (err) {
                    // 3. More specific error handling
                    if (err is FormatException) {
                      print("Error: Please enter a valid amount.");
                    } else {
                      print("Error: An unexpected error occurred. $err");
                    }
                  }
                },
                title: "Transfer Money",
                isloading: loading,
              ),
            ],
          ),
        ),
      ),
    );
  }


  void withdrawMoney(
      BuildContext context,
      UserModelClass userModelClass,
      ) {

    final TextEditingController _cardNumberCon = TextEditingController();
    final TextEditingController _amount = TextEditingController();

    showModalBottomSheet(
      backgroundColor: Colors.white,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20,),
              sizedBoxH20,
              TextWidget(text: "Your Card Number", fontSize: 14,),
              sizedBoxH10,
              TextFieldWidget(
                textInputType: TextInputType.number,
                controller: _cardNumberCon,
                leadingIcon: Icons.person,
                hintText: "12345 3245 55432",
              ),
              sizedBoxH20,
              TextWidget(text: " Enter amount you want to withdraw", fontSize: 14,),
              sizedBoxH10,
              TextFieldWidget(
                textInputType: TextInputType.number,
                controller: _amount,
                leadingIcon: Icons.monetization_on,
                hintText: "20 PKR",
              ),
              sizedBoxH20,
              ButtonWidget(
                onPress: () async {

                 if(_cardNumberCon.text.isNotEmpty && _amount.text.isNotEmpty){
                   try{
                     WithdrawMoneyRequestServices db=WithdrawMoneyRequestServices();
                     WithDrawMoneyRequestsModel data=WithDrawMoneyRequestsModel(
                       currentUser: widget.userModelClass,
                       card: _cardNumberCon.text.toString(),
                       amount: _amount.text.toString(),
                     );
                    await  db.addWithdrawRequests(data).whenComplete(() {

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialogWidget(
                            message: 'Are you sure you want to pay this worker',
                            onCancelName: "Cancel",
                            onCancel: () {
                              // Handle cancel action
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            onDeleteName: "Continue",
                            onDelete: () async{
                              try {
                                // 1. Validate user input (assuming _amount is a TextEditingController)
                                double amountInCentsDouble = double.tryParse(_amount.text) ?? 0.0;
                                int amountInCents = (amountInCentsDouble * 100).toInt(); // Convert to cents

                                // 2. Consider using recommended jazzcash_flutter package

                                // Assuming PaymobPakistan.instance.initializePayment exists
                                PaymentInitializationResult response = await PaymobPakistan.instance.initializePayment(
                                  currency: "PKR",
                                  amountInCents: amountInCents.toString(),
                                );

                                String authToken = response.authToken;
                                int orderID = response.orderID;

                                // Assuming PaymobPakistan.instance.makePayment exists
                                PaymobPakistan.instance.makePayment(
                                  context,
                                  currency: "PKR",
                                  amountInCents: amountInCents.toString(),
                                  paymentType: PaymentType.card,
                                  authToken: authToken,
                                  orderID: orderID,
                                  onPayment: (response) => setState(() => this.response = response),
                                );
                              } catch (err) {
                                // 3. More specific error handling
                                if (err is FormatException) {
                                  print("Error: Please enter a valid amount.");
                                } else {
                                  print("Error: An unexpected error occurred. $err");
                                }
                              }
                            },
                          );
                        },
                      );

                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Thanks we'll procced your payment within 3 days."),
                        ),
                      );


                     }
                    );
                   }catch(e){
                     ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                         content: Text("Error occur."+e.toString()),
                       ),
                     );

                   }
                 }else{
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(
                       content: Text('Fill all required fields'),
                     ),
                   );
                 }
                },
                title: "Send Request",isloading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


