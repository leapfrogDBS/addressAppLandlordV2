import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

String? percentageIncreaseAlltime(
  double? purchasePrice,
  double? estimatedValue,
) {
  if (purchasePrice == null || estimatedValue == null || purchasePrice == 0) {
    return 'N/A'; // Or whatever you want to show for invalid inputs
  }

  double increase = estimatedValue - purchasePrice;
  double percentage = (increase / purchasePrice) * 100.0;

  // Format the percentage to one decimal place
  String formattedPercentage = percentage.toStringAsFixed(1);

  // Add the "+" prefix for positive numbers
  if (percentage > 0) {
    formattedPercentage = '+' + formattedPercentage;
  }

  // Add the "%" suffix
  return formattedPercentage + '%';
}

String? timeHeldFunction(DateTime? purchaseDate) {
  if (purchaseDate == null) {
    return 'N/A'; // Return N/A if purchase date is not provided
  }

  DateTime now = DateTime.now();
  Duration difference = now.difference(purchaseDate);

  // Calculate total months
  // Using an average of 30.4375 days per month for better accuracy over long periods
  int totalMonths = (difference.inDays / 30.4375).round();

  // ***** CHANGE IS HERE: totalMonths < 24 (for less than 2 years) *****
  if (totalMonths < 24) {
    // Less than 2 years (24 months)
    if (totalMonths == 0) {
      return 'Less than 1 month';
    }
    return '$totalMonths months';
  } else {
    // Calculate total years with half-year precision
    double totalYears = totalMonths / 12.0;
    // Round to the nearest 0.5 (e.g., 2.3 -> 2.5, 2.8 -> 3.0)
    double roundedYears = (totalYears * 2).round() / 2;

    if (roundedYears == 0) {
      // This case should ideally not be hit if totalMonths >= 24,
      // but added for robustness if somehow difference is tiny.
      return 'Less than 0.5 years';
    }

    // Check if it's a whole number
    if (roundedYears == roundedYears.toInt()) {
      return '${roundedYears.toInt()} years'; // Convert to int and then to string for whole numbers
    } else {
      return '${roundedYears.toStringAsFixed(1)} years'; // Keep one decimal for half years
    }
  }
}

EstimatedGainResultsStruct? calculateEstimatedAnnualGain(
  double estimatedValue,
  double annualIncreasePercentage,
  double totalExpenses,
  double purchasePrice,
  double previousRentalIncome,
  double previousExpenses,
  double annualCapitalGain,
  double annualRent,
) {
  // null-safe inputs
  final ev = estimatedValue;
  final pp = purchasePrice;
  final expY = totalExpenses;

  final rentY = annualRent;
  final capY = annualCapitalGain;
  final incrPct = annualIncreasePercentage;

  final prevRent = previousRentalIncome;
  final prevExp = previousExpenses;

  // yearly pieces
  final netRentalProfit = rentY - expY;
  final totalEstimatedGain = capY + netRentalProfit;

  // per-day (dailyGain includes rental + capital)
  final gainPerDay = totalEstimatedGain / 365.0;
  final gainPerSecond = gainPerDay / 86400.0;
  final dailyCapGain = capY / 365.0;

  // ROI & earnings
  final roi = pp > 0 ? (totalEstimatedGain / pp) * 100.0 : 0.0;

  final now = DateTime.now();
  final startOfYear = DateTime(now.year, 1, 1);
  final secondsPassed = now.difference(startOfYear).inSeconds.toDouble();

  final historicalCapitalGain = ev - pp;
  final realTimeGain = gainPerSecond * secondsPassed;
  final earningsToDate = prevRent + historicalCapitalGain + realTimeGain;

  final totalInvestment = pp + prevExp + expY;
  final rentalYield = pp > 0 ? (netRentalProfit / pp) * 100.0 : 0.0;

  // “all-time” rollups
  final allTimeCapitalAppreciation = historicalCapitalGain + capY;
  final allTimeRentalIncome = prevRent + rentY;
  final allTimeExpenses = prevExp + expY;
  final allTimeNetProfit =
      (allTimeCapitalAppreciation + allTimeRentalIncome) - allTimeExpenses;
  final allTimeROI =
      totalInvestment > 0 ? (allTimeNetProfit / totalInvestment) * 100.0 : 0.0;

  return EstimatedGainResultsStruct(
    totalGain: totalEstimatedGain,
    gainPerDay: gainPerDay,
    gainPerSecond: gainPerSecond,
    capitalGain: capY,
    rentalProfit: netRentalProfit,
    totalExpenses: expY,
    roi: roi,
    earningsToDate: earningsToDate,
    totalAnnualRent: rentY,
    totalInvestment: totalInvestment,
    rentalYield: rentalYield,
    annualIncreasePercentage: incrPct,
    dailyCapitalGain: dailyCapGain,
    allTimeCapitalAppreciation: allTimeCapitalAppreciation,
    allTimeRentalIncome: allTimeRentalIncome,
    allTimeExpenses: allTimeExpenses,
    allTimeNetProfit: allTimeNetProfit,
    allTimeROI: allTimeROI,
  );
}

double? calculateInitialLiveEarnings(
  double? earningsToDate,
  String gainPerSecondString,
) {
  double safeEarningsToDate = earningsToDate ?? 0.0;

  // Parse gainPerSecondString back to a Double, with a default of 0.0 if parsing fails
  double gainPerSecond = double.tryParse(gainPerSecondString) ?? 0.0;

  // Get current date/time
  DateTime now = DateTime.now();

  // Get the start of the current year (January 1st of the current year)
  DateTime startOfYear = DateTime(now.year, 1, 1);

  // Calculate seconds passed since the start of the year
  Duration secondsPassed = now.difference(startOfYear);
  double totalSecondsPassedThisYear = secondsPassed.inSeconds.toDouble();

  // --- Add a print statement here to see the values ---
  print('DEBUG: earningsToDate = $safeEarningsToDate');
  print(
      'DEBUG: gainPerSecond (parsed) = $gainPerSecond'); // Print the parsed value
  print('DEBUG: secondsPassedThisYear = $totalSecondsPassedThisYear');

  // Check if secondsPassed is negative (a highly unlikely but possible scenario)
  if (secondsPassed.isNegative) {
    print('DEBUG: secondsPassed is negative. Using 0 for calculation.');
    totalSecondsPassedThisYear = 0.0;
  }

  // Calculate initial live earnings: earnings to date + (seconds passed * gain per second)
  double initialLiveEarnings =
      safeEarningsToDate + (totalSecondsPassedThisYear * gainPerSecond);

  print('DEBUG: initialLiveEarnings = $initialLiveEarnings');

  return initialLiveEarnings;
}

List<DateTime>? generateRentDueDates(
  DateTime? tenancyStartDate,
  int? rentDueDay,
) {
  if (tenancyStartDate == null || rentDueDay == null) return null;

  final now = DateTime.now();
  final currentYear = now.year;
  final List<DateTime> rentDates = [];

  for (int month = 1; month <= 12; month++) {
    try {
      final rentDate = DateTime(currentYear, month, rentDueDay);

      if (!rentDate.isBefore(tenancyStartDate)) {
        rentDates.add(rentDate);
      }
    } catch (e) {
      // Skip invalid dates (e.g. Feb 30)
      continue;
    }
  }

  return rentDates;
}

double? subtractDoubles(
  double? a,
  double? b,
) {
  final x = a ?? 0.0;
  final y = b ?? 0.0;
  final r = x - y;
  return r.isFinite ? r : 0.0;
}

double? percentOfDifferenceRelativeToLarge(
  double? a,
  double? b,
) {
  final x = a ?? 0.0;
  final y = b ?? 0.0;

  // Larger of the two (use abs to be safe if negatives ever appear)
  final larger = (x >= y) ? x : y;
  final denom = larger.abs();

  if (denom == 0.0) return 0.0; // avoid divide-by-zero

  final diff = (x - y).abs();
  final ratio = diff / denom;

  return ratio.isFinite ? ratio : 0.0;
}

double? percentOfDifferenceRelativeToLargeOther(
  double? a,
  double? b,
) {
  final denom = a ?? 0.0; // a
  final numer = b ?? 0.0; // b

  if (denom == 0.0 || !denom.isFinite) return 0.0;

  final r = numer / denom;
  return r.isFinite ? r : 0.0;
}

DateTime? getStartOfYear() {
  final now = DateTime.now();
  return DateTime(now.year, 1, 1);
}

DateTime? getEndOfYear() {
  final now = DateTime.now();
  return DateTime(now.year, 12, 31, 23, 59, 59);
}

double? calculateTotalExpensesFromList(List<ExpensesRecord>? expensesList) {
  if (expensesList == null) {
    return 0.0;
  }

  double total = 0.0;
  for (var expense in expensesList) {
    // Check if the amount field is not null before adding
    if (expense.amount != null) {
      total += expense.amount!;
    }
  }
  return total;
}

int? getCurrentYear() {
  final now = DateTime.now();
  return now.year;
}

String? formatAsCurrency(double? amount) {
  //
  // Safely handle null values and ensure a double is used for formatting.
  final safeAmount = amount ?? 0.0;

  // Use NumberFormat from the 'intl' package for robust currency formatting.
  final formatter = NumberFormat.currency(
    locale: 'en_GB',
    symbol: '£',
    decimalDigits: 2,
  );

  return formatter.format(safeAmount);
}

int yearIndex(
  List<int>? years,
  int targetYear,
) {
  if (years == null || years.isEmpty) return 0;
  final i = years.indexOf(targetYear);
  return i >= 0 ? i : 0;
}

double safeDoubleAt(
  List<double>? list,
  int index,
  double fallback,
) {
  if (list == null || index < 0 || index >= list.length) {
    return fallback;
  }
  final value = list[index];
  if (value.isNaN || value.isInfinite) {
    return fallback;
  }
  return value;
}

double sum2(
  double a,
  double b,
) {
  final aa = (a.isNaN || a.isInfinite) ? 0.0 : a;
  final bb = (b.isNaN || b.isInfinite) ? 0.0 : b;
  return aa + bb;
}

List<String> yearsToStringList(List<int> years) {
  if (years == null || years.isEmpty) return const [];
  return years.map((e) => e.toString()).toList();
}

int yearIndexFromString(
  List<int> years,
  String selectedYear,
) {
  if (years == null ||
      years.isEmpty ||
      selectedYear == null ||
      selectedYear.isEmpty) {
    return 0;
  }
  final parsed = int.tryParse(selectedYear);
  if (parsed == null) return 0;
  final idx = years.indexOf(parsed);
  return idx >= 0 ? idx : 0;
}

String initialYearLabel(List<int> years) {
  if (years == null || years.isEmpty) return '';
  final now = DateTime.now().year;
  final chosen = years.contains(now) ? now : years.first;
  return chosen.toString();
}
