import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bmi_record.dart';

class BmiProvider extends ChangeNotifier {
  static const _readingsKey = 'bmi_readings';
  static const _unitKey = 'bmi_unit';
  static const _genderKey = 'bmi_gender';
  static const _ageKey = 'bmi_age';
  static const _heightKey = 'bmi_height';
  static const _weightKey = 'bmi_weight';

  UnitSystem _unitSystem = UnitSystem.metric;
  String _gender = 'male';
  double _age = 25;
  double _height = 165; // cm
  double _weight = 70; // kg

  double? _currentBmi;
  BmiCategory? _currentCategory;

  final List<BmiRecord> _history = [];

  UnitSystem get unitSystem => _unitSystem;
  String get gender => _gender;
  double get age => _age;
  double get height => _height;
  double get weight => _weight;
  double? get currentBmi => _currentBmi;
  BmiCategory? get currentCategory => _currentCategory;
  List<BmiRecord> get history => List.unmodifiable(_history);
  List<BmiRecord> get recentReadings => _history.reversed.take(3).toList();

  // Display values for sliders
  double get displayHeight => _height;
  double get displayWeight => _weight;

  String get heightLabel =>
      _unitSystem == UnitSystem.metric
          ? '${_height.round()} cm'
          : _cmToFeetInches(_height);

  String get weightLabel =>
      _unitSystem == UnitSystem.metric
          ? '${_weight.round()} kg'
          : '${_kgToLbs(_weight).round()} lbs';

  BmiProvider() {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();

    final unitStr = prefs.getString(_unitKey);
    if (unitStr == 'imperial') _unitSystem = UnitSystem.imperial;

    _gender = prefs.getString(_genderKey) ?? 'male';
    _age = prefs.getDouble(_ageKey) ?? 25;
    _height = prefs.getDouble(_heightKey) ?? 165;
    _weight = prefs.getDouble(_weightKey) ?? 70;

    // Load history
    final jsonList = prefs.getStringList(_readingsKey);
    if (jsonList != null && jsonList.isNotEmpty) {
      final records = <BmiRecord>[];
      for (final json in jsonList) {
        try {
          final map = jsonDecode(json) as Map<String, dynamic>;
          records.add(BmiRecord.fromMap(map));
        } catch (_) {
          // Skip invalid entries
        }
      }
      _history.addAll(records);
      if (records.isNotEmpty) {
        _currentBmi = records.last.bmi;
        _currentCategory = records.last.category;
      }
    }

    notifyListeners();
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_unitKey, _unitSystem.name);
    await prefs.setString(_genderKey, _gender);
    await prefs.setDouble(_ageKey, _age);
    await prefs.setDouble(_heightKey, _height);
    await prefs.setDouble(_weightKey, _weight);
  }

  void setUnitSystem(UnitSystem unit) {
    if (unit == _unitSystem) return;
    if (unit == UnitSystem.imperial) {
      _height = _cmToInches(_height);
      _weight = _kgToLbs(_weight);
    } else {
      _height = _inchesToCm(_height);
      _weight = _lbsToKg(_weight);
    }
    _unitSystem = unit;
    _saveState();
    notifyListeners();
  }

  void setGender(String gender) {
    _gender = gender;
    _saveState();
    notifyListeners();
  }

  void setAge(double age) {
    _age = age.roundToDouble();
    _saveState();
    notifyListeners();
  }

  void setHeight(double value) {
    _height = value;
    _saveState();
    notifyListeners();
  }

  void setWeight(double value) {
    _weight = value;
    _saveState();
    notifyListeners();
  }

  double calculateBmi() {
    final heightInMeters =
        _unitSystem == UnitSystem.metric ? _height / 100 : _inchesToCm(_height) / 100;
    final weightInKg =
        _unitSystem == UnitSystem.metric ? _weight : _lbsToKg(_weight);

    final bmi = weightInKg / (heightInMeters * heightInMeters);
    _currentBmi = double.parse(bmi.toStringAsFixed(1));

    if (_currentBmi! < 18.5) {
      _currentCategory = BmiCategory.underweight;
    } else if (_currentBmi! < 25) {
      _currentCategory = BmiCategory.normal;
    } else if (_currentBmi! < 30) {
      _currentCategory = BmiCategory.overweight;
    } else {
      _currentCategory = BmiCategory.obese;
    }

    notifyListeners();
    return _currentBmi!;
  }

  Future<void> saveReading() async {
    final bmi = calculateBmi();
    final record = BmiRecord(
      bmi: bmi,
      weight: _weight,
      height: _height,
      age: _age.round(),
      gender: _gender,
      unitSystem: _unitSystem,
      dateTime: DateTime.now(),
      category: _currentCategory!,
    );

    _history.add(record);
    await _persistHistory();
    notifyListeners();
  }

  Future<void> deleteReading(int index) async {
    if (index >= 0 && index < _history.length) {
      _history.removeAt(index);
      await _persistHistory();
      notifyListeners();
    }
  }

  Future<void> _persistHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final toSave = _history.reversed.take(20).toList().reversed.toList();
    final jsonList = toSave.map((r) => jsonEncode(r.toMap())).toList();
    await prefs.setStringList(_readingsKey, jsonList);
  }

  double _cmToInches(double cm) => cm / 2.54;
  double _inchesToCm(double inches) => inches * 2.54;
  double _kgToLbs(double kg) => kg * 2.20462;
  double _lbsToKg(double lbs) => lbs / 2.20462;

  String _cmToFeetInches(double cm) {
    final totalInches = _cmToInches(cm).round();
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return "$feet'$inches\"";
  }
}
