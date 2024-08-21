// import 'package:flutter/material.dart';
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

// class PusherChannelServies {
//   static final PusherChannelServies instance = PusherChannelServies._internal();
//   PusherChannelServies._internal();
//   final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

//   void onconnectProced() async {
//     print('1111');
//     try {
//       await pusher.init(
//         apiKey: '544d9f12b8bd2fab2009',
//         cluster: 'eu',
//         onError: onError,
//         onSubscriptionSucceeded: onSubscriptionSucceeded,
//         onEvent: onEvent,
//       );
//       await pusher.subscribe(channelName: 'trip-channel');
//       await pusher.connect();
//     } catch (e) {
//       print('errorrr');
//       print("ERROR: $e");
//     }
//   }

//   void onSubscriptionSucceeded(String channelName, dynamic data) {
//     print("onSubscriptionSucceeded: $channelName data: $data");
//   }

//   void onEvent(PusherEvent event) {
//     print("onEvent: $event");
//   }

//   void onError(String message, int? code, dynamic e) {
//     print("onError: $message code: $code exception: $e");
//   }
// }
