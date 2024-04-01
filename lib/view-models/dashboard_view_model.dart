import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_texi_driver/models/book_ride_model.dart';

class DashboardViewModel {
  onAcceptClicked({
    required BuildContext context,
    required VoidCallback callback,
  }) {
    showDialog(
        context: context,
        builder: (builder) => AlertDialog(
              title: Text("Accept Booking"),
              content: Text("Are you sure to accept the booking?"),
              actions: [
                TextButton(onPressed: callback, child: Text("Yes")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("No"))
              ],
            ));
  }

  updateBookingStatus(
      {required String bookingId,
      required String driverId,
      required BuildContext context,
      required String latitude,
      required String longitude}) {
    FirebaseFirestore.instance.collection("bookings").doc(bookingId).update({
      "driverId": driverId,
      "acceptedLongitude": longitude,
      "acceptedLatitude": latitude,
      "acceptedTime": DateTime.now().toString()
    }).then((value) => Navigator.pop(context));
  }
}
