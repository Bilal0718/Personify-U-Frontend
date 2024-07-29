import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class CareerSearch extends StatefulWidget {
  const CareerSearch({super.key});

  @override
  State<CareerSearch> createState() => _CareerSearchState();
}

class _CareerSearchState extends State<CareerSearch> {
  // List of personality types
  final List<String> personalityTypes = [
    'INFP', 'INTJ', 'INFJ', 'INTP',
    'ENFP', 'ENTJ', 'ENTP', 'ENFJ',
    'ISFJ', 'ISFP', 'ISTJ', 'ISTP',
    'ESFJ', 'ESFP', 'ESTJ', 'ESTP'
  ];

  String? selectedPersonality;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Career Search Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownSearch<String>(
              items: personalityTypes,
              selectedItem: selectedPersonality,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPersonality = newValue;
                });
              },
              popupProps: PopupProps.menu(
                showSearchBox: true,
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Select Personality",
                  hintText: "Choose a personality type",
                ),
              ),
            ),
            SizedBox(height: 20),
            selectedPersonality == null
                ? Text('Please select a personality type')
                : Text('Selected Personality: $selectedPersonality'),
          ],
        ),
      ),
    );
  }
}
