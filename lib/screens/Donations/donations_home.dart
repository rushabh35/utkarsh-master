import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationsHome extends StatefulWidget {
  const DonationsHome({Key? key}) : super(key: key);

  @override
  _DonateState createState() => _DonateState();
}

class _DonateState extends State<DonationsHome> {
  List<String> ngoNames = []; // List to store NGO names
  String selectedNGO = ''; // Selected NGO name

  Future<void> fetchNGONames() async {
    // Fetch NGO names from Firebase
    QuerySnapshot query = await FirebaseFirestore.instance.collection('NGO').get();

    setState(() {
      ngoNames = query.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  late var _razorpay;
  var amountController = TextEditingController();

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    fetchNGONames();
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print("Payment Done");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("Payment Fail");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donation App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [ 
           SizedBox(
  height: 50, // Set a desired height for the dropdown
  child: DropdownButton<String>(
    value: selectedNGO,
    items: ngoNames.map((String ngoName) {
      return DropdownMenuItem<String>(
        value: ngoName,
        child: Text(ngoName),
      );
    }).toList(),
    onChanged: (String? newValue) {
      setState(() {
        selectedNGO = newValue!;
      });
    },
  ),
),

            const SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter your Amount",
                labelText: "Amount",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                /// Make payment
                var options = {
                  'key': "rzp_test_qdud3n0OBSOfpb",
                  'amount': (int.parse(amountController.text) * 100).toString(),
                  'name': 'Utkarsh',
                  'description': 'Demo',
                  'timeout': 300,
                  'prefill': {
                    'contact': '8108666590',
                    'email': 'rushabhyeole03@gmail.com',
                  },
                };
                _razorpay.open(options);
              },
              child: Text("Pay Amount"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
