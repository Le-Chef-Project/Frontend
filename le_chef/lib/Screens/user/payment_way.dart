import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Screens/user/payment.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';

class PaymentWay extends StatelessWidget {
  const PaymentWay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Payment'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 21,
            ),
            Text(
              'Choose Payment method',
              style: GoogleFonts.ibmPlexMono(
                color: Color(0xFF164863),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 21,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PaymentScreen()));
              },
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xFFEAECF0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                leading: Image.asset('assets/visa.png'),
                title: Text(
                  'Visa or credit card',
                  style: GoogleFonts.ibmPlexMono(
                    color: Color(0xFF164863),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () {},
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xFFEAECF0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                leading: Image.asset('assets/wallet.png'),
                title: Text(
                  'E-wallet',
                  style: GoogleFonts.ibmPlexMono(
                    color: Color(0xFF164863),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 21,
            ),
            GestureDetector(
              onTap: () {},
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xFFEAECF0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                leading: Image.asset('assets/cash.png'),
                title: Text(
                  'Cash',
                  style: GoogleFonts.ibmPlexMono(
                    color: Color(0xFF164863),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
