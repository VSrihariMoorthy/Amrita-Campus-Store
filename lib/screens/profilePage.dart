import 'package:project/apis/itemAPIs.dart';
import 'package:project/notifiers/authNotifier.dart';
import 'package:project/screens/orderDetails.dart';
import 'package:project/widgets/customRaisedButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late Razorpay _razorpay;
  int money = 0;

  signOutUser() {
    AuthNotifier authNotifier =
    Provider.of<AuthNotifier>(context, listen: false);
    if (authNotifier.user != null) {
      signOut(authNotifier, context);
    }
  }

  @override
  void initState() {
    AuthNotifier authNotifier =
    Provider.of<AuthNotifier>(context, listen: false);
    getUserDetails(authNotifier);
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
    Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              signOutUser();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 30, right: 10),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              width: 100,
              child: const Icon(
                Icons.person,
                size: 70,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            authNotifier.userDetails?.displayName != null
                ? Text(
              authNotifier.userDetails!.displayName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontFamily: 'MuseoModerno',
                fontWeight: FontWeight.bold,
              ),
            )
                : const Text("You don't have a user name"),
            const SizedBox(
              height: 10,
            ),
            authNotifier.userDetails?.balance != null
                ? Text(
              "Balance: ${authNotifier.userDetails?.balance} INR",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'MuseoModerno',
              ),
            )
                : const Text(
              "Balance: 0 INR",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'MuseoModerno',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return popupForm(context);
                    });
              },
              child: CustomRaisedButton(buttonText: 'Add Money'),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Order History",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'MuseoModerno',
              ),
              textAlign: TextAlign.left,
            ),
            myOrders(authNotifier.userDetails?.uuid),
          ],
        ),
      ),
    );
  }

  Widget myOrders(uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('placed_by', isEqualTo: uid)
          .orderBy("is_delivered")
          .orderBy("placed_at", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          List<dynamic> orders = snapshot.data!.docs;
          return Container(
            margin: const EdgeInsets.only(top: 1.0),
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (context, int i) {
                  return GestureDetector(
                    child: Card(
                      child: ListTile(
                          enabled: !orders[i]['is_delivered'],
                          title: Text("Order #${(i + 1)}"),
                          subtitle: Text(
                              'Total Amount: ${orders[i]['total'].toString()} INR'),
                          trailing: Text(
                              'Status: ${(orders[i]['is_delivered']) ? "Delivered" : "Pending"}')),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailsPage(orders[i])));
                    },
                  );
                }),
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            width: MediaQuery.of(context).size.width * 0.6,
            child: const Text(""),
          );
        }
      },
    );
  }

  Widget popupForm(context) {
    int amount = 0;
    return AlertDialog(
        content: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Deposit Money",
                      style: TextStyle(
                        color: Color.fromRGBO(255, 63, 111, 1),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (String? value) {
                        if (int.tryParse(value!) == null) {
                          return "Not a valid integer";
                        } else if (int.parse(value) < 100) {
                          return "Minimum Deposit is 100 INR";
                        } else if (int.parse(value) > 1000) {
                          return "Maximum Deposit is 1000 INR";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: const TextInputType.numberWithOptions(),
                      onSaved: (String? value) {
                        amount = int.parse(value!);
                      },
                      cursorColor: const Color.fromRGBO(255, 63, 111, 1),
                      decoration: const InputDecoration(
                        hintText: 'Money in INR',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(255, 63, 111, 1),
                        ),
                        icon: Icon(
                          Icons.attach_money,
                          color: Color.fromRGBO(255, 63, 111, 1),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          return openCheckout(amount);
                        }
                      },
                      child: CustomRaisedButton(buttonText: 'Add Money'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void openCheckout(int amount) async {
    AuthNotifier authNotifier =
    Provider.of<AuthNotifier>(context, listen: false);
    money = amount;
    var options = {
      'key': 'rzp_test_D5ZAPbZuM494Pw',
      'amount': money * 100,
      'name': authNotifier.userDetails?.displayName,
      'description': "${authNotifier.userDetails?.uuid} - ${DateTime.now()}",
      'prefill': {
        'contact': authNotifier.userDetails?.phone,
        'email': authNotifier.userDetails?.email
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e as String?);
    }
  }

  void toast(String? data) {
    Fluttertoast.showToast(
        msg: data as String,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    AuthNotifier authNotifier =
    Provider.of<AuthNotifier>(context, listen: false);
    addMoney(money, context, authNotifier.userDetails?.uuid);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    toast("ERROR: ${response.code.toString()} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    toast("EXTERNAL_WALLET: ${response.walletName}");
    Navigator.pop(context);
  }
}
