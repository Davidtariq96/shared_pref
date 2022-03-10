import 'package:flutter/material.dart';
import 'package:shared_pref/models.dart';
import 'package:shared_pref/preferences_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PreferenceService _preferenceService = PreferenceService();
  final userEditingController = TextEditingController();
  var _selectedGender = Gender.female;
  //saving each language in a set to avoid duplicate
  var _selectedLanguage = Set<ProgrammingLanguages>();
  var _isEmployed = false;

  @override
  void initState() {
    super.initState();
    _populateFields();
  }

  void _populateFields() async {
    final details = await _preferenceService.getSettings();
    setState(() {
      _selectedGender = details.gender;
      userEditingController.text = details.userName;
      _selectedLanguage = details.languages;
      _isEmployed = details.isEmployed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shared preferences"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: TextField(
              controller: userEditingController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
          ),
          buildRadioListTile(select: Gender.female, gender: 'FEMALE'),
          buildRadioListTile(select: Gender.male, gender: 'MALE'),
          buildRadioListTile(select: Gender.others, gender: 'OTHERS'),
          buildCheckboxListTile(name: 'Dart', lang: ProgrammingLanguages.dart),
          buildCheckboxListTile(name: 'Java', lang: ProgrammingLanguages.java),
          buildCheckboxListTile(
              name: 'Javascript', lang: ProgrammingLanguages.javascript),
          buildCheckboxListTile(
              name: 'Kotlin', lang: ProgrammingLanguages.kotlin),
          buildCheckboxListTile(
              name: 'Swift', lang: ProgrammingLanguages.swift),
          SwitchListTile(
              title: const Text("Is Employed"),
              value: _isEmployed,
              onChanged: (newValue) => setState(() {
                    _isEmployed = newValue;
                  })),
          TextButton(
            onPressed: _saveSettings,
            child: const Center(
              child: Text("Save Settings"),
            ),
          )
        ],
      ),
    );
  }

  void _saveSettings() {
    final newSettings = Settings(
        userName: userEditingController.text,
        isEmployed: _isEmployed,
        gender: _selectedGender,
        languages: _selectedLanguage);
    print(newSettings.userName);
    _preferenceService.saveSettings(settings: newSettings);
  }

  CheckboxListTile buildCheckboxListTile(
      {required String name, required ProgrammingLanguages lang}) {
    return CheckboxListTile(
      title: Text(name),
      value: _selectedLanguage.contains(lang),
      onChanged: (bool? value) => setState(() {
        _selectedLanguage.contains(lang)
            ? _selectedLanguage.remove(lang)
            : _selectedLanguage.add(lang);
      }),
    );
  }

  RadioListTile<Gender> buildRadioListTile(
      {required String gender, required Gender select}) {
    return RadioListTile(
      title: Text(gender),
      groupValue: _selectedGender,
      value: select,
      onChanged: (value) => setState(() {
        _selectedGender = value as Gender;
      }),
    );
  }
}
