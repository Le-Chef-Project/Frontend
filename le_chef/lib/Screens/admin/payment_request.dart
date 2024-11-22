import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Api/apimethods.dart';
import 'package:le_chef/Models/payment.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';

import '../../Shared/customBottomNavBar.dart';
import '../../main.dart';
import '../chats/chats.dart';
import '../notification.dart';
import 'THome.dart';

class PaymentRequest extends StatefulWidget {
  const PaymentRequest({super.key});

  @override
  State<PaymentRequest> createState() => _PaymentRequestState();
}

class _PaymentRequestState extends State<PaymentRequest> {
  final bool isView = true;
  List<Payment> requests = [];

  final int _selectedIndex = 3;

  @override
  void initState(){
    super.initState();
    getRequests();
  }

  Future<void> getRequests() async {
    try{
      final _requests = await ApisMethods.getAllRequest();
      setState(() {
        requests = _requests;
      });
      print('Total requests loaded: ${requests.length}');
  }catch(e){
      print('Failed to load requests: ${e.toString()}');
    }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Requests'),
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Today',
                  style: GoogleFonts.ibmPlexMono(
                    color: const Color(0xFF083344),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/default_image_profile.jpg'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            requests[index].username,
                            style: GoogleFonts.ibmPlexMono(
                              color: const Color(0xFF164863),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Request for',
                            style: GoogleFonts.ibmPlexMono(
                              color: const Color(0xFF888888),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '"Unit 1 - lesson 3"',
                            style: GoogleFonts.ibmPlexMono(
                              color: const Color(0xFF0E7490),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            requests[index].method,
                            style: GoogleFonts.ibmPlexMono(
                              color: const Color(0xFF0E7490),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              SizedBox(
                                height: 32,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.check, size: 10, color: Colors.white,),
                                  label: Text('Accept', style: GoogleFonts.ibmPlexMono(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2ED573),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 32,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.close, size: 10),
                                  label: Text('Reject', style: GoogleFonts.ibmPlexMono(
                                    color: const Color(0xFF0E7490),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                        side: const BorderSide(
                                          color: Color(0xFF427D9D),
                                          width: 1,
                                        )
                                    ),
                                  ),
                                ),
                              ),
                              if (requests[index].method == 'Mobile Wallet')
                                SizedBox(
                                  height: 32,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(context: context, builder: (context){
                                        return Dialog(
                                          child: Column(
                                            children: [
                                              if(requests[index].paymentImageUrl != null)
                                                Image.network(requests[index].paymentImageUrl!, fit: BoxFit.contain,),
                                              ElevatedButton(onPressed: (){}, child: Text('Ok', style: GoogleFonts.ibmPlexMono(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),), style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF2ED573),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),),
                                            ],
                                          ),
                                        );
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF427D9D),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      'View Item',
                                      style: GoogleFonts.ibmPlexMono(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        onItemTapped: (index) {
          switch (index) {
            case 0:

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => THome()),
                );
              break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Notifications()),
                );
                break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Chats()),
              );
              break;
          }
        },
        context: context,
        selectedIndex: _selectedIndex, userRole: role!,
      ),
    );
  }
}