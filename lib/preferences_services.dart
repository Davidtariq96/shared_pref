import 'package:shared_pref/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  Future saveSettings({required Settings settings}) async {
    final preference = await SharedPreferences.getInstance();
    await preference.setString("username", settings.userName);
    await preference.setBool("isEmployed", settings.isEmployed);
    await preference.setInt("gender", settings.gender.index);
    await preference.setStringList("programmingLanguages",
        settings.languages.map((e) => e.index.toString()).toList());
    //  since we could choose more than one language we convert to list
    print("saved");
  }

  Future<Settings> getSettings() async {
    final pref = await SharedPreferences.getInstance();
    final userName = pref.getString("username");
    final isEmployed = pref.getBool("isEmployed");
    final gender = Gender.values[pref.getInt("gender") ?? 0];
    final programmingLangIndices = pref.getStringList("programmingLanguages");

    final programmingLanguages = programmingLangIndices
        ?.map((stringIndex) =>
            ProgrammingLanguages.values[int.parse(stringIndex)])
        .toSet();
    return Settings(
        userName: userName ?? "",
        isEmployed: isEmployed ?? false,
        gender: gender,
        languages: programmingLanguages ?? {});
  }
}
