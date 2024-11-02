import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'usuario.dart';

class UsuarioDAO {
  // Singleton para garantir uma única instância do DAO
  static final UsuarioDAO _instance = UsuarioDAO._internal();
  factory UsuarioDAO() => _instance; // Fábrica para criar a instância
  UsuarioDAO._internal();

  Database? _database; // Variável para armazenar a instância do banco de dados

  // Método para obter a instância do banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(); // Inicializa o banco de dados se não existir
    return _database!;
  }

  // Método para inicializar o banco de dados
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'contatos.db'); // Define o caminho do banco
    return await openDatabase(
      path,
      version: 2, // Versão do banco de dados
      onCreate: (db, version) async {
        // Cria as tabelas no primeiro uso
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
            email TEXT UNIQUE,
            senha TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Atualiza o banco de dados se a versão for antiga
        if (oldVersion < 2) {
          await db.execute(''' 
            CREATE TABLE usuarios(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nome TEXT,
              email TEXT UNIQUE,
              senha TEXT
            )
          ''');
        }
      },
    );
  }

  // Insere um novo usuário no banco de dados
  Future<void> insertUsuario(Usuario usuario) async {
    final db = await database;
    await db.insert('usuarios', usuario.paraMapa(),
        conflictAlgorithm: ConflictAlgorithm.replace); // Substitui em caso de conflito
  }

  // Busca um usuário pelo email
  Future<Usuario?> getUsuarioByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email], // Argumento para a consulta
    );

    if (maps.isEmpty) return null; // Retorna null se não encontrar
    return Usuario.deMapa(maps.first); // Retorna o usuário encontrado
  }
}
