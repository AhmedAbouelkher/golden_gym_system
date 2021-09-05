import 'package:equatable/equatable.dart';

class Memberr extends Equatable {
  final String name;
  final String imagePath;
  final DateTime memebershipStart;
  final DateTime memebershipEnd;
  final String memebershipType;
  final int? weight;
  final int? height;
  final double? muscleMass;
  final double? fatPersentage;
  final double? burnRate;

  const Memberr({
    required this.name,
    required this.imagePath,
    required this.memebershipStart,
    required this.memebershipEnd,
    required this.memebershipType,
    this.weight,
    this.height,
    this.muscleMass,
    this.fatPersentage,
    this.burnRate,
  });

  @override
  List<Object?> get props {
    return [
      name,
      imagePath,
      memebershipStart,
      memebershipEnd,
      memebershipType,
      weight,
      height,
      muscleMass,
      fatPersentage,
      burnRate,
    ];
  }
}
