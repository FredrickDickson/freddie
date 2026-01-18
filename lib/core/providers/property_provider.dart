import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/property_repository.dart';
import '../models/property_model.dart';
import 'dart:io';

final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  return SupabasePropertyRepository();
});

final propertyListProvider = FutureProvider.family<List<Property>, Map<String, dynamic>>((ref, filters) async {
  return ref.watch(propertyRepositoryProvider).getProperties(
    query: filters['query'],
    propertyType: filters['propertyType'],
    minPrice: filters['minPrice'],
    maxPrice: filters['maxPrice'],
    bedrooms: filters['bedrooms'],
  );
});

final myPropertiesProvider = FutureProvider<List<Property>>((ref) async {
  return ref.watch(propertyRepositoryProvider).getMyProperties();
});

final propertyDetailsProvider = FutureProvider.family<Property, String>((ref, id) async {
  return ref.watch(propertyRepositoryProvider).getPropertyById(id);
});

class PropertyNotifier extends Notifier<AsyncValue<void>> {
  late final PropertyRepository _repository;

  @override
  AsyncValue<void> build() {
    _repository = ref.watch(propertyRepositoryProvider);
    return const AsyncValue.data(null);
  }

  Future<void> createProperty(Property property, List<File> imageFiles) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.createProperty(property, imageFiles));
  }

  Future<void> updateProperty(Property property) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.updateProperty(property));
  }

  Future<void> deleteProperty(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.deleteProperty(id));
  }
}

final propertyNotifierProvider = NotifierProvider<PropertyNotifier, AsyncValue<void>>(PropertyNotifier.new);
