import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/screens/client/bottom_nav.dart';
import 'package:ecommerce_app/screens/client/change_password.dart';
import 'package:ecommerce_app/screens/client/change_user_information.dart';
import 'package:ecommerce_app/screens/client/not_logged_in.dart';
import 'package:ecommerce_app/screens/client/signin.dart';
import 'package:ecommerce_app/widgets/app_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Profile extends StatelessWidget{

  const Profile({ super.key });

  Future<String> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('session_id');
    if (sessionId == null) {
      sessionId = const Uuid().v4(); 
      await prefs.setString('session_id', sessionId);
    }
    return sessionId;
  }

  Future<void> logout(BuildContext context, UserProvider user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    user.resetUser();
    getSessionId();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => BottomNavBar()),
      (route) => false, 
    );

  }

  void showLogoutDialog(BuildContext context,UserProvider user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận đăng xuất"),
          content: const Text("Bạn có chắc chắn muốn đăng xuất không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
                logout(context,user); 
              },
              child: const Text("Có", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      appBar: AppBarHelper(title: "My Profile"),
      body: userProvider.user?.id == null ? NotLoggedInPage() : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 20,
            vertical: 15
          ),
          child: Column(
            children: [
              Center(
                child: _profileInfo(context,userProvider.user?.imageUrl, userProvider.user?.fullName, userProvider.user?.email),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _itemProfile(Icons.person, context,"My Account", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyAccountScreen()));
                    }),
                    _itemProfile(Icons.location_on, context,"Manage Delivery Address", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));
                    }),
                    _itemProfile(Icons.history, context,"Order History", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));
                    }),
                    _itemProfile(Icons.lock, context,"Change Password", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
                    }),
                    _itemProfile(Icons.logout, context,"Log Out", () {
                      showLogoutDialog(context,userProvider);
                    })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

  }

  Widget _profileInfo(BuildContext context, String? image, String? name, String? email) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100), 
            image: DecorationImage(
              image: image != null ? NetworkImage(image) : NetworkImage('https://cdn-icons-png.flaticon.com/512/6596/6596121.png'),
              fit: BoxFit.cover,
            ),
            boxShadow: [ 
              BoxShadow(
                color: Color.fromRGBO(100, 100, 111, 0.2),
                offset: Offset(0, 7), 
                blurRadius: 29, 
                spreadRadius: 0,
              ),
            ],
          ),
        ),
        Text(
          name ?? "Your name",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),
        ),
        Text(
          email ?? "youremail@gmail.com",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey
          ),
        ),
      ],
    );
  }

  Widget _itemProfile(IconData icon, BuildContext context, String title, VoidCallback tapFunction) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white, 
      borderRadius: BorderRadius.circular(12), 
      border: Border.all(color: Colors.grey.shade300, width: 1), 
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ], 
    ),
    margin: const EdgeInsets.symmetric(vertical: 5), 
    child: ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
      onTap: tapFunction,
    ),
  );
}

}