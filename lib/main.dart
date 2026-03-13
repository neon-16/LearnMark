import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/checkin_screen.dart';
import 'screens/finish_class_screen.dart';
import 'screens/history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization error: $e');
    // App can still run with local storage only
  }
  
  runApp(const LearnMarkApp());
}

class LearnMarkApp extends StatelessWidget {
  const LearnMarkApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryCool = Color(0xFF0EA5E9); // cool blue
    const deepCool = Color(0xFF0B7285); // teal/blue-green
    const textDark = Color(0xFF0F172A); // near-black for contrast

    return MaterialApp(
      title: 'LearnMark',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryCool,
          primary: primaryCool,
          secondary: deepCool,
          background: const Color(0xFFF4F8FB),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F8FB),
        useMaterial3: true,
        textTheme: Typography.blackMountainView.apply(
          bodyColor: textDark,
          displayColor: textDark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: deepCool,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 3,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryCool.withOpacity(0.35)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryCool.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryCool, width: 1.6),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/checkin': (context) => const CheckInScreen(),
        '/finish': (context) => const FinishClassScreen(),
        '/history': (context) => const HistoryScreen(),
      },
    );
  }
}
