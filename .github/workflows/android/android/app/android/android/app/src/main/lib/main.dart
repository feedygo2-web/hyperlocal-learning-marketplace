import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/student/student_home_screen.dart';
import 'screens/trainer/trainer_home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/student_signup_screen.dart';
import 'screens/auth/trainer_signup_screen.dart';
import 'providers/auth_provider.dart';
import 'config/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Hyperlocal Learning',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const AuthCheck(),
        routes: {
          '/role_selection': (context) => const RoleSelectionScreen(),
          '/student_signup': (context) => const StudentSignupScreen(),
          '/trainer_signup': (context) => const TrainerSignupScreen(),
          '/login': (context) => const LoginScreen(),
          '/student_home': (context) => const StudentHomeScreen(),
          '/trainer_home': (context) => const TrainerHomeScreen(),
        },
      ),
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  void _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.checkAuthStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.school,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Hyperlocal Learning',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const CircularProgressIndicator(),
                ],
              ),
            );
          }
          if (authProvider.user != null) {
            return authProvider.userRole == 'trainer'
                ? const TrainerHomeScreen()
                : const StudentHomeScreen();
          }
          return const RoleSelectionScreen();
        },
      ),
    );
  }
}
