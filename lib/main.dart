import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const VayviApp());
}

class VayviApp extends StatelessWidget {
  const VayviApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VAYVI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFD4AF37),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Color(0xFFD4AF37),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _shareApp() {
    Share.share('Download VAYVI 5.2 - Velipooodhaam Travel App: https://velipooodhaam.com');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('VAYVI', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Color(0xFFD4AF37)),
            onPressed: _shareApp,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text('V', style: TextStyle(fontSize: 70, color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('VAYVI 5.2', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 28, fontWeight: FontWeight.bold)),
            const Text('Velipooodhaam', style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), foregroundColor: Colors.black),
              onPressed: () => _openLink('https://google.com'),
              child: const Text('Explore Trips'),
            ),
            const SizedBox(height: 15),
            OutlinedButton(
              style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFD4AF37), side: const BorderSide(color: Color(0xFFD4AF37))),
              onPressed: _shareApp,
              child: const Text('Share VAYVI'),
            ),
          ],
        ),
      ),
    );
  }
}
