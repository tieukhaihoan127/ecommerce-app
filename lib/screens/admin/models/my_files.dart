import 'package:flutter/material.dart';

import '../constants.dart';

class CloudStorageInfo {
  final String? svgSrc, title, total;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.total,
    this.color,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "Doanh thu",
    svgSrc: "assets/icons/doanhthu.svg",
    total: "19.390.521 đ",
    color: primaryColor,
  ),
  CloudStorageInfo(
    title: "Tổng đơn hàng",
    svgSrc: "assets/icons/don_hang.svg",
    total: "54",
    color: Color(0xFFFFA113),
  ),
  CloudStorageInfo(
    title: "Số sản phẩm",
    svgSrc: "assets/icons/pc.svg",
    total: "342",
    color: Color(0xFFA4CDFF),
  ),
  CloudStorageInfo(
    title: "Số loại sản phẩm",
    svgSrc: "assets/icons/pc_component.svg",
    total: "88",
    color: Color(0xFF007EE5),
  ),
];
