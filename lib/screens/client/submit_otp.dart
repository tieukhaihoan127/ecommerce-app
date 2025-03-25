import 'package:ecommerce_app/models/otp_verify.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/screens/client/update_password.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class SubmitOTPScreen extends StatefulWidget {

  final String email;

  const SubmitOTPScreen({super.key, required this.email});

  @override
  _SubmitOTPScreenState createState() => _SubmitOTPScreenState();
  
}

class _SubmitOTPScreenState extends State<SubmitOTPScreen> {

  final TextEditingController _otpController = TextEditingController();

  late String userEmail;

  @override
  void initState() {
    super.initState();
    userEmail = widget.email;
  }

  Future<void> _verifyOTP() async {

    final user = Provider.of<UserProvider>(context, listen: false);

    final verifyInfo = OTPVerify(
      email: userEmail, 
      otp: _otpController.text
    );

    final message = await user.submitAccountOTPPost(verifyInfo);

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
      MaterialPageRoute(builder: (context) => UpdatePasswordScreen()),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Verification Code",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Enter the verification code we just sent you on your email address.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 24),
            Text("OTP", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Center(
              child: Pinput(
                length: 6,
                controller: _otpController,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 50,
                  textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("If you didn't receive a code? "),
                GestureDetector(
                  onTap: () {
                    // Xử lý gửi lại mã OTP
                  },
                  child: Text(
                    "Resend Code",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _verifyOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Get OTP",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

