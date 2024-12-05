import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';

class AppwriteService {
  final Client client;
  late Account account;

  // Class constants
  static const String ENDPOINT = "https://cloud.appwrite.io/v1";
  static const String PROJECT_ID = 'translink00';

  AppwriteService() : client = Client() {
    client
      .setEndpoint(ENDPOINT)
      .setProject(PROJECT_ID);
    account = Account(client);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      await account.getSession(sessionId: 'current');
      return true;
    } catch (e) {
      return false;
    }
  }

  // Create new account
  Future<User> createAccount(String email, String password, String name) async {
    try {
      final user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      // Automatically login after account creation
      await createEmailSession(email, password);
      return user;
    } on AppwriteException catch (e) {
      if (e.code == 409) {
        throw 'A user with this email already exists.';
      } else {
        throw 'Error creating account: ${e.message}';
      }
    } catch (e) {
      throw 'Unexpected error: $e';
    }
  }

  // Email Login
  Future<Session> createEmailSession(String email, String password) async {
    try {
      final session = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      return session;
    } on AppwriteException catch (e) {
      throw 'Login failed: ${e.message}';
    } catch (e) {
      throw 'Unexpected error during login: $e';
    }
  }

  // Google Login
    Future<Session> createGoogleSession() async {
    try {
      // Create OAuth2 session for Google
      final session = await account.createOAuth2Session(
        provider: OAuthProvider.google,
        success: 'http://localhost:8000/google-callback',
        failure: 'http://localhost:8000/google-callback',
                        // Replace with your success URL
                                         // Replace with your failure URL
      );
      return session;
    } on AppwriteException catch (e) {
      throw 'Google login failed: ${e.message}';
    } catch (e) {
      throw 'Unexpected error during Google login: $e';
    }
  }
  // Get current user data
  Future<User> getCurrentUser() async {
    try {
      final user = await account.get();
      return user;
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        throw 'User is not logged in';
      }
      throw 'Error getting user data: ${e.message}';
    } catch (e) {
      throw 'Unexpected error getting user data: $e';
    }
  }

  // Enhanced logout method
  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        // Already logged out
        return;
      }
      throw 'Logout failed: ${e.message}';
    } catch (e) {
      throw 'Unexpected error during logout: $e';
    }
  }

  // Logout from all devices
  Future<void> logoutAll() async {
    try {
      final sessions = await account.listSessions();
      for (var session in sessions.sessions) {
        try {
          await account.deleteSession(sessionId: session.$id);
        } catch (e) {
          print('Error deleting session ${session.$id}: $e');
        }
      }
    } catch (e) {
      throw 'Error logging out from all devices: $e';
    }
  }

  // Get user preferences
  Future<Preferences> getUserPreferences() async {
    try {
      return await account.getPrefs();
    } on AppwriteException catch (e) {
      throw 'Error getting user preferences: ${e.message}';
    }
  }

  // Update user preferences
// Update user preferences
Future<User> updateUserPreferences(Map<String, dynamic> preferences) async {
  try {
    return await account.updatePrefs(prefs: preferences);
  } on AppwriteException catch (e) {
    throw 'Error updating user preferences: ${e.message}';
  }
}

  // Update user profile
  Future<User> updateUser({String? name, String? phone}) async {
    try {
      User user = await account.get();
      
      if (name != null) {
        user = await account.updateName(name: name);
      }
      
      if (phone != null) {
        // Note: Updating phone number usually requires verification
        user = await account.updatePhone(
          phone: phone,
          password: await _getPassword(), // You'll need to implement this
        );
      }
      
      return user;
    } on AppwriteException catch (e) {
      throw 'Error updating user: ${e.message}';
    }
  }

  // Update email
  Future<User> updateEmail(String email, String password) async {
    try {
      return await account.updateEmail(
        email: email,
        password: password,
      );
    } on AppwriteException catch (e) {
      throw 'Error updating email: ${e.message}';
    }
  }

  // Update password
  Future<User> updatePassword(String password, String oldPassword) async {
    try {
      return await account.updatePassword(
        password: password,
        oldPassword: oldPassword,
      );
    } on AppwriteException catch (e) {
      throw 'Error updating password: ${e.message}';
    }
  }

  // Helper method to get password (you'll need to implement this based on your app's security requirements)
  Future<String> _getPassword() async {
    throw UnimplementedError('Password retrieval method not implemented');
  }
}