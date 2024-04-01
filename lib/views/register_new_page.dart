import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:new_texi_driver/models/driver_user_model.dart';
import 'package:new_texi_driver/utils/utils.dart';
import 'package:new_texi_driver/view-models/registration_new_page_view_model.dart';
import 'package:provider/provider.dart';

import '../view-models/image_picker_view_model.dart';
import '../view-models/upload_file_to_firebase_storage.dart';

class RegisterNewPage extends StatelessWidget {
  const RegisterNewPage(
      {super.key, required this.email, required this.password});
  final String email;
  final String password;

  @override
  Widget build(BuildContext context) {
    DriverUserModel driverUserModel = DriverUserModel();
    driverUserModel.email = email;
    driverUserModel.password = password;
    return Scaffold(
        appBar: AppBar(
          title: Text("Register New Page"),
        ),
        body: ChangeNotifierProvider(
          create: (context) => RegistrationNewPageViewModel(),
          child: Consumer<RegistrationNewPageViewModel>(
            builder: (context, provider, child) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Driving License"),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          provider.drivingLicenseUplodate
                              ? SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image.file(
                                      File(provider.drivingLicenseImageUrl!)),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    String? url = await ImagePickerViewModel()
                                        .pickImageFromGallery();
                                    log("url: $url");
                                    provider.setDrivingLicenseImageUrl(url);
                                  },
                                  child: Text("Select Image")),
                          SizedBox(
                            width: 10,
                          ),
                          ChangeNotifierProvider(
                            create: (context) => UploadFileToFirebaseStorage(),
                            child: Consumer<UploadFileToFirebaseStorage>(
                                builder: (context, uploadProvider, child) {
                              return uploadProvider.isCompleted
                                  ? Text("Uploaded")
                                  : ElevatedButton(
                                      onPressed: () async {
                                        if (provider.drivingLicenseImageUrl !=
                                            null) {
                                          uploadProvider.setLoding(true);
                                          driverUserModel
                                                  .drivingLicenseImageUrl =
                                              await UploadFileToFirebaseStorage()
                                                  .uploadImageToFirebase(File(
                                                      provider
                                                          .drivingLicenseImageUrl!));
                                          uploadProvider.setLoding(false);
                                          uploadProvider.setCompleted(true);

                                          log("driverUserModel.drivingLicenseImageUrl: ${driverUserModel.drivingLicenseImageUrl}");
                                        } else {
                                          Utils.toastMessage(
                                              "please select Driving License Image");
                                        }
                                      },
                                      child: uploadProvider.isLoading
                                          ? CircularProgressIndicator()
                                          : Text("Upload"));
                            }),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Vechile Registration Certificate"),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          provider.vehicleDocumentImageUrlUplodate
                              ? SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image.file(
                                      File(provider.vehicleDocumentImageUrl!)),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    String? url = await ImagePickerViewModel()
                                        .pickImageFromGallery();
                                    provider.setVehicleDocumentImageUrl(url);
                                  },
                                  child: Text("Select Image")),
                          SizedBox(
                            width: 10,
                          ),
                          ChangeNotifierProvider(
                            create: (context) => UploadFileToFirebaseStorage(),
                            child: Consumer<UploadFileToFirebaseStorage>(
                                builder: (context, uploadProvider, child) {
                              return uploadProvider.isCompleted
                                  ? Text("Uploaded")
                                  : ElevatedButton(
                                      onPressed: () async {
                                        if (provider.vehicleDocumentImageUrl !=
                                            null) {
                                          uploadProvider.setLoding(true);
                                          driverUserModel
                                                  .vehicleDocumentImageUrl =
                                              await UploadFileToFirebaseStorage()
                                                  .uploadImageToFirebase(File(
                                                      provider
                                                          .vehicleDocumentImageUrl!));
                                          uploadProvider.setLoding(false);
                                          uploadProvider.setCompleted(true);
                                        } else {
                                          Utils.toastMessage(
                                              "please select Vechile Registration Certificate Image");
                                        }
                                      },
                                      child: uploadProvider.isLoading
                                          ? CircularProgressIndicator()
                                          : Text("Upload"));
                            }),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Vechile Image"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          provider.vehicleImageUrlUplodate
                              ? SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image.file(
                                      File(provider.vehicleImageUrl!)))
                              : ElevatedButton(
                                  onPressed: () async {
                                    String? url = await ImagePickerViewModel()
                                        .pickImageFromGallery();
                                    provider.setVehicleImageUrl(url);
                                  },
                                  child: Text("Select Image")),
                          SizedBox(
                            width: 10,
                          ),
                          ChangeNotifierProvider(
                            create: (context) => UploadFileToFirebaseStorage(),
                            child: Consumer<UploadFileToFirebaseStorage>(
                                builder: (context, uploadProvider, child) {
                              return uploadProvider.isCompleted
                                  ? Text("Uploaded")
                                  : ElevatedButton(
                                      onPressed: () async {
                                        if (provider.vehicleImageUrl != null) {
                                          uploadProvider.setLoding(true);
                                          driverUserModel.vehicleImageUrl =
                                              await UploadFileToFirebaseStorage()
                                                  .uploadImageToFirebase(File(
                                                      provider
                                                          .vehicleImageUrl!));
                                          uploadProvider.setLoding(false);
                                          uploadProvider.setCompleted(true);
                                        } else {
                                          Utils.toastMessage(
                                              "please select Vechile Image");
                                        }
                                      },
                                      child: uploadProvider.isLoading
                                          ? CircularProgressIndicator()
                                          : Text("Upload"));
                            }),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Your Image"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          provider.yourImageUplodate
                              ? SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image.file(File(provider.yourImage!)))
                              : ElevatedButton(
                                  onPressed: () async {
                                    String? url = await ImagePickerViewModel()
                                        .pickImageFromGallery();
                                    provider.setYourImage(url);
                                  },
                                  child: Text("Select Image")),
                          SizedBox(
                            width: 10,
                          ),
                          ChangeNotifierProvider(
                            create: (context) => UploadFileToFirebaseStorage(),
                            child: Consumer<UploadFileToFirebaseStorage>(
                                builder: (context, uploadProvider, child) {
                              return uploadProvider.isCompleted
                                  ? Text("Uploaded")
                                  : ElevatedButton(
                                      onPressed: () async {
                                        if (provider.yourImage != null) {
                                          uploadProvider.setLoding(true);
                                          driverUserModel.profilePic =
                                              await UploadFileToFirebaseStorage()
                                                  .uploadImageToFirebase(File(
                                                      provider.yourImage!));
                                          uploadProvider.setLoding(false);
                                          uploadProvider.setCompleted(true);
                                        } else {
                                          Utils.toastMessage(
                                              "please select Your Image");
                                        }
                                      },
                                      child: uploadProvider.isLoading
                                          ? CircularProgressIndicator()
                                          : Text("Upload"));
                            }),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      provider.submitButton
                          ? ElevatedButton(
                              onPressed: () {
                                if (driverUserModel.profilePic == null) {
                                  Utils.toastMessage(
                                      "please upload Your Image");
                                } else if (driverUserModel.vehicleImageUrl ==
                                    null) {
                                  Utils.toastMessage(
                                      "please upload Vechile Image");
                                } else if (driverUserModel
                                        .vehicleDocumentImageUrl ==
                                    null) {
                                  Utils.toastMessage(
                                      "please upload Vechile Registration Certificate Image");
                                } else if (driverUserModel
                                        .drivingLicenseImageUrl ==
                                    null) {
                                  Utils.toastMessage(
                                      "please upload Driving License Image");
                                } else {
                                  provider.registerAccount(
                                      context: context,
                                      driverUserModel: driverUserModel);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width, 46),
                                  backgroundColor: const Color(0xff3b5998),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50))),
                              child: provider.isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.white))
                                  : const Text(
                                      "Register",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 2),
                                    ),
                            )
                          : Container()
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
