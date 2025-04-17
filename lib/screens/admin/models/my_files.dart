import 'package:admin/constants.dart';
import 'package:flutter/material.dart';

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
    svgSrc: "",
    total: "54",
    color: Color(0xFFFFA113),
  ),
  CloudStorageInfo(
    title: "Số sản phẩm",
    svgSrc: "",
    total: "342",
    color: Color(0xFFA4CDFF),
  ),
  CloudStorageInfo(
    title: "Số loại sản phẩm",
    svgSrc: "",
    total: "88",
    color: Color(0xFF007EE5),
  ),
];
