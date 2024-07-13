import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import '../Shared/custom_app_bar.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({Key? key}) : super(key: key);

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
        backgroundColor: Colors.black,
        appBar: CustomAppBar(title: "Payment"),
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
                obscureCardCvv: true,
                obscureCardNumber: true,
                cardBgColor: Colors.red,
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
                      cardNumberValidator: (String? cardNumber) {},
                      expiryDateValidator: (String? expiryDate) {},
                      cvvValidator: (String? cvv) {},
                      cardHolderValidator: (String? cardHolderName) {},
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
                          color: Colors.white,
                        ),
                        cardHolderTextStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        expiryDateTextStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        cvvCodeTextStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          print('Valid');
                        } else {
                          print('Invalid');
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        child: Text('Validate'),
                      ),
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
