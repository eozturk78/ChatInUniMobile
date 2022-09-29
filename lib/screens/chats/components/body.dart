import 'dart:io';

import 'package:chatinunii/components/toast.dart';
import 'package:chatinunii/screens/profile.dart';
import 'package:flutter/material.dart';

import '../../../components/filled_outline_button.dart';
import '../../../constants.dart';
import '../../../models/Chat.dart';
import '../../messages/messages_screen.dart';
import 'chat_card.dart';

class Body extends StatelessWidget {
  final chatId;
  final unreadNum;
  Body({required this.chatId, required this.unreadNum});
  DateTime pre_backpress = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= Duration(seconds: 2);
        pre_backpress = DateTime.now();
        if (cantExit) {
          //show snackbar
          showToast('Press Back button again to Exit');
          return false;
        } else {
          exit(0);
        }
      },
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: chatsData.length,
                itemBuilder: (context, index) => ChatCard(
                      chatId: chatId,
                      unreadNum: unreadNum,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessagesScreen(
                              username: '',
                              data: data,
                              index: index,
                            ),
                          ),
                        );
                      },
                      chat: chatsData[index],
                    )),
          ),
        ],
      ),
    );
  }
}
