import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AutoScrollingHorizontalList extends StatelessWidget {
  final List<Widget> items;

  const AutoScrollingHorizontalList({required this.items});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 120.0, // Adjusted height to fit the RouteCard properly
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CarouselSlider.builder(
            options: CarouselOptions(
              height: constraints.maxHeight,
              scrollDirection: Axis.horizontal,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              pauseAutoPlayOnTouch: true,
              viewportFraction: 0.75,
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
            ),
            itemCount: items.length,
            itemBuilder: (context, index, realIndex) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                width: screenWidth * 0.75,
                child: items[index],
              );
            },
          );
        },
      ),
    );
  }
}
