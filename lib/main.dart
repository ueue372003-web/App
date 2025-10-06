import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lnmq/firebase_options.dart';
import 'package:lnmq/screens/auth_screen.dart';
import 'package:lnmq/screens/home_screen.dart';
import 'package:lnmq/admin_screens/admin_home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lnmq/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('vi');
  Locale get locale => _locale;
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (_) => LocaleProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    return MaterialApp(
      title: 'Travel App Vietnam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'BeVietnamPro',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
      ],
      locale: localeProvider.locale,
      home: HomeScreenWithLanguageSwitcher(),
      routes: {
        '/auth': (context) => const AuthScreen(),
      },
    );
  }
}

class HomeScreenWithLanguageSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreen(),
      appBar: AppBar(
        actions: [
          LanguageSwitcher(),
        ],
      ),
    );
  }
}

class LanguageSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    return DropdownButton<Locale>(
      value: provider.locale,
      items: const [
        DropdownMenuItem(
          value: Locale('vi'),
          child: Text('Tiếng Việt'),
        ),
        DropdownMenuItem(
          value: Locale('en'),
          child: Text('English'),
        ),
      ],
      onChanged: (locale) {
        if (locale != null) provider.setLocale(locale);
      },
    );
  }
}