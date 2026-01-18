import 'dart:convert';
import 'package:flutter/services.dart';

class EnvConfig {
  static Map<String, dynamic> _config = {};

  static Future<void> initialize() async {
    final configString = await rootBundle.loadString('env.json');
    _config = json.decode(configString);
  }

  static String get supabaseUrl => _config['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => _config['SUPABASE_ANON_KEY'] ?? '';
  static String get openaiApiKey => _config['OPENAI_API_KEY'] ?? '';
  static String get geminiApiKey => _config['GEMINI_API_KEY'] ?? '';
  static String get anthropicApiKey => _config['ANTHROPIC_API_KEY'] ?? '';
  static String get perplexityApiKey => _config['PERPLEXITY_API_KEY'] ?? '';
  static String get googleWebClientId => _config['GOOGLE_WEB_CLIENT_ID'] ?? '';
}
