import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';

import '../../Api/apimethods.dart';
import 'payment_creditCard.dart';

class PaymentWay extends StatefulWidget {
  final String contentId;

  const PaymentWay({super.key, required this.contentId});

  @override
  State<PaymentWay> createState() => _PaymentWayState();
}

class _PaymentWayState extends State<PaymentWay> {
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null; // No image selected
  }

  void onE_Wallet() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        File? selectedImage; // Local variable for selected image

        return StatefulBuilder(
          // To update UI inside AlertDialog
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Image.asset('assets/E_wallet.jpg'),
              content: Center(
                child: selectedImage != null
                    ? Center(
                        child: Container(
                        child: Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      ))
                    : IconButton(
                        onPressed: () async {
                          // Pick image asynchronously
                          final image = await pickImage();
                          setState(() {
                            selectedImage = image;
                          });
                        },
                        icon: const Icon(
                          Icons.cloud_upload,
                          size: 40,
                          color: Color(0xFF427D9D),
                        ),
                      ),
              ),
              actions: [
                if (selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Image Selected!",
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 140.50,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: selectedImage == null
                              ? null // Disable button if no image is selected
                              : () async {
                                  // Call API to initiate payment
                                  await ApisMethods.initiateEWalletPayment(
                                    contentId: widget
                                        .contentId, // Replace with actual content ID
                                    paymentImage: selectedImage!,
                                  );
                                  Future.delayed(const Duration(seconds: 3),
                                      () {
                                    Navigator.pop(context);
                                    Navigator.pop(
                                        context); // Close the dialog after 3 seconds
                                  });
                                  // Close the dialog after payment
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF427D9D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Pay Fees',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'IBM Plex Mono',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SizedBox(
                        width: 140.50,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF427D9D)),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFF427D9D)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF427D9D),
                              fontSize: 16,
                              fontFamily: 'IBM Plex Mono',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void onCash() async {
    await ApisMethods.initiateCashPayment(contentId: widget.contentId);
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Payment'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 21,
            ),
            Text(
              'Choose Payment method',
              style: GoogleFonts.ibmPlexMono(
                color: const Color(0xFF164863),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 21,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentCreditCardScreen(
                              contentId: widget.contentId,
                            )));
              },
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFEAECF0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                leading: Image.asset('assets/visa.png'),
                title: Text(
                  'Visa or credit card',
                  style: GoogleFonts.ibmPlexMono(
                    color: const Color(0xFF164863),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () {
                onE_Wallet();
              },
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFEAECF0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                leading: Image.asset('assets/wallet.png'),
                title: Text(
                  'E-wallet',
                  style: GoogleFonts.ibmPlexMono(
                    color: const Color(0xFF164863),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 21,
            ),
            GestureDetector(
              onTap: () {
                onCash();
              },
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFEAECF0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                leading: Image.asset('assets/cash.png'),
                title: Text(
                  'Cash',
                  style: GoogleFonts.ibmPlexMono(
                    color: const Color(0xFF164863),
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
