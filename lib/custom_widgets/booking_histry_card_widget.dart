import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_texi_driver/models/user_model.dart';
import 'package:new_texi_driver/view-models/dashboard_view_model.dart';

import '../models/book_ride_model.dart';
import '../utils/utils.dart';
import '../view-models/chat_view_model.dart';
import '../view-models/firebase_auth_view_model.dart';

class BookingHistryCardView extends StatefulWidget {
  const BookingHistryCardView(
      {super.key, required this.bookingHistry, required this.driverId});
  final BookRideModel bookingHistry;
  final String driverId;

  @override
  State<BookingHistryCardView> createState() => _BookingHistryCardViewState();
}

class _BookingHistryCardViewState extends State<BookingHistryCardView> {
  UserModel? userModel = UserModel();
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    log("get user data");
    userModel = await FirebaseAuthViewModel()
        .getUserDataFromFireStore(uid: widget.bookingHistry.userId!);
    setState(() {});
    log("usermodel: ${userModel!.uid}");
  }

  @override
  Widget build(BuildContext context) {
    log("usermodel: ${userModel!.name}");
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), border: Border.all()),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Name :",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Expanded(child: Container()),
              Text(
                "${userModel!.name.toString()}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                "Pick Location :",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Expanded(child: Container()),
              Text(
                "${widget.bookingHistry.pickLocation}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                "Drop Location :",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Expanded(child: Container()),
              Text(
                "${widget.bookingHistry.dropLocation}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                "Booking Date :",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Expanded(child: Container()),
              Text(
                Utils.formateDate(widget.bookingHistry.date.toString()),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                "Booking Time :",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Expanded(child: Container()),
              Text(
                Utils.formateTime(widget.bookingHistry.date.toString()),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                "Status :",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Expanded(child: Container()),
              Text(
                "${widget.bookingHistry.bookingStatus}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                "Total :",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Expanded(child: Container()),
              Text(
                "${widget.bookingHistry.totalFare}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          ElevatedButton(
              onPressed: () {
                ChatViewModel().checkChatRoomisExist(
                    userId: widget.bookingHistry.userId.toString(),
                    driverId: widget.bookingHistry.driverId.toString(),
                    context: context,
                    bookingId: widget.bookingHistry.id.toString());
              },
              child: Text(
                "Chat With Customer",
                style: Theme.of(context).textTheme.bodyLarge,
              ))
        ],
      ),
    );
  }
}
