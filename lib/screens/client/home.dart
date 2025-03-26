import 'package:ecommerce_app/widgets/app_bar_home.dart';
import 'package:ecommerce_app/widgets/carousel.dart';
import 'package:ecommerce_app/widgets/home_drawer.dart';
import 'package:ecommerce_app/widgets/product_cart.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  final List<String> imagePaths = [
    "https://res.cloudinary.com/dwdhkwu0r/image/upload/v1695385905/samples/balloons.jpg",
    "https://res.cloudinary.com/dwdhkwu0r/image/upload/v1695385910/samples/cup-on-a-table.jpg",
    "https://res.cloudinary.com/dwdhkwu0r/image/upload/v1695385910/samples/chair-and-coffee-table.jpg",
    "https://res.cloudinary.com/dwdhkwu0r/image/upload/v1695385905/samples/shoe.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBarHome(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBar(),
              SizedBox(height: 20),
              Carousel(imagePaths: imagePaths),
              SizedBox(height: 20),
              CategorySelector(),
              SizedBox(height: 20),
              Categories(),
              SizedBox(height: 10),
              ProductGrid(),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search here...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class CategorySelector extends StatelessWidget {
  final List<String> categories = ['All', 'Promotional Products', 'New Products', 'Best Sellers', 'Laptops','Monitors','Keyboards','Mouses','Hard Drives','Webcams'];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories
              .map((category) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Chip(label: Text(category)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "New Products",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold
      ),
    );
  }


}

class ProductGrid extends StatelessWidget {
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
      itemCount: 4,
      itemBuilder: (context, index) {
        return ProductCard();
      },
    );
  }
}

// class AppDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(color: Colors.blue),
//             child: Text('Hello, Agasya!', style: TextStyle(color: Colors.white)),
//           ),
//           SwitchListTile(title: Text('Dark Mode'), value: false, onChanged: (value) {}),
//           ListTile(title: Text('Pages List'), onTap: () {}),
//           ListTile(title: Text('Settings'), onTap: () {}),
//           ListTile(title: Text('Logout'), onTap: () {}),
//         ],
//       ),
//     );
//   }
// }