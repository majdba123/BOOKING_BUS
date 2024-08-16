import 'package:flutter/material.dart';
import 'pulse_animation.dart';
import 'tooltip_with_next.dart';
import 'package:mobile_app/Colors.dart';

class OnboardingOverlay extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final int step;

  const OnboardingOverlay({
    required this.onNext,
    required this.onSkip,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.6),
        ),
        if (step == 1) ...[
          Positioned(
            top: 140,
            right: 25,
            child: PulseAnimation(),
          ),
          Positioned(
            top: 250,
            right: 20,
            child: TooltipWithNext(
              text: "Tap here to select boarding and deboarding points",
              onNext: onNext,
            ),
          ),
        ],
        Positioned(
          bottom: 20,
          left: 20,
          child: ElevatedButton(
            onPressed: onSkip,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              "Skip Tutorial",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
