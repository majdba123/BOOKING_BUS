import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  static final PusherService _instance = PusherService._internal();
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  final String _apiKey = "7342c00647f26084d14f";
  final String _cluster = "ap2";
  final String _channelName = "seat-channel";

  factory PusherService() {
    return _instance;
  }

  PusherService._internal() {
    _initializePusher();
  }

  void _initializePusher() async {
    await pusher.init(
      apiKey: _apiKey,
      cluster: _cluster,
      onConnectionStateChange: _onConnectionStateChange,
      onError: _onError,
      onSubscriptionSucceeded: _onSubscriptionSucceeded,
      onEvent: _onEvent,
      onSubscriptionError: _onSubscriptionError,
      onDecryptionFailure: _onDecryptionFailure,
      onMemberAdded: _onMemberAdded,
      onMemberRemoved: _onMemberRemoved,
      onSubscriptionCount: _onSubscriptionCount,
    );
    pusher.subscribe(channelName: _channelName);
    pusher.connect();
  }

  void _onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print("Connection State Change: $currentState");
  }

  void _onError(String message, int? code, dynamic e) {
    print("Pusher Error: $message code: $code exception: $e");
  }

  void _onEvent(PusherEvent event) {
    print("Pusher Event: $event");
    // Handle the event data as needed
  }

  void _onSubscriptionSucceeded(String channelName, dynamic data) {
    print("Subscription Succeeded: $channelName data: $data");
  }

  void _onSubscriptionError(String message, dynamic e) {
    print("Subscription Error: $message Exception: $e");
  }

  void _onDecryptionFailure(String event, String reason) {
    print("Decryption Failure: $event reason: $reason");
  }

  void _onMemberAdded(String channelName, PusherMember member) {
    print("Member Added: $channelName user: $member");
  }

  void _onMemberRemoved(String channelName, PusherMember member) {
    print("Member Removed: $channelName user: $member");
  }

  void _onSubscriptionCount(String channelName, int subscriptionCount) {
    print(
        "Subscription Count: $channelName subscriptionCount: $subscriptionCount");
  }
}
