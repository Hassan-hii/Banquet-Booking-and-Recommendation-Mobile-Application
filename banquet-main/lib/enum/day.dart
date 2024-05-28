import 'package:flutter/material.dart';

enum Day {
  morning('Morning', Icons.sunny),
  evening('Evening', Icons.nightlight);

  const Day(
    this.partOfTheDay,
      this.icon
  );
  final String partOfTheDay;
  final IconData icon;
}
