import 'package:flutter/material.dart';
import 'package:le_chef/Api/apimethods.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentCreditCardScreen extends StatefulWidget {
  final String contentId;
  PaymentCreditCardScreen({super.key, required this.contentId});
  @override
  _PaymentCreditCardScreenState createState() =>
      _PaymentCreditCardScreenState();
}

class _PaymentCreditCardScreenState extends State<PaymentCreditCardScreen> {
  String? _paymentUrl;

  Future<void> initiatePayment() async {
    try {
      final response = await ApisMethods.initiateCreditCardPayment(
        contentId: widget.contentId,
      );

      setState(() {
        _paymentUrl = response['paymentURL'];
      });

      if (_paymentUrl != null) {
        // Automatically open the payment URL
        _launchPaymentUrl(_paymentUrl!);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _launchPaymentUrl(String url) async {
    final encodedUrl = Uri.encodeFull(url); // Encode the URL
    print('Launching: $encodedUrl');
    if (await canLaunch(encodedUrl)) {
      await launch(
        encodedUrl,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $encodedUrl';
    }
  }

  @override
  void initState() {
    super.initState();
    initiatePayment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Redirecting to Payment')),
      body: Center(
        child: CircularProgressIndicator(), 
      ),
    );
  }
}
