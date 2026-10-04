enum UnitSystem { metric, imperial }

enum BmiCategory {
  underweight,
  normal,
  overweight,
  obese,
}

extension BmiCategoryExtension on BmiCategory {
  String get label {
    switch (this) {
      case BmiCategory.underweight:
        return 'Underweight';
      case BmiCategory.normal:
        return 'Normal';
      case BmiCategory.overweight:
        return 'Overweight';
      case BmiCategory.obese:
        return 'Obese';
    }
  }

  String get emoji {
    switch (this) {
      case BmiCategory.underweight:
        return '🔵';
      case BmiCategory.normal:
        return '🟢';
      case BmiCategory.overweight:
        return '🟠';
      case BmiCategory.obese:
        return '🔴';
    }
  }

  int get colorValue {
    switch (this) {
      case BmiCategory.underweight:
        return 0xFF1976D2;
      case BmiCategory.normal:
        return 0xFF2E7D32;
      case BmiCategory.overweight:
        return 0xFFFB8C00;
      case BmiCategory.obese:
        return 0xFFD32F2F;
    }
  }

  String get healthTip {
    switch (this) {
      case BmiCategory.underweight:
        return 'Consider a nutrient-rich diet to reach a healthy weight. '
            'Consult a nutritionist for a personalized plan.';
      case BmiCategory.normal:
        return 'Great job! Maintain a balanced diet and regular physical '
            'activity to stay in this healthy range.';
      case BmiCategory.overweight:
        return 'Small changes can make a big difference. Try incorporating '
            'more walking and mindful eating habits.';
      case BmiCategory.obese:
        return 'We recommend consulting your healthcare provider for '
            'a personalized wellness plan. Every step counts!';
    }
  }

  double get minRange {
    switch (this) {
      case BmiCategory.underweight:
        return 0;
      case BmiCategory.normal:
        return 18.5;
      case BmiCategory.overweight:
        return 25;
      case BmiCategory.obese:
        return 30;
    }
  }

  double get maxRange {
    switch (this) {
      case BmiCategory.underweight:
        return 18.4;
      case BmiCategory.normal:
        return 24.9;
      case BmiCategory.overweight:
        return 29.9;
      case BmiCategory.obese:
        return 50;
    }
  }
}

class BmiRecord {
  final double bmi;
  final double weight;
  final double height;
  final int age;
  final String gender;
  final UnitSystem unitSystem;
  final DateTime dateTime;
  final BmiCategory category;

  BmiRecord({
    required this.bmi,
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.unitSystem,
    required this.dateTime,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'bmi': bmi,
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender,
      'unitSystem': unitSystem == UnitSystem.metric ? 'metric' : 'imperial',
      'dateTime': dateTime.toIso8601String(),
      'category': category.name,
    };
  }

  factory BmiRecord.fromMap(Map<String, dynamic> map) {
    return BmiRecord(
      bmi: (map['bmi'] as num).toDouble(),
      weight: (map['weight'] as num).toDouble(),
      height: (map['height'] as num).toDouble(),
      age: map['age'] as int,
      gender: map['gender'] as String,
      unitSystem:
          map['unitSystem'] == 'metric' ? UnitSystem.metric : UnitSystem.imperial,
      dateTime: DateTime.parse(map['dateTime'] as String),
      category: BmiCategory.values.firstWhere(
        (e) => e.name == (map['category'] ?? 'normal'),
      ),
    );
  }
}
