import 'package:ecommerce_app/models/change_password.dart';
import 'package:ecommerce_app/models/remember_user_token.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/screens/client/signin.dart';
import 'package:ecommerce_app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdatePasswordScreen extends StatefulWidget {

  const UpdatePasswordScreen({super.key});

  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();

}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen>{

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmedPasswordController = TextEditingController();
  String _id = "";

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false); 
    
    if(userProvider.user?.id != null) {
      _id = userProvider.user?.id ?? "";
    }

  }

  Future<void> _updatePassword(UserProvider user) async {

    final updatePasswordData = RememberUserToken(
        token: user.token,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmedPasswordController.text
    );

    String message = await user.updatePasswordPost(updatePasswordData);

    if(user.errorMessage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(user.errorMessage)),
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Signin()),
    );

  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarHelper(header: "Change Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerUpdatePassword(context),
            _labelUpdatePassword(context),
            SizedBox(height: 20),
            _buildTextField(Icons.lock, "New Password", _newPasswordController),
            _buildTextField(Icons.lock, "Confirm Password", _confirmedPasswordController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: user.isLoading ? null : () {
                _updatePassword(user);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: user.isLoading ? CircularProgressIndicator(color: Colors.white) : Text("Reset Password", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerUpdatePassword(BuildContext context) {
    return Text(
      "Reset your Password",
      style: TextStyle(
        fontSize: 30,
        color: Colors.black
      ),
    );
  }

  Widget _labelUpdatePassword(BuildContext context) {
    return Text(
      "You can create a new password for your account",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey
      ),
    );
  }

  Widget _buildTextField(IconData icon, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

}

