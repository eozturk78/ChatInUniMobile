// ignore_for_file: deprecated_member_use, file_names, prefer_const_constructors, unused_label, curly_braces_in_flow_control_structures
import 'package:chatinunii/components/toast.dart';
import 'package:chatinunii/constants.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:chatinunii/models/statusmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

class DeleteMyAccount extends StatefulWidget {
  const DeleteMyAccount();

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<DeleteMyAccount> {
  final translator = GoogleTranslator();
  var short_desc,
      save,
      phone_number,
      error_update,
      pass_updated,
      make_me_gold_user;
  String localmage = '';
  TextEditingController phone = TextEditingController();
  bool showPassword = false;
  String? lang;
  StatusModel? status;
  var data;

  @override
  void initState() {
    lang =
        '${Get.deviceLocale.toString().split('_')[0]}-${Get.deviceLocale.toString().split('_')[1]}';
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
        child: ListView(
          children: [
            SizedBox(
              height: 5,
            ),
            Text(
              'delete_my_account_desc'.tr,
              style: TextStyle(fontSize: 16, color: kPrimaryColor),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        onPrimary: kPrimaryColor,
                        elevation: 5,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [kPrimaryColor, kPrimaryColor]),
                          borderRadius: BorderRadius.circular(20)),
                      child: InkWell(
                        onTap: () async {
                          Apis()
                              .deleteMyAccount()
                              .then((value) {
                            if (value == 'Bad Request') {
                              showToast('something_went_wrong'.tr);
                            } else {
                              showToast('we_got_my_account_req'.tr);
                              phone.clear();
                            }
                          });
                        },
                        child: Container(
                          width: 200,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            'send'.tr,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      automaticallyImplyLeading: false,
      backgroundColor: kPrimaryColor,
      title: Text("delete_my_account".tr),
    );
  }

  Widget buildTextField(
      String labelText, Icon icon, TextEditingController ctrl) {
    return Container(
        width: double.infinity,
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
            border: Border.all(color: kPrimaryColor, width: 1),
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon,
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: TextFormField(
                  controller: ctrl,
                  maxLines: 1,
                  decoration: InputDecoration(
                    label: Text(labelText),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
