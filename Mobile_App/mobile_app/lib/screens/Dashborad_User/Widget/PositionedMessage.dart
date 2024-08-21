import 'package:flutter/material.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Custome_Message.dart';

class PositionedMessage extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color color;

  const PositionedMessage({
    required this.message,
    required this.icon,
    required this.color,
  });

  @override
  _PositionedMessageState createState() => _PositionedMessageState();
}

class _PositionedMessageState extends State<PositionedMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: CustomMessageWidget(
              message: widget.message,
              icon: widget.icon,
              color: widget.color,
            ),
          ),
        ),
      ),
    );
  }
}
