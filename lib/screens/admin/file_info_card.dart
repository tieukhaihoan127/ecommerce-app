import 'package:ecommerce_app/core/theme/constant.dart';
import 'package:ecommerce_app/models/my_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FileInfoCard extends StatelessWidget {
  const FileInfoCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final CloudStorageInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: SvgPicture.asset(
                info.svgSrc!,
              ),
            ),
          ),
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                info.total!,
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                info.title!,
                style: TextStyle(
                    color: Colors.white,

                    fontSize: 20
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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