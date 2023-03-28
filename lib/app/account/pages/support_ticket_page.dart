// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:qixer/app/order/widgets/order_helper.dart';
// import 'package:qixer/shared/common_helper.dart';
// import 'package:qixer/shared/const_helper.dart';
// import 'package:qixer/shared/constant_color.dart';

// class MyTicketsPage extends StatefulWidget {
//   const MyTicketsPage({Key? key}) : super(key: key);

//   @override
//   _MyTicketsPageState createState() => _MyTicketsPageState();
// }

// class _MyTicketsPageState extends State<MyTicketsPage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ConstantColors cc = ConstantColors();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: cc.greyPrimary),
//         title: Text(
//           'Support tickets',
//           style: mainFont.copyWith(
//               color: cc.greyPrimary, fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: const Icon(
//             Icons.arrow_back_ios,
//             size: 18,
//           ),
//         ),
//         actions: [
//           Container(
//             width: screenWidth / 4,
//             padding: const EdgeInsets.symmetric(
//               vertical: 9,
//             ),
//             child: InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute<void>(
//                     builder: (BuildContext context) => const CreateTicketPage(),
//                   ),
//                 );
//               },
//               child: Container(
//                   // width: double.infinity,

//                   alignment: Alignment.center,
//                   // padding: const EdgeInsets.symmetric(vertical: 10),
//                   decoration: BoxDecoration(
//                       color: cc.primaryColor,
//                       borderRadius: BorderRadius.circular(8)),
//                   child: Text(
//                     'Buat Tiket',
//                     maxLines: 1,
//                     style: mainFont.copyWith(
//                       color: Colors.white,
//                       fontSize: 13,
//                     ),
//                   )),
//             ),
//           ),
//           const SizedBox(
//             width: 25,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//           child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             for (int i = 0; i < provider.ticketList.length; i++)
//               InkWell(
//                 onTap: () {
//                   provider.goToMessagePage(
//                       context, provider.ticketList[i]['subject'],
//                       ticketId: provider.ticketList[i]['id']);
//                 },
//                 child: Container(
//                   alignment: Alignment.center,
//                   margin: const EdgeInsets.only(
//                     top: 20,
//                     bottom: 3,
//                   ),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                   decoration: BoxDecoration(
//                       border: Border.all(color: cc.borderColor),
//                       borderRadius: BorderRadius.circular(5)),
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               '#${provider.ticketList[i]['id']}',
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: mainFont.copyWith(
//                                 color: cc.primaryColor,
//                               ),
//                             ),
//                             // put the hamburger icon here
//                             PopupMenuButton(
//                               // initialValue: 2,
//                               child: const Icon(Icons.more_vert),
//                               itemBuilder: (context) {
//                                 return List.generate(1, (index) {
//                                   return PopupMenuItem(
//                                     onTap: () async {
//                                       await Future.delayed(Duration.zero);
//                                       provider.goToMessagePage(context,
//                                           provider.ticketList[i]['subject'],
//                                           ticketId: provider.ticketList[i]
//                                               ['id']);
//                                     },
//                                     value: index,
//                                     child: Text(asProvider.getString('Chat')),
//                                   );
//                                 });
//                               },
//                             )
//                           ],
//                         ),

//                         //Ticket title
//                         const SizedBox(
//                           height: 7,
//                         ),
//                         CommonHelper()
//                             .titleCommon(provider.ticketList[i]['subject']),

//                         //Divider
//                         Container(
//                           margin: const EdgeInsets.only(top: 17, bottom: 12),
//                           child: CommonHelper().dividerCommon(),
//                         ),
//                         //Capsules
//                         Row(
//                           children: [
//                             OrdersHelper().statusCapsule(
//                                 provider.ticketList[i]['priority'],
//                                 cc.greyThree),
//                             const SizedBox(
//                               width: 11,
//                             ),
//                             OrdersHelper().statusCapsuleBordered(
//                                 provider.ticketList[i]['status'],
//                                 cc.greyParagraph),
//                           ],
//                         )
//                       ]),
//                 ),
//               )
//           ],
//         ),
//       )),
//     );
//   }
// }
