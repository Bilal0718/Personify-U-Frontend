import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personifyu/common_widget/round_button.dart';

class CareerSearch extends StatefulWidget {
  const CareerSearch({super.key});

  @override
  State<CareerSearch> createState() => _CareerSearchState();
}

class _CareerSearchState extends State<CareerSearch> {
  final List<String> personalityTypes = [
    'INFP', 'INTJ', 'INFJ', 'INTP',
    'ENFP', 'ENTJ', 'ENTP', 'ENFJ',
    'ISFJ', 'ISFP', 'ISTJ', 'ISTP',
    'ESFJ', 'ESFP', 'ESTJ', 'ESTP'
  ];

  String? selectedPersonality;
  List<String> recommendedCareers = [];

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
                  recommendedCareers = RecommendationService.getRecommendations(newValue);
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
                : Column(
                    children: [
                      Text('Selected Personality: $selectedPersonality'),
                      SizedBox(height: 10),
                      Text('Recommended Careers:'),
                      ...recommendedCareers.map((career) => Text(career)).toList(),
                      SizedBox(height: 20),
                      RoundButton(title: 'Satisfied with these Recommendations?', onPressed: () {
                          _showSatisfactionDialog();
                        },)
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  void _showSatisfactionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Feedback'),
        content: Text('Are you satisfied with the recommended careers?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              RecommendationService.saveFeedback(selectedPersonality!, recommendedCareers, true);
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              RecommendationService.saveFeedback(selectedPersonality!, recommendedCareers, false);
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }
}

class RecommendationService {
  static final Map<String, List<String>> personalityToCareers = {
    'ISTJ': ['Actuary', 'Civil engineer', 'Curator', 'Dentist', 'Lawyer'],
    'ISFJ': ['Accountant', 'Account manager', 'Administrative officer', 'Customer service representative', 'Research analyst'],
    'INFJ': ['HR manager', 'Massage therapist', 'Physical therapist', 'Psychologist', 'School counselor'],
    'INTJ': ['Architect', 'Business strategist', 'Investigator', 'Microbiologist', 'Statistician'],
    'ISTP': ['Airline pilot', 'Chef', 'Economist', 'Health inspector', 'Mechanic'],
    'ISFP': ['Archaeologist', 'Bookkeeper', 'Dietician', 'Occupational therapist', 'Veterinarian'],
    'INFP': ['Artist', 'Film editor', 'Journalist', 'Museum curator', 'Registered nurse'],
    'INTP': ['Biomedical engineer', 'Composer', 'Computer systems analyst', 'Environmental scientist', 'Marketing consultant'],
    'ESTP': ['Actor', 'Entrepreneur', 'Marketer', 'Paramedic', 'Stockbroker'],
    'ESFP': ['Event planner', 'Firefighter', 'Flight attendant', 'Tour guide', 'Wait staff'],
    'ENFP': ['Campaign manager', 'Dance instructor', 'Editor', 'Urban planner', 'Youth mentor'],
    'ENTP': ['Attorney', 'Copywriter', 'Creative director', 'Financial planner', 'Systems analyst'],
    'ESTJ': ['Building inspector', 'Hotel manager', 'Paralegal', 'Police officer', 'Real estate agent'],
    'ESFJ': ['Bookkeeper', 'Caterer', 'Medical researcher', 'Office manager', 'Optometrist'],
    'ENFJ': ['Art director', 'Market research analyst', 'Mediator', 'Public speaker', 'Real estate broker'],
    'ENTJ': ['Budget analyst', 'Business administrator', 'Construction manager', 'Judge', 'Public relations specialist'],
  };

  static List<String> getRecommendations(String? personalityType) {
    if (personalityType == null) return [];
    return personalityToCareers[personalityType] ?? [];
  }

  static Future<void> saveFeedback(String personalityType, List<String> recommendedCareers, bool isSatisfied) async {
    final feedback = {
      'personalityType': personalityType,
      'recommendedCareers': recommendedCareers,
      'isSatisfied': isSatisfied,
      'timestamp': Timestamp.now(),
    };
    await FirebaseFirestore.instance.collection('career_feedback').add(feedback);
  }
}
