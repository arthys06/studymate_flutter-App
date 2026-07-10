import '../models/user_model.dart';

/// Holds the currently logged-in user for the life of the app session.
/// Simple in-memory approach — resets on app restart (user must log in
/// again each time the app is fully closed). Good enough for a demo;
/// add shared_preferences later if you want persistent login.
class Session {
  static UserModel? currentUser;

  static void login(UserModel user) {
    currentUser = user;
  }

  static void logout() {
    currentUser = null;
  }

  static bool get isLoggedIn => currentUser != null;
}
