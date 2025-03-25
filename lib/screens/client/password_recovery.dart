import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/screens/client/submit_otp.dart';
import 'package:ecommerce_app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordRecoveryScreen extends StatefulWidget {

  const PasswordRecoveryScreen({super.key});

  @override
  _PasswordRecoveryScreenState createState() => _PasswordRecoveryScreenState();

}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen>{

  final TextEditingController _emailController = TextEditingController();

  Future<void> _requestOTP(UserProvider user) async {

    final email = {
      "email": _emailController.text
    };

    final message = await user.getAccountOTP(email);

    if(message != "") {
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
      MaterialPageRoute(builder: (context) => SubmitOTPScreen(email: _emailController.text)),
    );

  }

  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarHelper(header: ""),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerPasswordRecovery(context),
            _labelPasswordRecovery(context),
            SizedBox(height: 20),
            _buildTextField(Icons.email, "Enter your email", _emailController),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: userProvider.isLoading ? null : () {
                  _requestOTP(userProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: userProvider.isLoading ? CircularProgressIndicator(color: Colors.white) : Text("Get OTP", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerPasswordRecovery(BuildContext context) {
    return Text(
      "Forget Password ?",
      style: TextStyle(
        fontSize: 30,
        color: Colors.black
      ),
    );
  }

  Widget _labelPasswordRecovery(BuildContext context) {
    return Text(
      "Enter the email address associated with your acccount.",
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

