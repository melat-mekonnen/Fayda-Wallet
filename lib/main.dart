import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:digital_fayda_wallet/app.dart';
import 'package:digital_fayda_wallet/core/utils/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.settingsBox);
  await Hive.openBox(AppConstants.userDataBox);
  
  runApp(
    const ProviderScope(
      child: DigitalFaydaWalletApp(),
    ),
  );
}