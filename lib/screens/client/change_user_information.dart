import 'dart:io';

import 'package:ecommerce_app/helpers/image_upload.dart';
import 'package:ecommerce_app/models/update_user_info.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();

}

class _MyAccountScreenState extends State<MyAccountScreen> {

  File? _image;
  String _userImage = "";
  String _id = "";
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();
  bool _isUploading = false;
  bool _hasImage = false;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController = TextEditingController(text: userProvider.user?.fullName); 
    _emailController = TextEditingController(text: userProvider.user?.email); 
    
    if(userProvider.user?.id != null) {
      _id = userProvider.user?.id ?? "";
    }

    if(userProvider.user?.imageUrl != null) {
      _hasImage = true;
      _userImage = userProvider.user?.imageUrl ?? "";
    }
  }

  Future<void> _pickImage() async {

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _hasImage = false;
        _userImage = "";
      });
    }

  }

  Future<void> _saveChanges() async {
    final user = Provider.of<UserProvider>(context, listen: false);

    if (_image == null && _userImage == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an image!")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    String? imageUrl = "";

    if(_userImage == "") {
      ImageUpload imgUpload = ImageUpload();
      imageUrl = await imgUpload.uploadImageToCloudinary(_image!);
    }
    else {
      imageUrl = _userImage;
    }


    setState(() {
      _isUploading = false;
    });

    if (imageUrl != null) {
      print("Image uploaded successfully: $imageUrl");

      final updatedUserData = UpdateUserInfo(
        email: _emailController.text,
        fullName: _nameController.text,
        imageUrl: imageUrl
      );

      await user.updateUser(updatedUserData, _id);

      if(user.errorMessage.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully!")),
        );
      }
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image upload failed!")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarHelper(header: "My Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _hasImage ? NetworkImage(_userImage) as ImageProvider : _image != null ? FileImage(_image!) : const NetworkImage('https://cdn-icons-png.flaticon.com/512/6596/6596121.png') as ImageProvider,
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.edit, size: 18, color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildTextField(Icons.person, "Name", _nameController),
            _buildTextField(Icons.email, "Email Id", _emailController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUploading ? null : _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: _isUploading ? CircularProgressIndicator(color: Colors.white) : Text("Save Changes", style: TextStyle(color: Colors.white, fontSize: 16)),
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