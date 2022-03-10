enum Gender { female, male, others }

enum ProgrammingLanguages { dart, java, swift, kotlin, javascript }

class Settings {
  final String userName;
  final Gender gender;
  final Set<ProgrammingLanguages> languages;
  final bool isEmployed;
  Settings(
      {required this.userName,
      required this.isEmployed,
      required this.gender,
      required this.languages});
}
