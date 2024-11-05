class SecureUserStorage {
  static final SecureUserStorage _instance = SecureUserStorage._internal();
  factory SecureUserStorage() => _instance;
  SecureUserStorage._internal();

  final _storage = const FlutterSecureStorage();
  final String _keyPrefix = 'user_';

  // Salva as credenciais do usuário de forma segura
  Future<void> saveUserCredentials(Usuario usuario) async {
    final userJson = json.encode({
      'email': usuario.email,
      'senha': usuario.senha,
      // Não armazenamos o ID aqui pois ele fica no SQLite
    });
    await _storage.write(key: _keyPrefix + usuario.email, value: userJson);
  }

  // Recupera as credenciais do usuário
  Future<Map<String, String>?> getUserCredentials(String email) async {
    final userJson = await _storage.read(key: _keyPrefix + email);
    if (userJson == null) return null;
    return Map<String, String>.from(json.decode(userJson));
  }

  // Remove as credenciais do usuário
  Future<void> deleteUserCredentials(String email) async {
    await _storage.delete(key: _keyPrefix + email);
  }

  // Limpa todas as credenciais armazenadas
  Future<void> clearAllCredentials() async {
    await _storage.deleteAll();
  }