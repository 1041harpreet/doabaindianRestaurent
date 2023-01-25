import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/arcticons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:restaurent.app/config/config.dart';
import 'package:restaurent.app/provider/auth_provider.dart';

import 'my_Profile_screen.dart';

class EditProfile extends ConsumerWidget {
  EditProfile({Key? key}) : super(key: key);

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      content: new Row(
        children: [
          CircularProgressIndicator(color: Colors.black),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text(
                "uploading...",
                style: TextStyle(color: Colors.black),
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(onWillPop: () async => false, child: alert);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authprovider = ref.watch(authProvider);
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: AppConfig.primaryColor,
            title: Text("Edit Profile"),
            actions: [
              IconButton(
                  onPressed: () async {
                    print(authprovider.updateProfile.value);
                    await authprovider.updateProfileDetails(
                      context,
                      authprovider.updateProfile.control('email').value,
                      authprovider.updateProfile.control('username').value,
                      authprovider.updateProfile.control('phone').value,
                      authprovider.updateProfile.control('img').value,
                    );
                    // Navigator.pop(context);
                  },
                  icon: Text("Save"))
            ]),
        body: ReactiveForm(
            formGroup: authprovider.updateProfile,
            child: Column(children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 170.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(1.0, 1.0),
                                            color: Colors.black,
                                            spreadRadius: 1.0)
                                      ]),
                                  child: Column(children: [
                                    GestureDetector(
                                      child: Card(
                                        child: ListTile(
                                          title: Text(
                                              " Pick Image From Gallery",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          tileColor: Colors.white,
                                          leading: Iconify(
                                            Arcticons.simplegallery,
                                            color: AppConfig.primaryColor,
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        // showLoaderDialog(context);
                                        var i = await authprovider.getImage(
                                            context, ImageSource.gallery);
                                        showLoaderDialog(context);
                                        i.toString().isEmpty
                                            ? ''
                                            : authprovider.updateProfile
                                                    .control('img')
                                                    .value =
                                                await authprovider.uploadimage(
                                                    authprovider.updateProfile
                                                        .control('email')
                                                        .value,
                                                    context,
                                                    i);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        var i = await authprovider.getImage(
                                            context, ImageSource.camera);
                                        showLoaderDialog(context);
                                        i.toString().isEmpty
                                            ? ''
                                            : authprovider.updateProfile
                                                    .control('img')
                                                    .value =
                                                await authprovider.uploadimage(
                                                    authprovider.updateProfile
                                                        .control('email')
                                                        .value,
                                                    context,
                                                    i);
                                        Navigator.pop(context);
                                      },
                                      child: Card(
                                        child: ListTile(
                                          title: Text(" Pick Image From Camera",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          tileColor: Colors.white,
                                          leading: Iconify(Arcticons.camera,
                                              color: AppConfig.primaryColor),
                                        ),
                                      ),
                                    ),
                                  ]),
                                );
                              },
                            );
                          },
                          child: Stack(
                            children: [
                              authprovider.img.isEmpty
                                  ? buildImage(image)
                                  : buildNetoworkImage(authprovider.img),
                              // isEdit ?
                              Positioned(
                                bottom: 0,
                                right: 4,
                                child: buildEditIcon(Colors.grey),
                              )
                              // : SizedBox(width: 0,height: 0,)
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        textfieldbtn(size, 'Username', 'username', false, {
                          ValidationMessage.required: (error) =>
                              "Username can't be Empty"
                        }),
                        const SizedBox(height: 16),
                        textfieldbtn(size, 'Phone No', 'phone', false, {
                          ValidationMessage.required: (error) =>
                              "Phone no can't be Empty",
                          ValidationMessage.minLength: (error) =>
                              "Phone no is not correct",
                          ValidationMessage.maxLength: (error) =>
                              "Phone no is not correct"
                        }),
                        const SizedBox(height: 16),
                        textfieldbtn(size, 'Email', 'email', true, {
                          ValidationMessage.required: (error) =>
                              "Phone no can't be Empty",
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ])),
      ),
    );
  }
}

Widget textfieldbtn(Size size, lable, controlname, isread, validation) {
  return Container(
    alignment: Alignment.center,
    height: size.height * 0.07,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(
        width: 1.0,
        color: const Color(0xFFEFEFEF),
      ),
    ),
    child: ReactiveTextField(
      validationMessages: validation,
      readOnly: isread,
      formControlName: controlname,
      style: GoogleFonts.inter(
        fontSize: 16.0,
        color: const Color(0xFF15224F),
      ),
      maxLines: 1,
      cursorColor: const Color(0xFF15224F),
      decoration: InputDecoration(
          labelText: lable,
          labelStyle: GoogleFonts.inter(
            fontSize: 12.0,
            color: const Color(0xFF969AA8),
          ),
          border: InputBorder.none),
    ),
  );
}
