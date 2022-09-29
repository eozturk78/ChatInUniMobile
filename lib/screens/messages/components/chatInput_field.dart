import 'package:chatinunii/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../authScreens/login.dart';
import '../../../constants.dart';

class ChatInputField extends StatefulWidget {
  final username;
  var chatId;
  ChatInputField({Key? key, required this.username, required this.chatId})
      : super(key: key);

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  @override
  Widget build(BuildContext context) {
    TextEditingController msg = TextEditingController();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 32,
              color: const Color(0xFF087949).withOpacity(0.08),
            ),
          ]),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding * 0.75),
                height: 50,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sentiment_satisfied_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.color
                          ?.withOpacity(0.64),
                    ),
                    const SizedBox(
                      width: kDefaultPadding / 4,
                    ),
                    Expanded(
                      child: TextField(
                        controller: msg,
                        decoration: InputDecoration(
                          hintText: "type_a_message".tr,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        print(msg.text.trim());
                        var p = {
                          'ChatId': widget
                              .chatId, // which is support from GetMessageList end point,
                          'Message':
                              msg.text.trim(), // message which user enters,
                          'ToUserName':
                              widget.username, // selected user in chat,
                          'Lang': lang!, //-phone language
                          'Token':
                              token!, //-- which is supported endpoint GetPublicToken, Login, SignUp,
                          'IsFromLoggedUser': true //-- everytime true,
                        };
                        msg.text == '' ? null : socket.emit('Message', p);
                        socket.on('Message', (data) => print(data));
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.color
                            ?.withOpacity(0.64),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
