class ProductType {
  final String id;
  final String label;
  final int recommendedMinutes; // midpoint of recommended range
  final int maxMinutes;

  const ProductType({
    required this.id,
    required this.label,
    required this.recommendedMinutes,
    required this.maxMinutes,
  });

  double get recommendedHours => recommendedMinutes / 60;
  double get maxHours => maxMinutes / 60;

  String get recommendedLabel {
    final h = recommendedMinutes ~/ 60;
    final m = recommendedMinutes % 60;
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }

  String get maxLabel {
    final h = maxMinutes ~/ 60;
    return '${h}h';
  }

  // Disposable Pads: recommended 3–4h → midpoint 3.5h (210 min), max 8h
  static const disposablePad = ProductType(
    id: 'disposable_pad',
    label: 'Disposable Pad',
    recommendedMinutes: 210,
    maxMinutes: 480,
  );

  // Tampons: recommended 4–8h → midpoint 6h (360 min), max 8h strict
  static const tampon = ProductType(
    id: 'tampon',
    label: 'Tampon',
    recommendedMinutes: 360,
    maxMinutes: 480,
  );

  // Menstrual Cups: recommended 8–12h → midpoint 10h (600 min), max 12h
  static const menstrualCup = ProductType(
    id: 'menstrual_cup',
    label: 'Menstrual Cup',
    recommendedMinutes: 600,
    maxMinutes: 720,
  );

  // Menstrual Discs: recommended 8–12h → midpoint 10h (600 min), max 12h
  static const menstrualDisc = ProductType(
    id: 'menstrual_disc',
    label: 'Menstrual Disc',
    recommendedMinutes: 600,
    maxMinutes: 720,
  );

  // Period Underwear: recommended 8–12h → midpoint 10h (600 min), max 12h
  static const periodUnderwear = ProductType(
    id: 'period_underwear',
    label: 'Period Underwear',
    recommendedMinutes: 600,
    maxMinutes: 720,
  );

  // Reusable Pads: recommended 4–6h → midpoint 5h (300 min), max 12h
  static const reusablePad = ProductType(
    id: 'reusable_pad',
    label: 'Reusable Pad',
    recommendedMinutes: 300,
    maxMinutes: 720,
  );

  // Menstrual Sponges: recommended 3–6h → midpoint 4.5h (270 min), max 8h
  static const menstrualSponge = ProductType(
    id: 'menstrual_sponge',
    label: 'Menstrual Sponge',
    recommendedMinutes: 270,
    maxMinutes: 480,
  );

  static const List<ProductType> all = [
    disposablePad,
    tampon,
    menstrualCup,
    menstrualDisc,
    periodUnderwear,
    reusablePad,
    menstrualSponge,
  ];
}
