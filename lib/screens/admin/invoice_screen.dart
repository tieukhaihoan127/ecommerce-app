import 'package:ecommerce_app/core/theme/constant.dart';
import 'package:ecommerce_app/screens/admin/header.dart';
import 'package:ecommerce_app/core/config/responsive.dart';
import 'package:flutter/material.dart';

class InvoiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
              ],
            )
          ],
        ),
      ),
    );
  }
}