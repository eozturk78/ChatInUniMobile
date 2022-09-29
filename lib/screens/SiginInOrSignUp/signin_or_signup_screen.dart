// import 'package:chatinunii/authScreens/login.dart';
// import 'package:chatinunii/authScreens/signup.dart';
// import 'package:chatinunii/core/apis.dart';
// import 'package:chatinunii/screens/chats/chatThroughStatus.dart';
// import 'package:flutter/material.dart';

// import '../../components/primary_button.dart';
// import '../../constants.dart';
// import '../chats/chats_screen.dart';

// class SignInOrSignUpScreen extends StatefulWidget {
//   const SignInOrSignUpScreen({Key? key}) : super(key: key);

//   @override
//   State<SignInOrSignUpScreen> createState() => _SignInOrSignUpScreenState();
// }

// String? token;

// class _SignInOrSignUpScreenState extends State<SignInOrSignUpScreen> {
//   @override
//   void didChangeDependencies() {
//     Locale myLocale = Localizations.localeOf(context);
//     setState(() {
//       lang = myLocale.toLanguageTag();
//     });
//     print('my locale ${myLocale.toLanguageTag()}');
//     super.didChangeDependencies();
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Apis().getToken().then((value) {
//       setState(() {
//         token = value['Response']['Token'];
//       });
//       print(token);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: token == null
//           ? Center(
//               child: CircularProgressIndicator(
//                 color: kPrimaryColor,
//               ),
//             )
//           : SafeArea(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: kDefaultPadding),
//                 child: Column(
//                   children: [
//                     const Spacer(
//                       flex: 2,
//                     ),
//                     // Image.asset(
//                     //   MediaQuery.of(context).platformBrightness == Brightness.light
//                     //       ? "assets/images/Logo_light.png"
//                     //       : "assets/images/Logo_dark.png",
//                     //   height: 146,
//                     // ),
//                     Container(
//                       padding: const EdgeInsets.all(5),
//                       decoration: BoxDecoration(
//                           border: Border.all(color: kPrimaryColor, width: 3),
//                           borderRadius: BorderRadius.circular(5)),
//                       child: const Text(
//                         'ChatInUni',
//                         style: TextStyle(
//                             fontSize: 40,
//                             color: kPrimaryColor,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     const Spacer(),
//                     PrimaryButton(
//                         text: "Sign In",
//                         press: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const Login(),
//                             ),
//                           );
//                         }),
//                     const SizedBox(
//                       height: kDefaultPadding * 1.5,
//                     ),
//                     PrimaryButton(
//                       color: kPrimaryColor,
//                       text: "Sign Up",
//                       press: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const Signup(),
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(
//                       height: kDefaultPadding * 1.5,
//                     ),
//                     PrimaryButton(
//                       color: kPrimaryColor,
//                       text: "Start Chating",
//                       press: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ChatByStatus(
//                               flag: false,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     const Spacer(
//                       flex: 2,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
