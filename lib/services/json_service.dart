import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/company_model.dart';

class JsonService {
  Future<Company> loadCompanyData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/company_data.json');
      final Map<String, dynamic> data = json.decode(response);
      return Company.fromJson(data['company']);
    } catch (e) {
      throw Exception('Failed to load company data: $e');
    }
  }
}