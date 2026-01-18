import 'package:google_generative_ai/google_generative_ai.dart';
import '../utils/env_config.dart';

class AiService {
  static final AiService _instance = AiService._internal();
  factory AiService() => _instance;
  AiService._internal();

  GenerativeModel? _model;

  void initialize() {
    final apiKey = EnvConfig.geminiApiKey;
    if (apiKey.isNotEmpty) {
      _model = GenerativeModel(
        model: 'gemini-1.5-pro',
        apiKey: apiKey,
      );
    }
  }

  bool get isInitialized => _model != null;

  /// Generates AI suggestions for contract fields based on provided context.
  Future<List<Map<String, dynamic>>> getContractSuggestions(Map<String, dynamic> context) async {
    if (_model == null) {
      // Mock suggestions if API key is missing
      return [
        {
          "field": "securityDeposit",
          "suggestion": "₦1,000,000",
          "reason": "Standard practice in Lagos is 2x monthly rent for security deposit",
          "confidence": 0.95,
        },
        {
          "field": "leaseDuration",
          "suggestion": "1 Year",
          "reason": "Most common lease duration for residential properties in Nigeria",
          "confidence": 0.92,
        },
      ];
    }

    final prompt = '''
    You are a legal assistant for a real estate platform in Nigeria.
    Based on the following property and party details, suggest values for the contract fields.
    Context: $context
    
    Return a JSON list of suggestions with "field", "suggestion", "reason", and "confidence" (0.0 to 1.0).
    ''';

    try {
      final content = [Content.text(prompt)];
      await _model!.generateContent(content);
      // Parse response and return
      // For now, returning mock or simplified parsing
      return []; 
    } catch (e) {
      print('Error generating suggestions: $e');
      return [];
    }
  }

  /// Initiates the LangGraph contract generation workflow.
  Future<Map<String, dynamic>> generateContract(Map<String, dynamic> formData) async {
    // 1. Compliance Check
    final compliance = await checkCompliance(formData);
    if (!compliance['is_compliant']) {
      return {
        "status": "error",
        "error": "Compliance failure: ${compliance['reason']}",
        "requires_human_review": compliance['requires_human_review'],
      };
    }

    // 2. Generate Draft (Simulating LangGraph orchestration)
    await Future.delayed(const Duration(seconds: 3));
    
    return {
      "status": "success",
      "contract_id": "CNT-${DateTime.now().millisecondsSinceEpoch}",
      "draft": "This is a contract draft for ${formData['propertyAddress']}. \n\n"
               "Rent: ${formData['monthlyRent']} \n"
               "Duration: ${formData['leaseDuration']} \n\n"
               "This contract is compliant with the Ghana Rent Act (Act 220).",
    };
  }

  /// Checks if the contract data complies with local laws (e.g., Ghana Rent Act).
  Future<Map<String, dynamic>> checkCompliance(Map<String, dynamic> formData) async {
    // Rule: Advance rent should not exceed 6 months (Ghana Rent Act 220)
    final leaseDuration = formData['leaseDuration']?.toString().toLowerCase() ?? '';
    int advanceMonths = 0;
    if (leaseDuration.contains('year')) {
      advanceMonths = 12; // Simplified logic
    } else if (leaseDuration.contains('month')) {
      advanceMonths = int.tryParse(leaseDuration.split(' ')[0]) ?? 0;
    }

    // For demonstration, let's assume the user entered an advance period
    // In a real app, this would be a specific field
    final isCompliant = advanceMonths <= 6;

    return {
      "is_compliant": isCompliant,
      "reason": isCompliant ? "Compliant" : "Advance rent exceeds 6 months (Act 220 violation)",
      "requires_human_review": !isCompliant,
    };
  }

  /// Generates a dynamic GenUI form structure based on the selected contract type.
  Future<List<Map<String, dynamic>>> getGenUiForm(String contractType) async {
    if (_model == null) {
      // Mock GenUI form structure
      return [
        {
          "step": 1,
          "question": "First, let's confirm the property address. Is it {{propertyAddress}}?",
          "fields": [
            {"key": "propertyAddress", "type": "text", "label": "Property Address"}
          ]
        },
        {
          "step": 2,
          "question": "Great. Now, what is the monthly rent for this property?",
          "fields": [
            {"key": "monthlyRent", "type": "currency", "label": "Monthly Rent"}
          ]
        }
      ];
    }

    final prompt = '''
    Generate a conversational GenUI form structure for a $contractType in Ghana.
    The form should be step-by-step.
    Return a JSON list of steps, each with a "step" number, a "question", and a list of "fields" (key, type, label).
    ''';

    try {
      final content = [Content.text(prompt)];
      await _model!.generateContent(content);
      // Simplified parsing for now
      return [];
    } catch (e) {
      print('Error generating GenUI form: $e');
      return [];
    }
  }
}
