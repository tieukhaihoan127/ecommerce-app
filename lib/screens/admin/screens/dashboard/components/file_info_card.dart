import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../constants.dart';
import '../../../models/my_files.dart';

class FileInfoCard extends StatelessWidget {
  const FileInfoCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final CloudStorageInfo info;

  @override
  Widget build(BuildContext context) {
    // Xác định kích thước màn hình để điều chỉnh padding và font size
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    // Điều chỉnh padding theo kích thước màn hình
    final cardPadding = isMobile
        ? EdgeInsets.all(defaultPadding / 2)
        : isTablet
        ? EdgeInsets.all(defaultPadding * 0.75)
        : EdgeInsets.all(defaultPadding);

    // Điều chỉnh font size theo kích thước màn hình
    final titleFontSize = isMobile ? 16.0 : isTablet ? 18.0 : 20.0;
    final valueFontSize = isMobile ? 20.0 : isTablet ? 22.0 : 25.0;

    // Điều chỉnh kích thước icon
    final iconSize = isMobile ? 40.0 : isTablet ? 45.0 : 50.0;

    return Container(
      padding: cardPadding,
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon
          Center(
            child: Container(
              height: iconSize,
              width: iconSize,
              child: SvgPicture.asset(
                info.svgSrc!,
                fit: BoxFit.contain, // Đảm bảo SVG vừa vặn trong container
              ),
            ),
          ),
          SizedBox(height: isMobile ? 8 : 12), // Thêm khoảng cách
          // Giá trị
          Center(
            child: Text(
              info.total!,
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: valueFontSize,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: isMobile ? 4 : 8), // Thêm khoảng cách
          // Tiêu đề
          Center(
            child: Text(
              info.title!,
              style: TextStyle(
                color: Colors.white,
                fontSize: titleFontSize,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2, // Cho phép 2 dòng để tránh tràn
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
