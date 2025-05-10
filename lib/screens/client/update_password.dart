import 'package:ecommerce_app/core/config/responsive.dart';
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

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmedPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  String _id = "";

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user?.id != null) {
      _id = userProvider.user?.id ?? "";
    }
  }

  Future<void> _updatePassword(UserProvider user) async {
    final updatePasswordData = RememberUserToken(
      token: user.token,
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmedPasswordController.text,
    );

    String message = await user.updatePasswordPost(updatePasswordData);

    if (user.errorMessage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(user.errorMessage)),
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Signin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: const AppBarHelper(header: "Change Password"),
      ),
      body: Responsive(
        mobile: _buildForm(context, user),
        desktop: Center(
          child: SizedBox(
            width: 450,
            child: _buildForm(context, user),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, UserProvider user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerUpdatePassword(),
          const SizedBox(height: 8),
          _labelUpdatePassword(),
          const SizedBox(height: 24),
          _buildPasswordField(
            controller: _newPasswordController,
            label: "New Password",
            icon: Icons.lock,
            obscure: _obscureNewPassword,
            toggleVisibility: () {
              setState(() => _obscureNewPassword = !_obscureNewPassword);
            },
          ),
          const SizedBox(height: 12),
          _buildPasswordField(
            controller: _confirmedPasswordController,
            label: "Confirm Password",
            icon: Icons.lock,
            obscure: _obscureConfirmPassword,
            toggleVisibility: () {
              setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
            },
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: user.isLoading ? null : () => _updatePassword(user),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: user.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Reset Password", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerUpdatePassword() {
    return const Text(
      "Reset your Password",
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    );
  }

  Widget _labelUpdatePassword() {
    return const Text(
      "You can create a new password for your account",
      style: TextStyle(fontSize: 14, color: Colors.grey),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscure,
    required VoidCallback toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue),
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
