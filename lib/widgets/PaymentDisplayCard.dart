import 'package:e_game/providers/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../modals/Payment.dart';

class PaymentDisplayCard extends StatelessWidget {
  final Payment payment;
  const PaymentDisplayCard({required this.payment, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('dd MMM yyyy, hh:mm a');
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return GestureDetector(
      child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xff5300CB),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(top: 5, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payment.eventName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    f.format(payment.createdAt),
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Text("- ₹${payment.amount/100}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  PaymentStatus(title: payment.status),
                ],
              )
            ],
          ),
      ),
    );
  }
}

class PaymentStatus extends StatelessWidget {
  final String title;
  const PaymentStatus({required this.title, Key? key}) : super(key: key);
  
  String getStatus(String status){
    if(status == "captured") return "Successful";
    return "Pending";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 80,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: title == "captured" ? Colors.greenAccent : Colors.yellowAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          getStatus(title),
          style: const TextStyle(color: Colors.black,fontSize: 12),
        ),
      ),
    );
  }
}
