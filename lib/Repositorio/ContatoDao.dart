import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Contato.dart';

class ContatoDAO {
  static final ContatoDAO _instance = ContatoDAO._internal();
  factory ContatoDAO() => _instance; // Singleton para garantir uma única instância
  ContatoDAO._internal();

  Database? _database; // Variável para armazenar a instância do banco de dados

  // Método para obter a instância do banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(); // Inicializa o banco se não existir
    return _database!;
  }

  // Inicializa o banco de dados e cria a tabela de contatos
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'contatos.db'); // Define o caminho do banco
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE contatos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            telefone TEXT,
            email TEXT
          )
        ''' ); // Cria a tabela de contatos
      },
    );
  }

  // Insere um novo contato no banco de dados
  Future<void> insertContato(Contato contato) async {
    final db = await database; // Obtém a instância do banco
    await db.insert('contatos', contato.paraMapa(), conflictAlgorithm: ConflictAlgorithm.replace); // Insere o contato
  }

  // Atualiza um contato existente no banco de dados
  Future<void> updateContato(Contato contato) async {
    final db = await database; // Obtém a instância do banco
    await db.update(
      'contatos',
      contato.paraMapa(),
      where: 'id = ?',
      whereArgs: [contato.id],
    ); // Atualiza o contato com o id fornecido
  }

  // Obtém a lista de contatos do banco de dados
  Future<List<Contato>> getContatos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('contatos'); // Consulta a tabela de contatos

    // Converte os mapas em objetos Contato
    return List.generate(maps.length, (i) {
      return Contato.deMapa(maps[i]);
    });
  }

  // Remove um contato do banco de dados pelo id
  Future<void> deleteContato(int id) async {
    final db = await database;
    await db.delete('contatos', where: 'id = ?', whereArgs: [id]); // Deleta o contato com o id fornecido
  }
}
