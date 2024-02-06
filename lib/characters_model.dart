class CharactersModel {
  String? id;
  String? name;
  List<String>? alternateNames;
  String? species;
  String? gender;
  String? house;
  String? dateOfBirth;
  int? yearOfBirth;
  bool? wizard;
  String? ancestry;
  String? eyeColour;
  String? hairColour;
  Wand? wand;
  String? patronus;
  bool? hogwartsStudent;
  bool? hogwartsStaff;
  String? actor;
  List<dynamic>? alternateActors;
  bool? alive;
  String? image;

  CharactersModel(
      {this.id,
      this.name,
      this.alternateNames,
      this.species,
      this.gender,
      this.house,
      this.dateOfBirth,
      this.yearOfBirth,
      this.wizard,
      this.ancestry,
      this.eyeColour,
      this.hairColour,
      this.wand,
      this.patronus,
      this.hogwartsStudent,
      this.hogwartsStaff,
      this.actor,
      this.alternateActors,
      this.alive,
      this.image});

  CharactersModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        alternateNames = json['alternate_names'].cast<String>(),
        species = json['species'],
        gender = json['gender'],
        house = json['house'],
        dateOfBirth = json['dateOfBirth'],
        yearOfBirth = json['yearOfBirth'],
        wizard = json['wizard'],
        ancestry = json['ancestry'],
        eyeColour = json['eyeColour'],
        hairColour = json['hairColour'],
        wand = json['wand'] != null ? Wand.fromJson(json['wand']) : null,
        patronus = json['patronus'],
        hogwartsStudent = json['hogwartsStudent'],
        hogwartsStaff = json['hogwartsStaff'],
        actor = json['actor'],
        alternateActors = json['alternate_actors'],
        alive = json['alive'],
        image = json['image'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['alternate_names'] = alternateNames;
    data['species'] = species;
    data['gender'] = gender;
    data['house'] = house;
    data['dateOfBirth'] = dateOfBirth;
    data['yearOfBirth'] = yearOfBirth;
    data['wizard'] = wizard;
    data['ancestry'] = ancestry;
    data['eyeColour'] = eyeColour;
    data['hairColour'] = hairColour;
    if (wand != null) {
      data['wand'] = wand!.toJson();
    }
    data['patronus'] = patronus;
    data['hogwartsStudent'] = hogwartsStudent;
    data['hogwartsStaff'] = hogwartsStaff;
    data['actor'] = actor;
    // if (this.alternateActors != null) {
    //   data['alternate_actors'] =
    //       this.alternateActors!.map((v) => v.toJson()).toList();
    // }
    data['alive'] = alive;
    data['image'] = image;
    return data;
  }
}

class Wand {
  String? wood;
  String? core;
  dynamic length;

  Wand({this.wood, this.core, this.length});

  Wand.fromJson(Map<String, dynamic> json) {
    wood = json['wood'];
    core = json['core'];
    length = json['length'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wood'] = wood;
    data['core'] = core;
    data['length'] = length;
    return data;
  }
}
