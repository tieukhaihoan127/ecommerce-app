import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/screens/client/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget{

  const Profile({ super.key });

  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 20,
            vertical: 15
          ),
          child: Column(
            children: [
              Center(
                child: _headerProfile(context),
              ),
              const SizedBox(height: 10,),
              Center(
                child: _profileInfo(context,userProvider.user?.imageUrl, userProvider.user?.fullName, userProvider.user?.email),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                height: 300,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _itemProfile(Icons.person, context,"My Account", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));
                    }),
                    _itemProfile(Icons.location_on, context,"Manage Delivery Address", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));
                    }),
                    // _itemProfile(Icons.history, context,"Order History", () {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));
                    // }),
                    _itemProfile(Icons.lock, context,"Change Password", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));
                    }),
                    _itemProfile(Icons.logout, context,"Log Out", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));
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

  Widget _headerProfile(BuildContext context) {
    return Text(
      "My Profile",
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 18
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