import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:restaurent.app/config/config.dart';
import 'package:restaurent.app/provider/auth_provider.dart';
import 'package:restaurent.app/provider/nav_bar_provider.dart';
import 'package:restaurent.app/screens/navBar/profille_page/setting/notification/notification_setting_provider.dart';

import '../../../../../provider/notification_provider.dart';
import '../../../../../widgets/toast_service.dart';
import '../../../../auth/sign_up_screen.dart';

class DeleteAccount extends ConsumerWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authprovider = ref.watch(authProvider);
    final navprovider = ref.watch(NavBarProvider);
    final notificationprovider = ref.watch(notificationSettingProvider);
    final nprovider = ref.watch(notificationProvider);
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                notificationprovider.deleteAccountForm.reset();
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10.0)),
                  width: 40.0,
                  height: 40.0,
                  child: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.grey,
                  )),
            ),
          ),
          title: Text(
            "Delete Account",
          ),
          actions: [
            Tooltip(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.info),
              ),
              message:
                  "once your account is deleted,all of your content will be gone, including order details.You can not recover after that.",
              triggerMode: TooltipTriggerMode.tap,
            )
          ],
          backgroundColor: AppConfig.primaryColor,
        ),
        backgroundColor: AppConfig.secmainColor,
        body: ReactiveForm(
          formGroup: notificationprovider.deleteAccountForm,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              SizedBox(
                height: size.height * 0.05,
              ),
              passwordField(
                  size,
                  'Enter Your Current Password',
                  'current',
                  {
                    ValidationMessage.required: (error) =>
                        "Current password must not be empty",
                  },
                  navprovider),
              SizedBox(
                height: size.height * 0.05,
              ),
              authprovider.deleteload == true
                  ? loadingButton(size)
                  : Button(size, "Delete My Account", Colors.white,
                      AppConfig.primaryColor, () async {
                      if (notificationprovider.deleteAccountForm.valid) {
                        await authprovider.deleteAccount(
                            context,
                            notificationprovider.deleteAccountForm
                                .control('current')
                                .value);
                      } else {
                        print('invalid');
                        notificationprovider.deleteAccountForm
                            .markAllAsTouched();
                        showErrorToast(
                            message: 'fill the details first',
                            context: context);
                      }
                    }),
            ]),
          ),
        ));
  }
}
// deleteAccountBox(context,authprovider,notificationprovider,currentPassword,np) {
//   return showDialog(
//     context: context,
//     builder: (context) => Theme(
//       data: ThemeData(backgroundColor: Colors.white),
//       child: AlertDialog(
//         title: const Text('Are you sure?'),
//         content: const Text('Do you want to Delete Account.once your account is deleted,all of your content will be gone, including order details.You can not recover after that.'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('No'),
//           ),
//           TextButton(
//             onPressed: () async {
//               await np.deleteToken();
//               await authprovider.deleteAccount(context,currentPassword);
//               print('log');
//             },
//             child: const Text('Yes'),
//           ),
//         ],
//       ),
//     ),
//   );
// }
