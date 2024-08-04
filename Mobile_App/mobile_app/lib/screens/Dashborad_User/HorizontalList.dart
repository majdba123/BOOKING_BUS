import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AutoScrollingHorizontalList extends StatelessWidget {
  final List<Widget> items;

  const AutoScrollingHorizontalList({required this.items});

  @override
  Widget build(BuildContext context) {
    // Get the screen width to calculate responsive item width
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 150.0, // Fixed height for the container
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CarouselSlider.builder(
            options: CarouselOptions(
              height: constraints.maxHeight, // Responsive height for the carousel
              scrollDirection: Axis.horizontal,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 2),
              autoPlayAnimationDuration: Duration(milliseconds: 1500),
              pauseAutoPlayOnTouch: true,
              viewportFraction: 0.7, // Adjust the fraction to fit responsive design
              enlargeCenterPage: true,
            ),
            itemCount: items.length,
            itemBuilder: (context, index, realIndex) {
              return Container(
                padding: EdgeInsets.all(2.0),
                width: screenWidth * 0.9, // Responsive width for each item
                child: items[index],
              );
            },
          );
        },
      ),
    );
  }
}
