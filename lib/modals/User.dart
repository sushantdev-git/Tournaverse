import "package:e_game/modals/Event.dart";
import "package:e_game/modals/Payment.dart";
import '../konstants/constants.dart';

class User {
  final String name;
  final String userId;
  final String email;
  final String phoneNo;
  List<Event> eventsParticipated;
  List<Payment> myPayments;
  final UserType usertype;

  User({
    required this.name,
    required this.email,
    required this.userId,
    required this.phoneNo,
    required this.eventsParticipated,
    required this.usertype,
    required this.myPayments,
  });
}
