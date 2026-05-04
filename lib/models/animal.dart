enum AnimalSpecies {
  bovino,
  cabra,
  toro,
  cite,
  perro,
  gato,
  otros,
}

enum AnimalGender {
  macho,
  hembra,
}

class Animal {
  final String id;
  final String name;
  final AnimalSpecies species;
  final String breed;
  final int age;
  final double weight;
  final AnimalGender gender;
  final String medicalNotes;
  final DateTime createdAt;

  Animal({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.weight,
    required this.gender,
    required this.medicalNotes,
    required this.createdAt,
  });

  String get speciesName {
    switch (species) {
      case AnimalSpecies.bovino:
        return 'Bovino';
      case AnimalSpecies.cabra:
        return 'Cabra';
      case AnimalSpecies.toro:
        return 'Toro';
      case AnimalSpecies.cite:
        return 'Cite';
      case AnimalSpecies.perro:
        return 'Perro';
      case AnimalSpecies.gato:
        return 'Gato';
      case AnimalSpecies.otros:
        return 'Otros';
    }
  }

  String get genderName {
    return gender == AnimalGender.macho ? 'Macho' : 'Hembra';
  }
}
