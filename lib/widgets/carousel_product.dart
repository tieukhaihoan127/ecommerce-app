import 'package:flutter/material.dart';

class CarouselProduct extends StatefulWidget {

  final List<String> imagePaths;

  const CarouselProduct({super.key, required this.imagePaths});

  @override
  _CarouselProductState createState() => _CarouselProductState();

}

late List<Widget> _pages;

int _activePage = 0;

final PageController _pageController = PageController(initialPage: 0);

class _CarouselProductState extends State<CarouselProduct>  {


  @override
  void initState() {
    super.initState();
    _pages = widget.imagePaths.map((path) => ImagePlaceHolder(imagePath: path)).toList();
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
              child: SizedBox(
                width: double.infinity,
                height: 200,
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

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imagePath!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

}