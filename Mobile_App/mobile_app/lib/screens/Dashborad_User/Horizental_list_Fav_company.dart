import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AutoScrollingHorizontalListCompany extends StatelessWidget {
  final List<Widget> items;

  const AutoScrollingHorizontalListCompany({required this.items});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adjust the height based on screen size to fit the list of companies properly
    double listHeight = screenHeight * 0.37; // 20% of the screen height
    double itemWidth = screenWidth * 0.7; // 70% of the screen width
    double itemPadding = screenWidth * 0.01; // 2% of the screen width

    return Container(
      height: listHeight, // Responsive height
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
                padding: EdgeInsets.symmetric(horizontal: itemPadding),
                width: itemWidth,
                child: items[index],
              );
            },
          );
        },
      ),
    );
  }
}
