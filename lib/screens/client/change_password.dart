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

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmedPasswordController = TextEditingController();
  bool _isUploading = false;
  String _id = "";

  // Thêm biến để kiểm soát ẩn/hiện mật khẩu
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false); 
    if (userProvider.user?.id != null) {
      _id = userProvider.user?.id ?? "";
    }
  }

  Future<void> _submitChangePassword() async {
    final user = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      _isUploading = true;
    });

    final changePasswordData = ChangePasswordInfo(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmedPasswordController.text,
    );

    String message = await user.changeUserPassword(changePasswordData, _id);

    if (user.errorMessage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      setState(() {
        _isUploading = false;
      });
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(user.errorMessage)),
      );
    }
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
            _buildPasswordField(
              icon: Icons.lock,
              label: "Current Password",
              controller: _currentPasswordController,
              obscureText: _obscureCurrentPassword,
              toggleObscure: () {
                setState(() {
                  _obscureCurrentPassword = !_obscureCurrentPassword;
                });
              },
            ),
            _buildPasswordField(
              icon: Icons.lock,
              label: "New Password",
              controller: _newPasswordController,
              obscureText: _obscureNewPassword,
              toggleObscure: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
            ),
            _buildPasswordField(
              icon: Icons.lock,
              label: "Confirm Password",
              controller: _confirmedPasswordController,
              obscureText: _obscureConfirmPassword,
              toggleObscure: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUploading ? null : _submitChangePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: _isUploading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Change Password", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  // Custom password text field with toggle visibility
  Widget _buildPasswordField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleObscure,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: toggleObscure,
          ),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}


