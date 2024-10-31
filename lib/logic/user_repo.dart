abstract class UserRepository {
  Future<void> registrationUser(String email, String password, String name);
  Future<Map<String, dynamic>?> loginUser(String email, String password);
  Future<List<Map<String, dynamic>>> getAllUsers(); 
  Future<void> clearUsers(); 
}
