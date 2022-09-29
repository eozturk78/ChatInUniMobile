import 'dart:convert';

import 'package:chatinunii/components/toast.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../models/Chat.dart';

class ChatCard extends StatefulWidget {
  const ChatCard(
      {Key? key,
      required this.chat,
      required this.press,
      required this.chatId,
      required this.unreadNum})
      : super(key: key);
  final Chat chat;
  final chatId;
  final unreadNum;
  final VoidCallback press;

  @override
  State<ChatCard> createState() => _ChatCardState();
}

enum Menu { itemOne, itemTwo, itemThree }

class _ChatCardState extends State<ChatCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.press,
      onLongPress: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    widget.chat.image,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chat.name,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        widget.chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(widget.chat.time),
            ),
            Column(
              children: [
                PopupMenuButton<Menu>(
                    // Callback that sets the selected popup menu item.
                    onSelected: (Menu item) {
                      setState(() {
                        // _selectedMenu = item.name;
                      });
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<Menu>>[
                          PopupMenuItem<Menu>(
                            value: Menu.itemOne,
                            child: InkWell(
                              onTap: () {
                                Apis().deleteChat(widget.chatId).then((value) {
                                  Navigator.pop(context);
                                });
                                // Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: kPrimaryColor,
                                  ),
                                  Text(
                                    'delete_chat'.tr,
                                    style: TextStyle(color: kPrimaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          PopupMenuItem<Menu>(
                            value: Menu.itemTwo,
                            child: InkWell(
                              onTap: () {
                                Apis()
                                    .blockByUser(
                                        blockedUserNme: widget.chat.name,
                                        chatId: widget.chatId)
                                    .then((value) {
                                  if (value == 'Bad Request') {
                                    showToast('Error while blocking user');
                                    Navigator.pop(context);
                                  } else {
                                    showToast('User hs been blocked!');
                                    Navigator.pop(context);
                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.report,
                                    color: kPrimaryColor,
                                  ),
                                  Text(
                                    'block_user'.tr,
                                    style: TextStyle(color: kPrimaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          PopupMenuItem<Menu>(
                            value: Menu.itemThree,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                showDialog(
                                    context: (context),
                                    builder: (context) => showDetails());
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.warning,
                                    color: kPrimaryColor,
                                  ),
                                  Text(
                                    'complaint_user'.tr,
                                    style: TextStyle(color: kPrimaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                if (widget.unreadNum != '0')
                  Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.unreadNum.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget showDetails() {
    TextEditingController reason = TextEditingController();
    return AlertDialog(
      title: Text('complaint_user'.tr),
      content: TextFormField(
        controller: reason,
        decoration: InputDecoration(
            labelText: 'reason_text'.tr, hintText: 'reason_text'.tr),
      ),
      actions: [
        TextButton(
            onPressed: () {
              if (reason.text.isEmpty) {
                showToast('Enter ' 'reason_text'.tr);
              } else {
                Apis()
                    .complaintUser(
                        chatId: widget.chatId,
                        toUsername: widget.chat.name,
                        reason: reason.text)
                    .then((value) {
                  if (value == 'Bad Request') {
                    showToast('Error!');
                  } else {
                    if (jsonDecode(value)['IsSuccess'] == true) {
                      Apis().deleteChat(widget.chatId).then((value) {
                        showToast('successfully_saved'.tr);
                        Navigator.pop(context);
                      });
                    } else {
                      showToast(jsonDecode(value)['ErrorMessage']);
                    }
                  }
                });
              }
            },
            child: Text('save'.tr)),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'.tr))
      ],
    );
  }
}
