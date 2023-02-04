import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:restaurent.app/admin/provider/shop_provider.dart';
import 'package:restaurent.app/config/config.dart';

import '../config/const.dart';

class ShopSettingPage extends ConsumerStatefulWidget {
  const ShopSettingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ShopSettingPage> createState() => _ShopSettingPageState();
}

class _ShopSettingPageState extends ConsumerState<ShopSettingPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .watch(shopProvider)
          .shopInfo
          .control('status')
          .patchValue(Const.status);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(shopProvider);
    return Scaffold(
      backgroundColor: AppConfig.secmainColor,
      appBar: AppBar(
        backgroundColor: AppConfig.primaryColor,
        title: Text("Setting"),
      ),
      body: ReactiveForm(
        formGroup: provider.shopInfo,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(" DOABA INDIAN RESTAURANT  ",
                      style: AppConfig.blacktext),
                  Text(
                    Const.status == true ? "OPEN" : "CLOSE",
                    style: TextStyle(
                      color: AppConfig.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              ReactiveSwitch(
                activeColor:
                    MaterialStateColor.resolveWith((states) => Colors.green),
                formControlName: 'status',
                inactiveThumbColor:
                    MaterialStateColor.resolveWith((states) => Colors.black26),
                inactiveTrackColor: MaterialStateColor.resolveWith(
                    (states) => Colors.grey.shade500),
                onChanged: (con) {
                  provider.updateStatus(con.value!);
                  // Const.status=control.value!;
                  // print(control.value);
                },
              )
            ],
          ),
        ]),
      ),
    );
  }
}
