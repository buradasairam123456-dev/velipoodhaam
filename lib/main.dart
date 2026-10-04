import 'package:flutter/material.dart';
void main() => runApp(VellipodhamApp());

class VellipodhamApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VELIPODHAM 5.2',
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final places = [
    {"name": "Araku Valley", "img": "https://picsum.photos/400/200?1", "price": "₹2,999"},
    {"name": "Lambasingi", "img": "https://picsum.photos/400/200?2", "price": "₹1,999"},
    {"name": "Pithapuram", "img": "https://picsum.photos/400/200?3", "price": "₹999"},
    {"name": "Vizag Beach", "img": "https://picsum.photos/400/200?4", "price": "₹3,499"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("VELIPODHAM 5.2 🔥"), centerTitle: true, backgroundColor: Colors.orange),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: places.length,
        itemBuilder: (c, i) {
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(places[i]["img"]!, height: 180, width: double.infinity, fit: BoxFit.cover),
                ),
                ListTile(
                  title: Text(places[i]["name"]!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text("Explore the beauty"),
                  trailing: Text(places[i]["price"]!, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Booking Coming Soon!"))),
        label: Text("Book Now"), icon: Icon(Icons.flight),
      ),
    );
  }
}
