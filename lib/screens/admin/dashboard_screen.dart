import 'package:ecommerce_app/core/theme/constant.dart';
import 'package:ecommerce_app/models/recent_file.dart';
import 'package:ecommerce_app/screens/admin/header.dart';
import 'package:ecommerce_app/screens/admin/my_fields.dart';
import 'package:ecommerce_app/screens/admin/recent_files.dart';
import 'package:ecommerce_app/core/config/responsive.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
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
                      Container(
                        padding: EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Những đơn hàng gần đây",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: DataTable(
                                columnSpacing: defaultPadding,
                                // minWidth: 600,
                                columns: [
                                  DataColumn(
                                    label: Text("Mã đơn hàng"),
                                  ),
                                  DataColumn(
                                    label: Text("Thời gian"),
                                  ),
                                  DataColumn(
                                    label: Text("Tổng tiền"),
                                  ),
                                ],
                                rows: List.generate(
                                  demoRecentFiles.length,
                                  (index) => recentFileDataRow(demoRecentFiles[index]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

DataRow recentFileDataRow(RecentFile fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(fileInfo.title!),
            ),
          ],
        ),
      ),
      DataCell(Text(fileInfo.date!)),
      DataCell(Text(fileInfo.size!)),
    ],
  );
}