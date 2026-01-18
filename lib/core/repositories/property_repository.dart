import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/property_model.dart';

abstract class PropertyRepository {
  Future<List<Property>> getProperties({
    String? query,
    String? propertyType,
    double? minPrice,
    double? maxPrice,
    int? bedrooms,
  });
  Future<Property> getPropertyById(String id);
  Future<void> createProperty(Property property, List<File> imageFiles);
  Future<void> updateProperty(Property property);
  Future<void> deleteProperty(String id);
  Future<List<Property>> getMyProperties();
}

class SupabasePropertyRepository implements PropertyRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<List<Property>> getProperties({
    String? query,
    String? propertyType,
    double? minPrice,
    double? maxPrice,
    int? bedrooms,
  }) async {
    var request = _supabase.from('properties').select();

    if (query != null && query.isNotEmpty) {
      request = request.or('title.ilike.%$query%,address.ilike.%$query%');
    }

    if (propertyType != null) {
      request = request.eq('property_type', propertyType);
    }

    if (minPrice != null) {
      request = request.gte('price', minPrice);
    }

    if (maxPrice != null) {
      request = request.lte('price', maxPrice);
    }

    if (bedrooms != null) {
      request = request.eq('bedrooms', bedrooms);
    }

    final data = await request.order('created_at', ascending: false);
    return (data as List).map((json) => Property.fromJson(json)).toList();
  }

  @override
  Future<Property> getPropertyById(String id) async {
    final data = await _supabase.from('properties').select().eq('id', id).single();
    return Property.fromJson(data);
  }

  @override
  Future<void> createProperty(Property property, List<File> imageFiles) async {
    final List<String> imageUrls = [];

    // Upload images to Supabase Storage
    for (var i = 0; i < imageFiles.length; i++) {
      final file = imageFiles[i];
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      final path = 'property_images/${property.ownerId}/$fileName';

      await _supabase.storage.from('property_images').upload(path, file);
      final url = _supabase.storage.from('property_images').getPublicUrl(path);
      imageUrls.add(url);
    }

    final propertyWithImages = property.copyWith(images: imageUrls);
    await _supabase.from('properties').insert(propertyWithImages.toJson());
  }

  @override
  Future<void> updateProperty(Property property) async {
    await _supabase.from('properties').update(property.toJson()).eq('id', property.id!);
  }

  @override
  Future<void> deleteProperty(String id) async {
    await _supabase.from('properties').delete().eq('id', id);
  }

  @override
  Future<List<Property>> getMyProperties() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final data = await _supabase
        .from('properties')
        .select()
        .eq('owner_id', userId)
        .order('created_at', ascending: false);
    
    return (data as List).map((json) => Property.fromJson(json)).toList();
  }
}
