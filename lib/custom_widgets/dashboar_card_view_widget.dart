import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_texi_driver/models/user_model.dart';
import 'package:new_texi_driver/view-models/dashboard_view_model.dart';

import '../models/book_ride_model.dart';
import '../utils/utils.dart';
import '../view-models/firebase_auth_view_model.dart';

class DashboardCardView extends StatefulWidget {
  const DashboardCardView(
      {super.key, required this.bookingHistry, required this.driverId});
  final BookRideModel bookingHistry;
  final String driverId;

  @override
  State<DashboardCardView> createState() => _DashboardCardViewState();
}

class _DashboardCardViewState extends State<DashboardCardView> {
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
              onPressed: () async {
                LocationPermission permission =
                    await Geolocator.checkPermission();
                if (permission == LocationPermission.denied) {
                  permission = await Geolocator.requestPermission();
                }
                if (permission == LocationPermission.whileInUse ||
                    permission == LocationPermission.always) {
                  Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);
                  double latitude = position.latitude;
                  double longitude = position.longitude;
                  log("current lat long: $latitude, $longitude");

                  DashboardViewModel().onAcceptClicked(
                      context: context,
                      callback: () {
                        DashboardViewModel().updateBookingStatus(
                            bookingId: widget.bookingHistry.id.toString(),
                            driverId: widget.driverId,
                            latitude: latitude.toString(),
                            longitude: longitude.toString(),
                            context: context);
                      });
                }
              },
              child: Text(
                "Accept",
                style: Theme.of(context).textTheme.bodyLarge,
              ))
        ],
      ),
    );
  }
}
