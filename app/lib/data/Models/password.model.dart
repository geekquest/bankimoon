import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart'; // For encryption

class PasswordModel {
  static const String _tableName = 'password_store';
  Database? _db;

  Future<void> _initDatabase() async {
    try {
      _db ??= await openDatabase(
        'passwords.db',
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $_tableName (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              encrypted_password TEXT NOT NULL
            );
          ''');
        },
      );
    } catch (e) {
      log("Error initializing database: $e");
    }
  }

  Future<void> _showSnackbar(BuildContext context, String message,
      {bool isError = false}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  /// Check if a password exists in the database.
  Future<bool> checkIfPasswordExistsInSQLite() async {
    await _initDatabase();
    try {
      final count = Sqflite.firstIntValue(
        await _db!.rawQuery('SELECT COUNT(*) FROM $_tableName'),
      );
      return count != null && count > 0;
    } catch (e) {
      log("Error checking password existence: $e");
      throw Exception("Error checking password existence");
    }
  }

  /// Save a new password to the database.
  Future<bool> savePasswordToSQLite(String password, BuildContext context) async {
    await _initDatabase();
    try {
      final encryptedPassword = _encryptPassword(password);
      final id = await _db!.insert(
        _tableName,
        {'encrypted_password': encryptedPassword},
      );
      if (id > 0) {
        if(context.mounted) {
          _showSnackbar(context, "Password saved successfully");
        } 
        return true;
      }
      return false;
    } catch (e) {
      if(context.mounted) {
        _showSnackbar(context, "Error saving password: $e", isError: true);
      }
      return false;
    }
  }

  /// Validate the given password against the stored password.
  Future<bool> validatePassword(String password, BuildContext context) async {
    await _initDatabase();
    try {
      final encryptedPassword = _encryptPassword(password);
      final result = await _db!.query(
        _tableName,
        where: 'encrypted_password = ?',
        whereArgs: [encryptedPassword],
      );
      if (result.isNotEmpty) {
        return true;
      }
      if(context.mounted) {
        _showSnackbar(context, "Invalid password", isError: true);
      } 
      return false;
    } catch (e) {
      if(context.mounted) {
        _showSnackbar(context, "Error validating password: $e", isError: true);
      }
      return false;
    }
  }

  /// Change the stored password to a new one.
  Future<bool> changePassword(String newPassword, BuildContext context) async {
    await _initDatabase();
    try {
      final encryptedPassword = _encryptPassword(newPassword);
      final result = await _db!.update(
        _tableName,
        {'encrypted_password': encryptedPassword},
        where: 'id = ?',
        whereArgs: [1],
      );
      if (result > 0) {
        if(context.mounted) {
          _showSnackbar(context, "Password changed successfully");
        }
        return true;
      }
      return false;
    } catch (e) {
      if(context.mounted) {
        _showSnackbar(context, "Error changing password: $e", isError: true);
      } 
      return false;
    }
  }

  /// Delete the stored password.
  Future<bool> deletePassword(BuildContext context) async {
    await _initDatabase();
    try {
      final result = await _db!.delete(_tableName);
      if (result > 0) {
        if(context.mounted) {
          _showSnackbar(context, "Password deleted successfully");
        }
        return true;
      }
      return false;
    } catch (e) {
      if(context.mounted) {
        _showSnackbar(context, "Error deleting password: $e", isError: true);
      }
      return false;
    }
  }

  /// Encrypt the password using SHA-256.
  String _encryptPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }
}
