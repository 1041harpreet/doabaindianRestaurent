import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/provider/auth_provider.dart';

class MyProfile extends ConsumerWidget {
  const MyProfile({Key? key}) : super(key: key);

  Widget buildImage(onpressed) {
    const image = AssetImage("assets/images/harpreet.jpg");

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: onpressed),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: const Icon(
            Icons.add_a_photo,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authprovider = ref.watch(authProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppConfig.primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            PopupMenuButton(
              color: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              onSelected: (value) {
                // your logic
              },
              itemBuilder: (BuildContext bc) {
                return [
                  PopupMenuItem(
                    value: '/username',
                    child: Text("Edit Username", style: AppConfig.blackTitle),
                  ),
                  PopupMenuItem(
                    value: '/email',
                    child: Text("Update Email", style: AppConfig.blackTitle),
                  ),
                  PopupMenuItem(
                    value: '/phone',
                    child: Text("Update Phone no", style: AppConfig.blackTitle),
                  )
                ];
              },
            )
          ],
          // backgroundColor: Colors.white,
        ),
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
                        Stack(
                          children: [
                            buildImage(() {}),
                            // isEdit ?
                            Positioned(
                              bottom: 0,
                              right: 4,
                              child: buildEditIcon(Colors.grey),
                            )
                            // : SizedBox(width: 0,height: 0,)
                          ],
                        ),
                        const SizedBox(height: 16),
                        ReactiveTextField(
                          readOnly: true,
                          decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelText: 'Username',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder()),
                          formControlName: "username",
                          style: const TextStyle(color: Colors.black),
                          // validationMessages: (control) =>
                          // {'required': 'The Username must not be empty'},
                        ),
                        const SizedBox(height: 16),
                        ReactiveTextField(
                          readOnly: true,
                          decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelStyle: TextStyle(color: Colors.black),
                              labelText: 'email',
                              border: OutlineInputBorder()),
                          style: const TextStyle(color: Colors.black),
                          formControlName: "email",

                        ),
                        const SizedBox(height: 16),
                        ReactiveTextField(
                          style: const TextStyle(color: Colors.black),
                          readOnly: true,
                          decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelStyle: TextStyle(color: Colors.black),
                              labelText: 'Phone No',
                              border: OutlineInputBorder()),
                          formControlName: "phone",
                          // validationMessages: (control) => {
                          //   'required': 'The Phone No must not be empty',
                          //   'minLength':
                          //   'The password must have at least 10 characters'
                          // },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
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
