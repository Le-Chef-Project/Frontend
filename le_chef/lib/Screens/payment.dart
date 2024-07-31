import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:le_chef/Shared/custom_elevated_button.dart';
import 'package:le_chef/Shared/custom_outlined_button.dart';
import 'package:le_chef/theme/custom_button_style.dart';
import '../Shared/custom_app_bar.dart';
import '../theme/custom_text_style.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  bool isCvvFocused = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: "Payment"),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              CreditCardWidget(
                glassmorphismConfig: Glassmorphism.defaultConfig(),
                cardNumber: cardNumberController.text,
                expiryDate: expiryDateController.text,
                cardHolderName: nameController.text,
                cvvCode: cvvController.text,
                showBackView: isCvvFocused,
                cardBgColor: const Color.fromRGBO(66, 125, 157, 1),
                obscureCardCvv: true,
                obscureCardNumber: true,
                onCreditCardWidgetChange: (CreditCardBrand) {},
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CreditCardForm(
                      formKey: formKey, // Required
                      cardNumber: cardNumberController.text, // Required
                      expiryDate: expiryDateController.text, // Required
                      cardHolderName: nameController.text, // Required
                      cvvCode: cvvController.text, // Required
                      onCreditCardModelChange:
                          onCreditCardModelChange, // Required
                      obscureCvv: true,
                      obscureNumber: true,
                      isHolderNameVisible: true,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                      enableCvv: true,
                      cvvValidationMessage: 'Please input a valid CVV',
                      dateValidationMessage: 'Please input a valid date',
                      numberValidationMessage: 'Please input a valid number',
                      cardNumberValidator: (String? cardNumber) {
                        return null;
                      },
                      expiryDateValidator: (String? expiryDate) {
                        return null;
                      },
                      cvvValidator: (String? cvv) {
                        return null;
                      },
                      cardHolderValidator: (String? cardHolderName) {
                        return null;
                      },
                      onFormComplete: () {
                        // callback to execute at the end of filling card data
                      },
                      autovalidateMode: AutovalidateMode.always,
                      disableCardNumberAutoFillHints: false,
                      inputConfiguration: const InputConfiguration(
                        cardNumberDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                        ),
                        expiryDateDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Expired Date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Card Holder',
                        ),
                        cardNumberTextStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        cardHolderTextStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        expiryDateTextStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        cvvCodeTextStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomElevatedButton(
                          height: 41,
                          width: 161,
                          text: "Validate",
                          buttonStyle: CustomButtonStyles.fillPrimaryTL5,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              print('Valid');
                            } else {
                              print('Invalid');
                            }
                          },
                        ),
                        CustomOutlinedButton(
                          buttonTextStyle: CustomTextStyles.bodyLargeff0e7490,
                          text: "Cancel",
                          width: 161,
                          margin: const EdgeInsets.only(left: 8),
                          buttonStyle: CustomButtonStyles.outlinePrimaryTL51,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumberController.text = creditCardModel.cardNumber;
      nameController.text = creditCardModel.cardHolderName;
      expiryDateController.text = creditCardModel.expiryDate;
      cvvController.text = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
