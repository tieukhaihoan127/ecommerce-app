import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/widgets/product_card.dart';
import 'package:ecommerce_app/widgets/product_item.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatefulWidget{

  final List<ProductModel> products;

  const ProductGrid({ super.key, required this.products });

  @override
  _ProductGridState createState() => _ProductGridState();

}

class _ProductGridState extends State<ProductGrid> {

  // late List<Widget> _pages;

  int _activePage = 0;

  final PageController _pageController = PageController(initialPage: 0);

  // @override
  // void initState() {
  //   super.initState();
  //   _pages = widget.products.map((product) => ProductHolderItem(product: product)).toList();
  // }

    @override
    Widget build(BuildContext context) {

      int totalPages = (widget.products.length / 4).ceil();

      List<List<ProductModel>> paginatedProducts = [];
      for (int i = 0; i < totalPages; i++) {
        int start = i * 4;
        int end = start + 4;
        paginatedProducts.add(widget.products.sublist(start, end > widget.products.length ? widget.products.length : end));
      }

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
                  height: MediaQuery.of(context).size.height*0.7,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: totalPages,
                    onPageChanged: (value) {
                      setState(() {
                        _activePage = value;
                      });
                    },
                    itemBuilder: (context, index) {
                      return ProductHolderItem(products: paginatedProducts[index]);
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
                      totalPages,
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

class ProductHolderItem extends StatelessWidget {
  final List<ProductModel> products;

  const ProductHolderItem({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        // return ProductCard(product: products[index]);
        return ProductItem(product: products[index]);
      },
    );
  }
}