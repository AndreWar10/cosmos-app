class Observatory {
  const Observatory({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.rating,
    required this.state,
    required this.website,
    required this.mapsUrl,
    required this.image,
    required this.description,
  });

  final String id;
  final String name;
  final String address;
  final String phone;
  final double rating;
  final String state;
  final String website;
  final String mapsUrl;
  final String image;
  final String description;
}
