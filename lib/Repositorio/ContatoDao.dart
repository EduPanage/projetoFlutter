import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'Contato.dart';

class ContatoSecureDAO {
  static final ContatoSecureDAO _instance = ContatoSecureDAO._internal();
  factory ContatoSecureDAO() => _instance;
  ContatoSecureDAO._internal();

  final _storage = const FlutterSecureStorage();
  final String _contactsKey = 'contacts_list';
  
  // Método auxiliar para obter o próximo ID disponível
  Future<int> _getNextId() async {
    final contacts = await getContatos();
    if (contacts.isEmpty) return 1;
    return contacts.map((c) => c.id ?? 0).reduce((max, id) => id > max ? id : max) + 1;
  }

  // Salva a lista completa de contatos
  Future<void> _saveContacts(List<Contato> contacts) async {
    final contactsJson = contacts.map((contact) => contact.paraMapa()).toList();
    await _storage.write(
      key: _contactsKey,
      value: jsonEncode(contactsJson),
    );
  }

  // Insere um novo contato
  Future<void> insertContato(Contato contato) async {
    final contacts = await getContatos();
    if (contato.id == null) {
      contato = Contato(
        id: await _getNextId(),
        nome: contato.nome,
        telefone: contato.telefone,
        email: contato.email,
      );
    }
    contacts.add(contato);
    await _saveContacts(contacts);
  }

  // Atualiza um contato existente
  Future<void> updateContato(Contato contato) async {
    if (contato.id == null) return;
    
    final contacts = await getContatos();
    final index = contacts.indexWhere((c) => c.id == contato.id);
    
    if (index != -1) {
      contacts[index] = contato;
      await _saveContacts(contacts);
    }
  }

  // Obtém todos os contatos
  Future<List<Contato>> getContatos() async {
    final contactsJson = await _storage.read(key: _contactsKey);
    if (contactsJson == null) return [];

    List<dynamic> decodedList = jsonDecode(contactsJson);
    return decodedList.map((json) => Contato.deMapa(Map<String, dynamic>.from(json))).toList();
  }

  // Remove um contato pelo ID
  Future<void> deleteContato(int id) async {
    final contacts = await getContatos();
    contacts.removeWhere((contact) => contact.id == id);
    await _saveContacts(contacts);
  }

  // Limpa todos os contatos
  Future<void> clearAll() async {
    await _storage.delete(key: _contactsKey);
  }
}