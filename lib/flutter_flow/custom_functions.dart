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
  double priceValuationOnJoiningAddressed,
  double totalHistoricalRentalIncome,
  double totalHistoricalExpenses,
  PropertyProjectionsRecord? projection,
  int currentYearIndex,
) {
  // Treat purchasePrice as the "priceValuationOnJoiningAddressed" anchor (for now).
  final joiningValuation = priceValuationOnJoiningAddressed;

// Defaults
  double gainPerDay = 0.0;
  double gainPerSecond = 0.0;
  double gainThisYear = 0.0;

  final now = DateTime.now();

// Parse "YYYY-MM-DD" into LOCAL midnight (avoids UTC offset issues)
  DateTime _parseYmdLocal(String ymd, DateTime fallback) {
    try {
      final parts = ymd.split('-');
      if (parts.length != 3) return fallback;
      final y = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final d = int.parse(parts[2]);
      return DateTime(y, m, d);
    } catch (_) {
      return fallback;
    }
  }

// Default fallback = calendar year window
  DateTime periodStart = DateTime(now.year, 1, 1);
  DateTime periodEndExclusive = DateTime(now.year + 1, 1, 1);

// Use property-year boundaries when available
  if (projection != null &&
      currentYearIndex >= 0 &&
      projection.periodStartDates.length > currentYearIndex &&
      projection.periodEndDates.length > currentYearIndex) {
    final startStr = projection.periodStartDates[currentYearIndex];
    final endStr = projection.periodEndDates[currentYearIndex];

    final startLocal = _parseYmdLocal(startStr, DateTime(now.year, 1, 1));
    final endLocalInclusive =
        _parseYmdLocal(endStr, DateTime(now.year, 12, 31));

    // Stored end date is inclusive -> make exclusive by adding 1 day
    final endLocalExclusive = endLocalInclusive.add(const Duration(days: 1));

    if (endLocalExclusive.isAfter(startLocal)) {
      periodStart = startLocal;
      periodEndExclusive = endLocalExclusive;
    }
  }

  final secondsInPeriod = periodEndExclusive
      .difference(periodStart)
      .inSeconds
      .toDouble()
      .clamp(1, double.infinity);

  final secondsPassed = now
      .difference(periodStart)
      .inSeconds
      .toDouble()
      .clamp(0, secondsInPeriod);

// Projection annual gain for this period index
  if (projection != null && currentYearIndex >= 0) {
    final idx = currentYearIndex;

    final hasCapAndRent = projection.capitalGains.length > idx &&
        projection.rentalProfit.length > idx;

    if (hasCapAndRent) {
      final annualCapitalGain = projection.capitalGains[idx];
      final netRentalProfit = projection.rentalProfit[idx];

      gainThisYear = annualCapitalGain + netRentalProfit;

      // Pro-rata using actual seconds in this property-year period
      gainPerSecond = gainThisYear / secondsInPeriod;
      gainPerDay = gainPerSecond * 86400.0;
    } else if (projection.combinedDailyGain.length > idx) {
      // Older schema fallback
      gainPerDay = projection.combinedDailyGain[idx];
      gainThisYear = gainPerDay * 365.0; // you said 365 is fine
      gainPerSecond = gainThisYear / secondsInPeriod;
    }
  }

// Since joining Addressed (as per your property fields)
  final historicalNetProfitBase =
      totalHistoricalRentalIncome - totalHistoricalExpenses;

// Capital gain since joining Addressed (anchor = joining valuation)
  final capitalGainSinceJoining = estimatedValue - joiningValuation;

// Live pro-rata gain within the current property-year period
  final realTimeGainThisPeriod = gainPerSecond * secondsPassed;

// Total earnings as of now (since joining Addressed)
  final earningsAsOfNowValue = capitalGainSinceJoining +
      historicalNetProfitBase +
      realTimeGainThisPeriod;

  return EstimatedGainResultsStruct(
    earningsAsOfNow: earningsAsOfNowValue,
    gainPerDay: gainPerDay,
    gainPerSecond: gainPerSecond,
    gainThisYear: gainThisYear,
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

PortfolioTotalsStruct aggregateAtRetirement(
    List<PropertyProjectionsRecord> projections) {
  PortfolioTotalsStruct _makeTotals({
    required double annualRent,
    required double capitalValue,
    required double combinedDailyGain,
    required double cumulativeRentalProfit,
    required int? retirementYear,
    double? liveGainPerDay,
    double? liveGainPerSecond,
    double? liveGainThisYear,
    double? liveEarningsAsOfNow,
    int? currentYearIndex,
  }) {
    try {
      return createPortfolioTotalsStruct(
        annualRent: annualRent,
        capitalValue: capitalValue,
        combinedDailyGain: combinedDailyGain,
        cumulativeRentalProfit: cumulativeRentalProfit,
        retirementYear: retirementYear,
        liveGainPerDay: liveGainPerDay,
        liveGainPerSecond: liveGainPerSecond,
        liveGainThisYear: liveGainThisYear,
        liveEarningsAsOfNow: liveEarningsAsOfNow,
        currentYearIndex: currentYearIndex,
      );
    } catch (_) {
      return PortfolioTotalsStruct(
        annualRent: annualRent,
        capitalValue: capitalValue,
        combinedDailyGain: combinedDailyGain,
        cumulativeRentalProfit: cumulativeRentalProfit,
        retirementYear: retirementYear,
        liveGainPerDay: liveGainPerDay ?? 0.0,
        liveGainPerSecond: liveGainPerSecond ?? 0.0,
        liveGainThisYear: liveGainThisYear ?? 0.0,
        liveEarningsAsOfNow: liveEarningsAsOfNow ?? 0.0,
        currentYearIndex: currentYearIndex,
      );
    }
  }

  double _toDouble(dynamic v, [double fallback = 0.0]) {
    if (v == null) return fallback;
    if (v is num) return v.toDouble();
    if (v is String) {
      final parsed = double.tryParse(v.replaceAll(',', ''));
      return parsed ?? fallback;
    }
    return fallback;
  }

  double _sumIterable(dynamic values) {
    if (values is Iterable) {
      double s = 0.0;
      for (final x in values) {
        s += _toDouble(x);
      }
      return s;
    }
    return 0.0;
  }

  double r2(double v) => (v * 100).roundToDouble() / 100;

  // Parse "YYYY-MM-DD" -> LOCAL midnight (avoids UTC offset surprises)
  DateTime _parseYmdLocal(String ymd, DateTime fallback) {
    try {
      final parts = ymd.split('-');
      if (parts.length != 3) return fallback;
      final y = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final d = int.parse(parts[2]);
      return DateTime(y, m, d);
    } catch (_) {
      return fallback;
    }
  }

  // Returns {start, endExclusive} for a property period index, or null if missing/bad.
  ({DateTime start, DateTime endExcl})? _periodBounds(
      PropertyProjectionsRecord rec, int idx, DateTime now) {
    if (idx < 0) return null;
    if (rec.periodStartDates.length <= idx) return null;
    if (rec.periodEndDates.length <= idx) return null;

    final startStr = rec.periodStartDates[idx];
    final endStr = rec.periodEndDates[idx];

    final start = _parseYmdLocal(startStr, DateTime(now.year, 1, 1));
    final endInclusive = _parseYmdLocal(endStr, DateTime(now.year, 12, 31));
    final endExcl = endInclusive.add(const Duration(days: 1));

    if (!endExcl.isAfter(start)) return null;
    return (start: start, endExcl: endExcl);
  }

  // Annual gain for a period index (capital + rent). Falls back to combinedDailyGain*365 if needed.
  double _annualGainForIndex(PropertyProjectionsRecord rec, int idx) {
    final hasCapRent =
        rec.capitalGains.length > idx && rec.rentalProfit.length > idx;
    if (hasCapRent) {
      return _toDouble(rec.capitalGains[idx]) +
          _toDouble(rec.rentalProfit[idx]);
    }

    if (rec.combinedDailyGain.length > idx) {
      // You said 365 is fine here
      return _toDouble(rec.combinedDailyGain[idx]) * 365.0;
    }

    return 0.0;
  }

  // Calendar-year projected gain for ONE property by overlapping periods with [calStart, calEndExcl).
  double _calendarYearGainForProperty(PropertyProjectionsRecord rec,
      DateTime calStart, DateTime calEndExcl, DateTime now) {
    double total = 0.0;

    final maxIdx =
        math.min(rec.periodStartDates.length, rec.periodEndDates.length);

    for (var idx = 0; idx < maxIdx; idx++) {
      final b = _periodBounds(rec, idx, now);
      if (b == null) continue;

      final start = b.start;
      final endExcl = b.endExcl;

      // overlap window
      final overlapStart = start.isAfter(calStart) ? start : calStart;
      final overlapEnd = endExcl.isBefore(calEndExcl) ? endExcl : calEndExcl;

      if (!overlapEnd.isAfter(overlapStart)) continue;

      final secondsInPeriod = endExcl.difference(start).inSeconds.toDouble();
      if (secondsInPeriod <= 0) continue;

      final annualGain = _annualGainForIndex(rec, idx);
      if (annualGain == 0.0) continue;

      final perSecond = annualGain / secondsInPeriod;
      final overlapSeconds =
          overlapEnd.difference(overlapStart).inSeconds.toDouble();

      total += perSecond * overlapSeconds;
    }

    return total;
  }

  // Pro-rata gain accrued so far within the CURRENT property-year period (for earnings-as-of-now).
  double _gainSoFarInCurrentPropertyPeriod(
      PropertyProjectionsRecord rec, DateTime now) {
    final maxIdx =
        math.min(rec.periodStartDates.length, rec.periodEndDates.length);

    for (var idx = 0; idx < maxIdx; idx++) {
      final b = _periodBounds(rec, idx, now);
      if (b == null) continue;

      final start = b.start;
      final endExcl = b.endExcl;

      if (now.isBefore(start) || !now.isBefore(endExcl)) continue;

      final secondsInPeriod = endExcl.difference(start).inSeconds.toDouble();
      if (secondsInPeriod <= 0) return 0.0;

      final annualGain = _annualGainForIndex(rec, idx);
      if (annualGain == 0.0) return 0.0;

      final secondsPassed = now
          .difference(start)
          .inSeconds
          .toDouble()
          .clamp(0.0, secondsInPeriod);

      final perSecond = annualGain / secondsInPeriod;
      return perSecond * secondsPassed;
    }

    return 0.0;
  }

  // ───────────────────────── At-retirement sums ─────────────────────────
  double sumAnnualRent = 0.0;
  double sumCapitalValue = 0.0;
  double sumCombinedDailyGain = 0.0;
  double sumCumulativeRentalProfit = 0.0;
  int? retirementYear;

  // ───────────────────────── Live stats (calendar year) ─────────────────────────
  final now = DateTime.now();
  final calStart = DateTime(now.year, 1, 1);
  final calEndExcl = DateTime(now.year + 1, 1, 1);
  final secondsInCalendarYear = calEndExcl
      .difference(calStart)
      .inSeconds
      .toDouble()
      .clamp(1.0, double.infinity);

  double liveCalendarYearGain = 0.0;
  double liveEarningsAsOfNow = 0.0;

  for (final rec in projections) {
    if (rec == null) continue;

    // At-retirement aggregation
    sumAnnualRent += _toDouble(rec.atRetirementAnnualRent);
    sumCapitalValue += _toDouble(rec.atRetirementCapitalValue);
    sumCombinedDailyGain += _toDouble(rec.atRetirementCombinedDailyGain);

    final crp = _toDouble(rec.atRetirementCumulativeRentalProfit);
    if (crp != 0.0) {
      sumCumulativeRentalProfit += crp;
    } else {
      sumCumulativeRentalProfit += _sumIterable(rec.rentalProfit);
    }

    retirementYear ??= (rec.atRetirementYear is int)
        ? rec.atRetirementYear as int
        : int.tryParse('${rec.atRetirementYear}');

    // Calendar-year gain (projection, pro-rated across overlapping property periods)
    liveCalendarYearGain +=
        _calendarYearGainForProperty(rec, calStart, calEndExcl, now);

    // Earnings-as-of-now since joining Addressed (requires these fields to exist on the projection doc)
    final estimatedValueNow = _toDouble(rec.estimatedValueNow);
    final joinValuation = _toDouble(rec.priceValuationOnJoiningAddressed);
    final prevIncome = _toDouble(rec.previousRentalIncome);
    final prevExpenses = _toDouble(rec.previousExpenses);

    final capitalGainSinceJoining = estimatedValueNow - joinValuation;
    final historicalNetRent = prevIncome - prevExpenses;
    final proRataCurrentPeriod = _gainSoFarInCurrentPropertyPeriod(rec, now);

    liveEarningsAsOfNow +=
        (capitalGainSinceJoining + historicalNetRent + proRataCurrentPeriod);
  }

  // IMPORTANT: do NOT round per-second values (counters will stutter or stick)
  final liveGainPerSecond = liveCalendarYearGain / secondsInCalendarYear;
  final liveGainPerDay = liveGainPerSecond * 86400.0;

  return _makeTotals(
    annualRent: r2(sumAnnualRent),
    capitalValue: r2(sumCapitalValue),
    combinedDailyGain: r2(sumCombinedDailyGain),
    cumulativeRentalProfit: r2(sumCumulativeRentalProfit),
    retirementYear: retirementYear,
    liveGainPerDay: r2(liveGainPerDay),
    liveGainPerSecond: liveGainPerSecond, // <- keep full precision
    liveGainThisYear: r2(liveCalendarYearGain),
    liveEarningsAsOfNow: r2(liveEarningsAsOfNow),
    currentYearIndex: null,
  );
}

int computePortfolioScore(
  double? capitalValue,
  double? annualRentalIncome,
  double? targetEquity,
  double? targetIncome,
) {
  // Tunables (adjust if needed)
  const double kEquityWeight = 0.5; // 50% capital, 50% income
  const double kGamma = 0.8; // concavity for below-target progress

  double _nz(double? v) => (v == null || v.isNaN || v.isInfinite) ? 0.0 : v;

  // Smooth progress 0..1: concave for below-target, capped above-target.
  double _progress(double actual, double target) {
    actual = _nz(actual);
    target = _nz(target);
    if (target <= 0)
      return actual >= 0 ? 1.0 : 0.0; // treat no/zero target as met
    final r = actual / target;
    if (r <= 0) return 0.0;
    final below = r < 1.0 ? math.pow(r, kGamma).toDouble() : 1.0;
    return below.clamp(0.0, 1.0);
  }

  final double capVal = _nz(capitalValue);
  final double rentYr = _nz(annualRentalIncome);
  final double tgtEq = _nz(targetEquity);
  final double tgtInc = _nz(targetIncome);

  // Determine weights; if a target is absent/zero, shift all weight to the other.
  final bool hasEq = tgtEq > 0;
  final bool hasInc = tgtInc > 0;

  if (!hasEq && !hasInc) return 999; // nothing to chase → max score

  double wEq = hasEq ? kEquityWeight : 0.0;
  double wInc = hasInc ? (1.0 - kEquityWeight) : 0.0;
  final wSum = wEq + wInc;
  if (wSum > 0) {
    wEq /= wSum;
    wInc /= wSum;
  }

  final pEq = _progress(capVal, tgtEq);
  final pInc = _progress(rentYr, tgtInc);

  final progress = (wEq * pEq) + (wInc * pInc); // 0..1
  int score = (progress * 999.0).round();
  if (score < 0) score = 0;
  if (score > 999) score = 999;
  return score;
}

int? convertStringToInteger(String? stringToConvert) {
  if (stringToConvert == null) {
    return null;
  }

  // Remove anything that isn't a digit or minus sign (handles things like "£1,200" or " 300 ")
  final cleaned = stringToConvert.replaceAll(RegExp(r'[^0-9\-]'), '');

  if (cleaned.isEmpty) {
    return null;
  }

  return int.tryParse(cleaned);
}

double getRatio(
  double current,
  double target,
) {
  if (target == 0) {
    return 0;
  }

  double ratio = current / target;

  // Cap at 1 if current > target
  if (ratio > 1) {
    ratio = 1;
  }

  // Round to 2 decimal places
  return double.parse(ratio.toStringAsFixed(2));
}

SalesOfferAtRetirementStruct? getSalesOfferProjectionAtRetirement(
  ProjectionsRecord? projection,
  PortfolioTotalsStruct? pvTotals,
  SalesOffersRecord? salesOfferDoc,
) {
  final retirementYear = pvTotals?.retirementYear;
  if (projection == null || retirementYear == null || pvTotals == null) {
    return null;
  }
  final years = projection.years;
  if (years.isEmpty) return null;

  final i = years.indexOf(retirementYear);
  final idx = i >= 0 ? i : years.length - 1;

  final purchasePrice = salesOfferDoc?.price ?? 0.0;
  final projectedValueAtRetirement = projection.projectedHousePrice.length > idx
      ? projection.projectedHousePrice[idx]
      : 0.0;
  final capitalValueIncrease = projectedValueAtRetirement - purchasePrice;
  final newCapitalValue = pvTotals.capitalValue + capitalValueIncrease;

  final annualRentIncrease =
      projection.rentalIncome.length > idx ? projection.rentalIncome[idx] : 0.0;
  final newAnnualRent = pvTotals.annualRent + annualRentIncrease;

  return SalesOfferAtRetirementStruct(
    newCapitalValue: newCapitalValue,
    capitalValueIncrease: capitalValueIncrease,
    newAnnualRent: newAnnualRent,
    annualRentIncrease: annualRentIncrease,
  );
}

double? releasableEquityForProperty(
  double? estimatedValue,
  double? mortgageRemaining,
  bool? mortgageEntered,
) {
  if (mortgageRemaining == null) return 0.0;
  final val = (estimatedValue ?? 0.0) * 0.75;
  final mortgage = mortgageRemaining;
  final releasable = val - mortgage;
  return releasable > 0 ? releasable : 0.0;
}

CapitalAvailableToInvestStruct? sumReleasableEquityAboveThreshold(
  List<PropertiesRecord>? properties,
  double? threshold,
  double? availableCapital,
  List<PropertyProjectionsRecord>? projections,
  double? targetForUpgradeDate,
) {
  final own = availableCapital ?? 0.0;
  final th = threshold ?? 15000.0;

  double releasable = 0.0;
  final list = properties ?? [];
  for (final p in list) {
    if (p.mortgageEntered != true) continue;
    final val = (p.estimatedValue ?? 0.0) * 0.75;
    final mortgage = p.mortgageRemaining ?? 0.0;
    final eq = val - mortgage;
    if (eq > 0 && eq >= th) {
      releasable += eq;
    }
  }

  final total = own + releasable;

  // Upgrade date: only when target and projections provided
  bool hasUpgradeDate = false;
  DateTime? upgradeDate;
  final target = targetForUpgradeDate ?? 35000.0;
  final projList = projections ?? [];

  if (projList.isNotEmpty && total < target) {
    final shortfall = target - total;
    final now = DateTime.now();

    DateTime parseYmd(String ymd, DateTime fallback) {
      try {
        final parts = ymd.split('-');
        if (parts.length != 3) return fallback;
        return DateTime(
            int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      } catch (_) {
        return fallback;
      }
    }

    // Use first projection for period timeline; combine daily gain across all projections
    final first = projList.first;
    final starts = first.periodStartDates;
    final ends = first.periodEndDates;
    if (starts.isNotEmpty && ends.isNotEmpty) {
      double combinedDailyForPeriod(int idx) {
        double sum = 0.0;
        for (final pr in projList) {
          if (idx < pr.dailyCapitalGain.length) {
            sum += 0.75 * pr.dailyCapitalGain[idx];
          }
        }
        return sum;
      }

      int currentPeriodIdx = -1;
      for (int i = 0; i < starts.length && i < ends.length; i++) {
        final start = parseYmd(starts[i], now);
        final endInclusive = parseYmd(ends[i], now);
        final endExcl = endInclusive.add(const Duration(days: 1));
        if (!now.isBefore(start) && now.isBefore(endExcl)) {
          currentPeriodIdx = i;
          break;
        }
      }

      if (currentPeriodIdx >= 0) {
        double remainingGap = shortfall;
        int totalDays = 0;

        for (int idx = currentPeriodIdx;
            idx < starts.length && idx < ends.length;
            idx++) {
          final dailyGain = combinedDailyForPeriod(idx);
          if (dailyGain <= 0) continue;

          final start = parseYmd(starts[idx], now);
          final endInclusive = parseYmd(ends[idx], now);
          final endExcl = endInclusive.add(const Duration(days: 1));

          int daysInPeriod;
          if (idx == currentPeriodIdx) {
            daysInPeriod = endExcl.difference(now).inDays;
            if (daysInPeriod < 0) daysInPeriod = 0;
          } else {
            daysInPeriod = endExcl.difference(start).inDays;
          }

          final gainInPeriod = daysInPeriod * dailyGain;

          if (remainingGap <= gainInPeriod) {
            final daysNeeded = (remainingGap / dailyGain).round();
            totalDays += daysNeeded;
            remainingGap = 0;
            break;
          } else {
            remainingGap -= gainInPeriod;
            totalDays += daysInPeriod;
          }
        }

        if (remainingGap <= 0) {
          hasUpgradeDate = true;
          upgradeDate = now.add(Duration(days: totalDays));
        }
      }
    }
  } else if (targetForUpgradeDate != null && total >= target) {
    hasUpgradeDate = true;
    upgradeDate = DateTime.now();
  }

  // Don't show upgrade date if over threshold, or if the calculated date is today
  if (total >= target) {
    hasUpgradeDate = false;
  } else if (hasUpgradeDate && upgradeDate != null) {
    final today = DateTime.now();
    if (upgradeDate!.year == today.year &&
        upgradeDate!.month == today.month &&
        upgradeDate!.day == today.day) {
      hasUpgradeDate = false;
    }
  }

  return CapitalAvailableToInvestStruct(
    ownCapital: own,
    releasableEquity: releasable,
    totalCapitalAvailable: total,
    hasUpgradeDate: hasUpgradeDate,
    upgradeDate: upgradeDate,
  );
}

double? calculatePurchasingPower(
  double totalCapital,
  double ltvPercent,
) {
  if (totalCapital <= 0) return 0;
  double depositPercent = (100 - ltvPercent) / 100;
  if (depositPercent <= 0) return 0;
  return totalCapital / depositPercent;
}

int? parseMoneyToInt(String? raw) {
  if (raw == null) return null;
  final cleaned = raw.replaceAll(RegExp(r'[^0-9\.-]'), '');
  if (cleaned.isEmpty || cleaned == '-' || cleaned == '.' || cleaned == '-.') {
    return null;
  }
  final value = double.tryParse(cleaned);
  if (value == null) return null;
  return value.round();
}

String? getUserInitials(String? displayName) {
  final name = displayName?.trim() ?? '';
  if (name.isEmpty) return '?';
  final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) {
    final w = parts.first;
    return w.length >= 2
        ? w.substring(0, 2).toUpperCase()
        : w.substring(0, 1).toUpperCase();
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

PortfolioSnapshotStruct? aggregatePortfolioFromProperties(
    List<PropertiesRecord>? properties) {
  double nz(double? v) => (v == null || v.isNaN || v.isInfinite) ? 0.0 : v;
  final list = properties ?? [];
  final count = list.length;
  double totalValue = 0.0;
  double totalEquity = 0.0;
  double annualRent = 0.0;
  double capitalGain = 0.0;
  double annualRentForYield = 0.0;
  double totalPurchaseForYield = 0.0;
  int mortgageEnteredCount = 0;
  int purchasePriceEnteredCount = 0;

  for (final p in list) {
    final value = nz(p.estimatedValue);
    final mortgage = nz(p.mortgageRemaining);
    final rent = nz(p.currentRentAmount);
    final purchase = nz(p.purchasePrice);
    final joining = nz(p.priceValuationOnJoiningAddressed);

    totalValue += value;

    if (p.mortgageEntered == true) {
      mortgageEnteredCount += 1;
      totalEquity += (value - mortgage).clamp(0.0, double.infinity);
    }
    annualRent += rent * 12.0;

    if (purchase > 0) {
      purchasePriceEnteredCount += 1;
      totalPurchaseForYield += purchase;
      annualRentForYield += rent * 12.0;
    }

    // Capital gain: purchase price first, then joining valuation, else skip
    final baseline = purchase > 0 ? purchase : (joining > 0 ? joining : 0.0);
    if (baseline > 0) {
      capitalGain += value - baseline;
    }
  }

  final avgYieldRaw = totalPurchaseForYield > 0
      ? (annualRentForYield / totalPurchaseForYield) * 100.0
      : 0.0;
  final avgYield = double.parse(avgYieldRaw.toStringAsFixed(2));

  return createPortfolioSnapshotStruct(
    propertyCount: count,
    totalValue: totalValue,
    totalEquity: totalEquity,
    annualRent: annualRent,
    avgYield: avgYield,
    capitalGainSinceJoining: capitalGain,
    avgMonthlyRent: annualRent / 12.0,
    mortgageEnteredCount: mortgageEnteredCount,
    purchasePriceEnteredCount: purchasePriceEnteredCount,
  );
}

double? estimateValuationOnJoiningAddressed(
  double? purchasePrice,
  DateTime? purchaseDate,
  double? estimatedValueNow,
  DateTime? dateJoinedAddressed,
) {
  final purchase = purchasePrice ?? 0.0;
  final valueNow = estimatedValueNow ?? 0.0;
  if (purchaseDate == null || dateJoinedAddressed == null) return null;
  if (!(purchase > 0) || !(valueNow > 0)) return null;
  final purchaseDay = DateTime(
    purchaseDate.year,
    purchaseDate.month,
    purchaseDate.day,
  );
  final joinDay = DateTime(
    dateJoinedAddressed.year,
    dateJoinedAddressed.month,
    dateJoinedAddressed.day,
  );
  final today = DateTime.now();
  final todayDay = DateTime(today.year, today.month, today.day);
  final daysPurchaseToToday = todayDay.difference(purchaseDay).inDays;
  if (daysPurchaseToToday <= 0) {
    return double.parse(valueNow.toStringAsFixed(2));
  }
  final daysPurchaseToJoin = joinDay.difference(purchaseDay).inDays;
  if (daysPurchaseToJoin <= 0) {
    return double.parse(purchase.toStringAsFixed(2));
  }
  if (daysPurchaseToJoin >= daysPurchaseToToday) {
    return double.parse(valueNow.toStringAsFixed(2));
  }
  final fraction = daysPurchaseToJoin / daysPurchaseToToday;
  final estimated = purchase + ((valueNow - purchase) * fraction);
  return double.parse(estimated.toStringAsFixed(2));
}

int? annualToMonthly(int? annual) {
  if (annual == null) return null;
  return (annual / 12).round();
}

int? monthlyToAnnual(String? raw) {
  final monthly = parseMoneyToInt(raw); // or inline the same cleaning
  if (monthly == null) return null;
  return monthly * 12;
}

double? toMonthly(double? annual) {
  if (annual == null) return null;
  return annual / 12.0;
}

double? propertyRoiPct(
  double? rentalIncome,
  double? purchasePrice,
  double? mortgageRemaining,
) {
  final income = rentalIncome ?? 0.0;
  final purchase = purchasePrice ?? 0.0;
  final mortgage = mortgageRemaining ?? 0.0;
  final investment = purchase - mortgage;
  if (investment <= 0) return 0.0;
  final roi = (income / investment) * 100.0;
  return double.parse(roi.toStringAsFixed(2));
}

double? parsePositiveAmount(String? raw) {
  if (raw == null) return null;
  final cleaned = raw.replaceAll(RegExp(r'[^0-9.]'), '');
  if (cleaned.isEmpty) return null;
  final n = double.tryParse(cleaned);
  if (n == null || n <= 0) return null;
  return n;
}
