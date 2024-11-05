import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'usuario.dart';
import 'secure_user_storage.dart';

class UsuarioDAO {
  static final UsuarioDAO _instance = UsuarioDAO._internal();
  factory UsuarioDAO() => _instance;
  UsuarioDAO._internal();

  Database? _database;
  final SecureUserStorage _secureStorage = SecureUserStorage();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'contatos.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE contatos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            telefone TEXT,
            email TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            email TEXT UNIQUE
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE usuarios(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nome TEXT,
              email TEXT UNIQUE
            )
          ''');
        }
      },
    );
  }

  // Insere um novo usuário dividindo dados entre SQLite e SecureStorage
  Future<void> insertUsuario(Usuario usuario) async {
    final db = await database;
    
    // Armazena dados não sensíveis no SQLite
    await db.insert(
      'usuarios',
      {
        'nome': usuario.nome,
        'email': usuario.email,
      },
      conflictAlgorithm: ConflictAlgorithm.replace
    );

    // Armazena credenciais no SecureStorage
    await _secureStorage.saveUserCredentials(usuario);
  }

  // Busca um usuário combinando dados do SQLite e SecureStorage
  Future<Usuario?> getUsuarioByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isEmpty) return null;

    // Recupera as credenciais do SecureStorage
    final credentials = await _secureStorage.getUserCredentials(email);
    if (credentials == null) return null;

    // Combina os dados do SQLite com as credenciais seguras
    return Usuario(
      id: maps.first['id'] as int,
      nome: maps.first['nome'] as String,
      email: maps.first['email'] as String,
      senha: credentials['senha'] ?? '',
    );
  }

  // Deleta um usuário de ambos os storages
  Future<void> deleteUsuario(String email) async {
    final db = await database;
    await db.delete(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
    );
    await _secureStorage.deleteUserCredentials(email);
  }
}