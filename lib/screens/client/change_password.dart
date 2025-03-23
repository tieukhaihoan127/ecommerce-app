import 'package:ecommerce_app/models/change_password.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {

  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();

}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>{

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmedPasswordController = TextEditingController();
  bool _isUploading = false;
  String _id = "";

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false); 
    
    if(userProvider.user?.id != null) {
      _id = userProvider.user?.id ?? "";
    }

  }

  Future<void> _submitChangePassword() async {

    final user = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      _isUploading = true;
    });

    // if(_newPasswordController.text != _confirmedPasswordController.text) {

    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Mật khẩu nhập lại không chính xác")),
    //   );

    //   _currentPasswordController.clear();
    //   _newPasswordController.clear();
    //   _confirmedPasswordController.clear();

    // }

    // if(_newPasswordController.text == "" || _confirmedPasswordController.text == "" || _currentPasswordController.text == "") {

    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
    //   );

    //   _currentPasswordController.clear();
    //   _newPasswordController.clear();
    //   _confirmedPasswordController.clear();

    // }

    final changePasswordData = ChangePasswordInfo(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmedPasswordController.text
      );

    String message = await user.changeUserPassword(changePasswordData, _id);

    if(user.errorMessage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

      setState(() {
        _isUploading = false;
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(user.errorMessage)),
      );
    }

    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarHelper(header: "Change Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(Icons.lock, "Current Password", _currentPasswordController),
            _buildTextField(Icons.lock, "New Password", _newPasswordController),
            _buildTextField(Icons.lock, "Confirm Password", _confirmedPasswordController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUploading ? null : _submitChangePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: _isUploading ? CircularProgressIndicator(color: Colors.white) : Text("Change Password", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
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

