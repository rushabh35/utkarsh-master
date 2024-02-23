import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class DonationsHome extends StatefulWidget {
  final DocumentSnapshot? documentSnapshot; // Make documentSnapshot nullable

  DonationsHome({Key? key, this.documentSnapshot}) : super(key: key); // Optional parameter

  @override
  _DonationsHomeState createState() => _DonationsHomeState();
}

class _DonationsHomeState extends State<DonationsHome> {
  late Razorpay _razorpay;
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Successful: ${response.paymentId}");
    if (widget.documentSnapshot != null) {
      int amount = int.tryParse(amountController.text) ?? 0; // Default to 0 if parsing fails
      if (amount > 0) {
        widget.documentSnapshot!.reference.update({
          "fundsRaised": FieldValue.increment(amount)
        }).then((_) {
          print("Funds raised updated successfully.");
        }).catchError((error) {
          print("Error updating funds raised: $error");
        });
      } else {
        print("Invalid amount entered.");
      }
    } else {
      print("Document snapshot is null, cannot update fundsRaised.");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error: ${response.code} | ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text("Utkarsh"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Enter your amount",
              ),
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              color: Colors.grey,
              child: const Text("Pay Amount"),
              onPressed: _makePayment,
            ),
          ],
        ),
      ),
    );
  }

  void _makePayment() {
    int amount = int.tryParse(amountController.text) ?? 0;
    if (amount <= 0) {
      print("Invalid amount entered.");
      return;
    }
    var options = {
      'key': "rzp_test_qdud3n0OBSOfpb",
      'amount': (amount * 100).toString(), // Convert to the smallest currency unit
      'name': 'Utkarsh',
      'description': 'Donation',
      'prefill': {
        'contact': '8108666590',
        'email': 'email@example.com'
      }
    };
    _razorpay.open(options);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
