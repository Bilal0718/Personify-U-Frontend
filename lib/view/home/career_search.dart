import 'package:flutter/material.dart';

class CareerSearch extends StatefulWidget {
  const CareerSearch({super.key});

  @override
  State<CareerSearch> createState() => _CareerSearchState();
}

class _CareerSearchState extends State<CareerSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Career Search Page'),
      ),
    );
  }
}