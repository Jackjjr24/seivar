import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  double _swipePosition = 0.0;
  bool _isPaymentSuccessful = false;

  // ✅ Razorpay instance
  final Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();

    // ✅ Event listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // 👉 Razorpay checkout
  void _openCheckout() {
    var options = {
      'key': 'rzp_test_RDyy8v3NzNhhSc', // 🔑 Replace with your Razorpay Key
      'amount': 1000, // ₹3140 in paise
      'currency': 'INR',
      'name': 'SEIVAR',
      'description': 'user’s SEIVAR pack',
      'prefill': {
        'contact': '9876543210',
        'email': 'testuser@gmail.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e, s) {
      debugPrint('❌ Razorpay open error: $e\n$s');
    }
  }

  // 👉 Callbacks
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      _isPaymentSuccessful = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Payment Successful: ${response.paymentId}")),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Payment Failed: ${response.message}")),
    );
    setState(() {
      _swipePosition = 0.0; // reset swipe
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("💳 External Wallet: ${response.walletName}")),
    );
  }

  // 👉 Swipe logic
  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _swipePosition += details.primaryDelta ?? 0;
      _swipePosition = _swipePosition.clamp(0.0, 320.0);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_swipePosition > 300) {
      _openCheckout(); // ✅ Trigger Razorpay
    } else {
      setState(() {
        _swipePosition = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("SEIVAR",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo)),
            SizedBox(width: 10),
            Icon(Icons.person, color: Colors.indigo),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.indigo),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildBookingSummary(),
            SizedBox(height: 20),
            _buildSuccessMessage(),
            SizedBox(height: 25),
            _buildUPIOptions(),
            SizedBox(height: 20),
            _buildNetBankingButton(),
            SizedBox(height: 20),
            _buildOtherPaymentMethods(),
            Spacer(),
            _buildSwipeToPayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingSummary() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.indigo, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset("assets/dishwashing.jpg",
                width: 70, height: 70, fit: BoxFit.cover),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("user’s SEIVAR pack",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo)),
                SizedBox(height: 5),
                Text("Validity: 10 days",
                    style: TextStyle(fontSize: 14, color: Colors.black)),
                Text("Amount to be paid: ₹10",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.verified, color: Colors.green),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Congrats on saving ₹300 with this booking!",
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUPIOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pay directly with UPI apps",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildUPIButton("assets/gpay.jpg", "GPay"),
            _buildUPIButton("assets/phonepay.jpg", "PhonePe"),
            _buildUPIButton("assets/bhim.png", "BHIM"),
            _buildUPIButton("assets/paytm.png", "Paytm"),
          ],
        ),
      ],
    );
  }

  Widget _buildUPIButton(String imagePath, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildNetBankingButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _openCheckout,
        icon: Icon(Icons.account_balance, color: Colors.white),
        label: Text("Pay with Net Banking",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildOtherPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Other Payment Methods",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ListTile(
          leading: Icon(Icons.money, color: Colors.green),
          title: Text("Pay with Cash"),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Cash payment selected")),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.credit_card, color: Colors.orange),
          title: Text("Credit/ Debit Card"),
          onTap: _openCheckout, // ✅ also trigger Razorpay
        ),
      ],
    );
  }

  Widget _buildSwipeToPayButton() {
    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: Text("Swipe to Pay",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 150),
            left: _swipePosition,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
              ),
              child: Icon(Icons.arrow_forward, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
