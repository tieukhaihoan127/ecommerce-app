import 'dart:async';

import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {

  final List<String> imagePaths;

  const Carousel({super.key, required this.imagePaths});

  @override
  _CarouselState createState() => _CarouselState();

}

late List<Widget> _pages;

int _activePage = 0;

final PageController _pageController = PageController(initialPage: 0);

Timer? _timer;

class _CarouselState extends State<Carousel>  {

  void startTime() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if(_pageController.page == widget.imagePaths.length - 1) {
        _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
      else {
        _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = widget.imagePaths.map((path) => ImagePlaceHolder(imagePath: path)).toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onHorizontalDragUpdate: (details) {
                _pageController.position.moveTo(
                  _pageController.offset - details.primaryDelta!,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height/4,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.imagePaths.length,
                    onPageChanged: (value) {
                      setState(() {
                        _activePage = value;
                      });
                    },
                    itemBuilder: (context, index) {
                      return _pages[index];
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                    _pages.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: InkWell(
                        onTap: () {
                            _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                        },
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: _activePage == index ? Colors.black : Colors.grey,
                        ),
                      ),
                    )
                  ),
                ),
              ),
            )
          ]
        )
      ],
    );
  }

}

class ImagePlaceHolder extends StatelessWidget {
  final String? imagePath;
  const ImagePlaceHolder({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imagePath!),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

}