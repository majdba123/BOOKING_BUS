import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AutoScrollingHorizontal extends StatefulWidget {
  final List<Widget> items;

  const AutoScrollingHorizontal({required this.items});

  @override
  _AutoScrollingHorizontalState createState() =>
      _AutoScrollingHorizontalState();
}

class _AutoScrollingHorizontalState extends State<AutoScrollingHorizontal> {
  late ScrollController _scrollController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (_scrollController.hasClients && mounted) {
        final double maxScroll = _scrollController.position.maxScrollExtent;
        final double currentScroll = _scrollController.position.pixels;
        final double nextScroll =
            (currentScroll + 200.0) >= maxScroll ? 0.0 : currentScroll + 200.0;
        _scrollController.animateTo(
          nextScroll,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Adjust height as needed
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: widget.items[index],
          );
        },
      ),
    );
  }
}
