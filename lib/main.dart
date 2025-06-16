import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'homepage.dart';

void main() {
  tz.initializeTimeZones();
  tz.setLocalLocation(
    tz.getLocation('Asia/Tashkent'),
  ); // O‘zbekiston vaqt zonasi
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}


//? Ushbu kod Riverpod yordamida oddiy counter ilovasini yaratadi.
//! Bu ilova Riverpod providerlarini ishlatib, sonni ko‘rsatadi va +1 tugmasi bosilganda qiymatni oshiradi.
//? Riverpod yordamida holatni boshqarish juda oson va qulay.
//! Ushbu kodni o‘zingizning Flutter loyihangizga qo‘shib, Riverpod bilan ishlashni boshlashingiz mumkin.
//? Riverpod yordamida holatni boshqarish juda oson va qulay.
//? Ushbu kodni o‘zingizning Flutter loyihangizga qo‘shib, Riverpod bilan ishlashni boshlashingiz mumkin.
//todo Riverpod yordamida holatni boshqarish juda oson va qulay.
//todo Ushbu kodni o‘zingizning Flutter loyihangizga qo‘shib, Riverpod bilan ishlashni boshlashingiz mumkin.
//todo Ushbu kod Riverpod yordamida oddiy counter ilovasini yaratadi.
//? Bu ilova Riverpod providerlarini ishlatib, sonni ko‘rsatadi va +1 tugmasi bosilganda qiymatni oshiradi.
//! Riverpod yordamida holatni boshqarish juda oson va qulay.
//? Ushbu kodni o‘zingizning Flutter loyihangizga qo‘shib, Riverpod bilan ishlashni boshlashingiz mumkin.
//! Ushbu kod Riverpod yordamida oddiy counter ilovasini yaratadi.
//todo Bu ilova Riverpod providerlarini ishlatib, sonni ko‘rsatadi va +1 tugmasi bosilganda qiymatni oshiradi.
//? Riverpod yordamida holatni boshqarish juda oson va qulay.
//todo Ushbu kodni o‘zingizning Flutter loyihangizga qo‘shib, Riverpod bilan ishlashni boshlashingiz mumkin.
//? Ushbu kod Riverpod yordamida oddiy counter ilovasini yaratadi.
//! Bu ilova Riverpod providerlarini ishlatib, sonni ko‘rsatadi va +1 tugmasi bosilganda qiymatni oshiradi.
//? Riverpod yordamida holatni boshqarish juda oson va qulay.
//todo Ushbu kodni o‘zingizning Flutter loyihangizga qo‘shib, Riverpod bilan ishlashni boshlashingiz mumkin.
//? Ushbu kod Riverpod yordamida oddiy counter ilovasini yaratadi.
//! Bu ilova Riverpod providerlarini ishlatib, sonni ko‘rsatadi va +1 tugmasi bosilganda qiymatni oshiradi.
//todo Riverpod yordamida holatni boshqarish juda oson va qulay.
//? Ushbu kodni o‘zingizning Flutter loyihangizga qo‘shib, Riverpod bilan ishlashni boshlashingiz mumkin.
// Ushbu kod Riverpod yordamida oddiy counter ilovasini yaratadi.
//? Bu ilova Riverpod providerlarini ishlatib, sonni ko‘rsatadi va +1 tugmasi bosilganda qiymatni oshiradi.
//! Riverpod yordamida holatni boshqarish juda oson va qulay.
//? Ushbu kodni o‘zingizning Flutter loyihangizga qo‘shib, Riverpod bilan ishlashni boshlashingiz mumkin.
// Ushbu kod Riverpod yordamida oddiy counter ilovasini yaratadi.
//! Bu ilova Riverpod providerlarini ishlatib, sonni ko‘rsatadi va +1 tugmasi bosilganda qiymatni oshiradi.
//? Riverpod yordamida holatni boshqarish juda oson va qulay.
// Ushbu kodni o‘zingizning Flutter loyihangizga qo‘shib, Riverpod bilan ishlashni boshlashingiz mumkin.
//! Ushbu kod Riverpod yordamida oddiy counter ilovasini yaratadi.
//? Bu ilova Riverpod providerlarini ishlatib, sonni ko‘rsatadi va +1 tugmasi bosilganda qiymatni oshiradi.
// Riverpod yordamida holatni boshqarish juda oson va qulay.
//? Ushbu kodni o‘zingizning Flutter loyihangizga qo‘shib, Riverpod bilan ishlashni boshlashingiz mumkin.
// !Ushbu kod Riverpod yordamida oddiy counter ilovasini yaratadi.
//? Bu ilova Riverpod providerlarini ishlatib, sonni ko‘rsatadi va +1 tugmasi bosilganda qiymatni oshiradi.
// Riverpod yordamida holatni boshqarish juda oson va qulay.
//? Ushbu kodni o‘zingizning Flutter loyihangizga qo‘shib, Riverpod bilan ishlashni boshlashingiz mumkin.
//todo Ushbu kod Riverpod yordamida oddiy counter ilovasini yaratadi.
//? Bu ilova Riverpod providerlarini ishlatib, sonni ko‘rsatadi va +1 tugmasi bosilganda qiymatni oshiradi.
// !Riverpod yordamida holatni boshqarish juda oson va qulay.
//? Ushbu kodni o‘zingizning Flutter loyihangizga qo‘shib, Riverpod bilan ishlashni boshlashingiz mumkin.



