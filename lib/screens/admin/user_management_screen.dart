import 'package:ecommerce_app/core/theme/constant.dart';
import 'package:ecommerce_app/models/user_admin_model.dart';
import 'package:ecommerce_app/providers/admin_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/screens/admin/header.dart';
import 'package:ecommerce_app/core/config/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserManagementScreen extends StatefulWidget{

  const UserManagementScreen({super.key});

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();

}

class _UserManagementScreenState extends State<UserManagementScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<UserProvider>(context, listen: false).loadUserAdmin();
    });
  }

  @override
  Widget build(BuildContext context) {

  final userProvider = Provider.of<UserProvider>(context);

  if (userProvider.userAdmin == null || userProvider.isLoading) {
    return const Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  if (userProvider.userAdmin!.isEmpty) {
    return const Center(child: Text('You do not have any user'));
  }

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
                      SizedBox(height: defaultPadding),
                      Container(
                        padding: EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Quản lý tài khoản người dùng",
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: DataTable(
                                columnSpacing: defaultPadding,
                                // minWidth: 600,
                                columns: [
                                  DataColumn(
                                    label: Text("Mã tài khoản"),
                                  ),
                                  DataColumn(
                                    label: Text("Tên người dùng"),
                                  ),
                                  DataColumn(
                                    label: Text("Email"),
                                  ),
                                  DataColumn(
                                    label: Text("Trạng thái"),
                                  ),
                                  DataColumn(
                                    label: Text("Hành động"),
                                  ),
                                ],
                                rows: List.generate(
                                  userProvider.userAdmin?.length ?? 0,
                                  (index) => recentFileDataRow(userProvider.userAdmin![index],context),
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
              ],
            )
          ],
        ),
      ),
    );
  }
}


DataRow recentFileDataRow(UserAdminModel userInfo, BuildContext context) {
  return DataRow(
    cells: [
      DataCell(Text(userInfo.id!)),
      DataCell(
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent, 
              ),
              child: ClipOval(
                child: Image.network(
                  userInfo.imageUrl ?? 'https://cdn-icons-png.flaticon.com/512/6596/6596121.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                userInfo.fullName ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(userInfo.email!)),
      DataCell(Text(userInfo.status!)),
      DataCell(
        ElevatedButton(
          onPressed: () {
            context.read<AdminProvider>().changePage(AppPage.detailUser, couponId: userInfo.id);
            if (Responsive.isMobile(context)) {
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text(
            'Xem chi tiết',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ],
  );
}
