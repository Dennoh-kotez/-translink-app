import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:translink/services/appwrite_service.dart';
import 'package:translink/services/profile_service.dart';
import 'package:translink/screens/login_screen.dart';

class ProfileTab extends StatefulWidget {
  final AppwriteService authService;
  final ProfileService profileService;

  const ProfileTab({super.key, required this.authService, required this.profileService});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final bool _isDarkMode = false;
  final bool _notificationsEnabled = true;
  bool _isLoading = false;
  String _userName = 'John Doe';
  String _userEmail = 'johndoe@example.com';
  String? _userImageUrl; // Profile image URL for display

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
Future<void> _loadUserData() async {
  setState(() => _isLoading = true);
  try {
    final userData = await widget.authService.getCurrentUser();
    final userPrefs = await widget.authService.getUserPreferences();
    
    setState(() {
      _userName = userData.$id;
      _userEmail = userData.email;
      _userImageUrl = userPrefs.data['profileImage'] ?? 'https://picsum.photos/200';
    });
  } catch (e) {
    _showErrorDialog('Failed to load user data');
  } finally {
    setState(() => _isLoading = false);
  }
}
  // Image picker and uploader
  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _isLoading = true);
      try {
        final uploadedImageUrl = await widget.profileService.uploadProfilePicture(File(pickedFile.path), _userName);
        setState(() => _userImageUrl = uploadedImageUrl);
        await widget.authService.updateUserPreferences({'profileImage': uploadedImageUrl});
      } catch (e) {
        _showErrorDialog('Error uploading image: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  // Logout function
  Future<void> _handleLogout() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await widget.authService.logout();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen(authService: widget.authService)),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        _showErrorDialog('Logout failed: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _pickAndUploadImage,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_isLoading) const CircularProgressIndicator(),
              CircleAvatar(
                radius: 50,
                backgroundImage: _userImageUrl != null ? NetworkImage(_userImageUrl!) : null,
                child: _isLoading ? const CircularProgressIndicator() : null,
              ),
              const SizedBox(height: 16),
              Text(_userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(_userEmail, style: const TextStyle(fontSize: 16)),
              ElevatedButton(
                onPressed: _handleLogout,
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
