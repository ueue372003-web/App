import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:lnmq/models/user_model.dart';
import 'package:lnmq/services/auth_service.dart';
import 'package:lnmq/services/user_service.dart';
import 'package:lnmq/services/storage_service.dart';
import 'package:lnmq/screens/user_invoice_screen.dart';
import 'package:lnmq/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final StorageService _storageService = StorageService();

  // Controllers cho các trường thông tin
  late TextEditingController _displayNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _birthdateController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _nationalIdController;
  late TextEditingController _occupationController;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _birthdateController = TextEditingController();
    _emergencyContactController = TextEditingController();
    _emergencyPhoneController = TextEditingController();
    _nationalIdController = TextEditingController();
    _occupationController = TextEditingController();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _birthdateController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    _nationalIdController.dispose();
    _occupationController.dispose();
    super.dispose();
  }
  // ...existing code...
  // Thêm các biến cần thiết cho widget
  bool _isLoading = false;
  File? _pickedImage;
  String? _selectedGender;
  List<String> _genders = ['Nam', 'Nữ', 'Khác'];
  List<String> _travelPreferences = ['Biển', 'Núi', 'Thành phố', 'Văn hóa', 'Ẩm thực'];
  List<String> _selectedPreferences = [];

  void _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  void _selectBirthdate() async {
    // ...existing code for date picker...
  }

  void _updateProfile() async {
    // ...existing code for update logic...
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    User? currentUser = _authService.getCurrentUser();

    return StreamBuilder<AppUser?> (
      stream: currentUser != null ? _userService.getUserData(currentUser.uid) : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !_isLoading) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        AppUser? appUser = snapshot.data;
        String? currentPhotoUrl = currentUser?.photoURL ?? appUser?.photoUrl;

        return Scaffold(
          appBar: AppBar(
            title: Text(localizations?.profileTitle ?? '', style: TextStyle(color: Colors.black87)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              TextButton.icon(
                onPressed: () async {
                  await _authService.signOut();
                  if (mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
                  }
                },
                icon: Icon(Icons.logout, color: Colors.redAccent),
                label: Text(
                  localizations?.logout ?? '',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blueGrey[100],
                        backgroundImage: _pickedImage != null
                            ? FileImage(_pickedImage!) as ImageProvider<Object>
                            : (currentPhotoUrl != null ? NetworkImage(currentPhotoUrl) : null),
                        child: _pickedImage == null && currentPhotoUrl == null
                            ? Icon(Icons.person, size: 60, color: Colors.blueGrey)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.blueAccent),
                          onPressed: _pickImage,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: CircleBorder(),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),

                Text(
                  localizations?.basicInfo ?? '',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    labelText: localizations?.displayName ?? '',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: localizations?.phoneNumber ?? '',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.phone),
                    hintText: localizations?.phoneHint ?? '',
                  ),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: localizations?.address ?? '',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.location_on),
                    hintText: localizations?.addressHint ?? '',
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _birthdateController,
                        readOnly: true,
                        onTap: _selectBirthdate,
                        decoration: InputDecoration(
                          labelText: localizations?.birthdate ?? '',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: Icon(Icons.calendar_today),
                          hintText: localizations?.birthdateHint ?? '',
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          labelText: localizations?.gender ?? '',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: Icon(Icons.people),
                        ),
                        items: _genders.map((gender) {
                          return DropdownMenuItem(value: gender, child: Text(gender));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _occupationController,
                  decoration: InputDecoration(
                    labelText: localizations?.occupation ?? '',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.work),
                    hintText: localizations?.occupationHint ?? '',
                  ),
                ),
                SizedBox(height: 24),

                Text(
                  localizations?.emergencyContact ?? '',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _emergencyContactController,
                  decoration: InputDecoration(
                    labelText: localizations?.emergencyContactName ?? '',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.contact_emergency),
                    hintText: localizations?.emergencyContactHint ?? '',
                  ),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _emergencyPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: localizations?.emergencyPhone ?? '',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.phone_in_talk),
                    hintText: localizations?.phoneHint ?? '',
                  ),
                ),
                SizedBox(height: 24),

                Text(
                  localizations?.additionalInfo ?? '',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _nationalIdController,
                  decoration: InputDecoration(
                    labelText: localizations?.nationalId ?? '',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.badge),
                    hintText: localizations?.nationalIdHint ?? '',
                  ),
                ),
                SizedBox(height: 16),

                Text(
                  localizations?.travelPreferences ?? '',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _travelPreferences.map((preference) {
                    final isSelected = _selectedPreferences.contains(preference);
                    return FilterChip(
                      label: Text(preference),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedPreferences.add(preference);
                          } else {
                            _selectedPreferences.remove(preference);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Text(localizations?.updateProfile ?? '', style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserInvoiceScreen()),
                      );
                    },
                    icon: Icon(Icons.receipt_long),
                    label: Text(localizations?.viewInvoice ?? ''),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                Text(
                  localizations?.profileNote ?? '',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
