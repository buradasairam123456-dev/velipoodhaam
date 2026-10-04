import 'package:flutter/material.dart';
void main() => runApp(VellipodhamApp());

class VellipodhamApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VELIPODHAM 5.2',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final places = [
    {"name": "Araku Valley", "img": "https://images.unsplash.com/photo-1586016413661-bd4f3e7e01f6?w=500"},
    {"name": "Lambasingi", "img": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=500"},
    {"name": "Pithapuram", "img": "https://images.unsplash.com/photo-1527631746610-bca00a040d60?w=500"},
    {"name": "Vizag Beach", "img": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VELIPODHAM 5.2')),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: places.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
            child: Column(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      places[index]["img"]!,
                      fit: BoxFit.cover,
                      loadingBuilder: (c, child, progress) {
                        if (progress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (c, e, s) => Center(child: Icon(Icons.broken_image, size: 50)),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(places[index]["name"]!, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
