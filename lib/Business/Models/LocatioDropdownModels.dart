class LocationDropdownOption {
  final int LOC_ID;
  final String LOCATION_NAME;

  LocationDropdownOption({
    required this.LOC_ID,
    required this.LOCATION_NAME,
  });

  factory LocationDropdownOption.fromJson(Map<String, dynamic> json) {
    return LocationDropdownOption(
      LOC_ID: json['LOC_ID'],
      LOCATION_NAME: json['LOCATION_NAME'],
    );
  }
}