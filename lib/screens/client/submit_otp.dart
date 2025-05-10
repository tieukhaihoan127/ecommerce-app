import 'package:ecommerce_app/core/config/responsive.dart';
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
    final verifyInfo = OTPVerify(email: userEmail, otp: _otpController.text.trim());

    final message = await user.submitAccountOTPPost(verifyInfo);

    if (message != "") {
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
      MaterialPageRoute(builder: (context) => const UpdatePasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Responsive(
        mobile: _buildOTPForm(context),
        desktop: Center(
          child: SizedBox(
            width: 450,
            child: _buildOTPForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildOTPForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Verification Code",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Enter the verification code we just sent to your email address.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          const Text("OTP", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Center(
            child: Pinput(
              length: 6,
              controller: _otpController,
              defaultPinTheme: PinTheme(
                width: 56,
                height: 56,
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Didn't receive a code? "),
              GestureDetector(
                onTap: () {
                  // TODO: Resend OTP
                },
                child: const Text(
                  "Resend Code",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _verifyOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                "Submit OTP",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
