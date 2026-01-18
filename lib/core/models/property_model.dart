class Property {
  final String? id;
  final String ownerId;
  final String title;
  final String description;
  final double price;
  final String address;
  final String propertyType; // Apartment, House, etc.
  final String category; // Rent, Sale, Short-let
  final int bedrooms;
  final int bathrooms;
  final String? area;
  final List<String> images;
  final List<String> amenities;
  final double averageRating;
  final List<Map<String, dynamic>> reviews;
  final Map<String, int> ratingBreakdown;
  final double latitude;
  final double longitude;
  final bool isVerified;
  final DateTime? createdAt;

  Property({
    this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.price,
    required this.address,
    required this.propertyType,
    required this.category,
    required this.bedrooms,
    required this.bathrooms,
    this.area,
    this.images = const [],
    this.amenities = const [],
    this.averageRating = 0.0,
    this.reviews = const [],
    this.ratingBreakdown = const {"1": 0, "2": 0, "3": 0, "4": 0, "5": 0},
    required this.latitude,
    required this.longitude,
    this.isVerified = false,
    this.createdAt,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      ownerId: json['owner_id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      address: json['address'],
      propertyType: json['property_type'],
      category: json['category'] ?? 'Rent',
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
      area: json['area'],
      images: List<String>.from(json['images'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      averageRating: (json['average_rating'] as num? ?? 0.0).toDouble(),
      reviews: List<Map<String, dynamic>>.from(json['reviews'] ?? []),
      ratingBreakdown: Map<String, int>.from(json['rating_breakdown'] ?? {"1": 0, "2": 0, "3": 0, "4": 0, "5": 0}),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isVerified: json['is_verified'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'owner_id': ownerId,
      'title': title,
      'description': description,
      'price': price,
      'address': address,
      'property_type': propertyType,
      'category': category,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'images': images,
      'amenities': amenities,
      'average_rating': averageRating,
      'reviews': reviews,
      'rating_breakdown': ratingBreakdown,
      'latitude': latitude,
      'longitude': longitude,
      'is_verified': isVerified,
    };
  }

  Property copyWith({
    String? id,
    String? ownerId,
    String? title,
    String? description,
    double? price,
    String? address,
    String? propertyType,
    String? category,
    int? bedrooms,
    int? bathrooms,
    String? area,
    List<String>? images,
    List<String>? amenities,
    double? averageRating,
    List<Map<String, dynamic>>? reviews,
    Map<String, int>? ratingBreakdown,
    double? latitude,
    double? longitude,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return Property(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      address: address ?? this.address,
      propertyType: propertyType ?? this.propertyType,
      category: category ?? this.category,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      area: area ?? this.area,
      images: images ?? this.images,
      amenities: amenities ?? this.amenities,
      averageRating: averageRating ?? this.averageRating,
      reviews: reviews ?? this.reviews,
      ratingBreakdown: ratingBreakdown ?? this.ratingBreakdown,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
