import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

void main() => runApp(TripApp());

class TripApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, title: 'TRIP KI VELTHAAM', home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  final places = [
    {"name": "Araku Valley", "price": "Rs 1500", "color1": Colors.green, "color2": Colors.lightGreen, "icon": "🏔️", "desc": "Coffee Hills & Tribal Culture"},
    {"name": "Lambasingi", "price": "Rs 1200", "color1": Colors.blue, "color2": Colors.cyan, "icon": "❄️", "desc": "Andhra Kashmir - Snow Point"},
    {"name": "SKLM Beach", "price": "Rs 800", "color1": Colors.orange, "color2": Colors.amber, "icon": "🏖️", "desc": "Srikakulam Beach Paradise"},
  ];

  void bookTrip(String place) async {
    String msg = "Hi Sai Ram Charan Anna (SKLM), Nenu $place trip book cheyali. TRIP KI VELTHAAM app nundi message chestunna.";
    final url = Uri.parse("https://wa.me/918919540533?text=${Uri.encodeComponent(msg)}");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  void openYT(String place) async {
    await launchUrl(Uri.parse("https://www.youtube.com/results?search_query=$place+trip+telugu"), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TRIP KI VELTHAAM', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), backgroundColor: Colors.deepPurple,
        actions: [IconButton(icon: Icon(Icons.person, color: Colors.white), onPressed: (){
          showDialog(context: context, builder: (_)=>AlertDialog(title: Text("Sai Ram Charan"), content: Text("App: TRIP KI VELTHAAM\nOwner: Sai Ram Charan Burada\nFrom: SKLM\nPhone: 8919540533\n\nBooking ki direct WhatsApp!"), actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: Text("OK"))]));
        })],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: places.length,
        itemBuilder: (c,i){
          var p = places[i];
          return Card(
            margin: EdgeInsets.only(bottom:18),
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(children: [
              Container(
                height: 180,
                decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(20)), gradient: LinearGradient(colors: [p["color1"] as Color, p["color2"] as Color], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(p["icon"] as String, style: TextStyle(fontSize: 60)),
                  SizedBox(height:8),
                  Text(p["name"] as String, style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  Text(p["desc"] as String, style: TextStyle(color: Colors.white70, fontSize: 14)),
                ])),
              ),
              ListTile(
                title: Text(p["name"] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                subtitle: Text("${p["price"]} - Best Trip | SKLM"),
                trailing: IconButton(icon: Icon(Icons.share, color: Colors.deepPurple), onPressed: ()=>Share.share('Trip Ki Velthaam - ${p["name"]} - Book now: 8919540533 by Sai Ram Charan SKLM')),
              ),
              Padding(padding: EdgeInsets.fromLTRB(12,0,12,14), child: Row(children: [
                Expanded(child: ElevatedButton.icon(icon: Icon(Icons.play_circle), label: Text("YouTube"), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: ()=>openYT(p["name"] as String))),
                SizedBox(width:12),
                Expanded(child: ElevatedButton.icon(icon: Icon(Icons.book_online), label: Text("BOOK NOW"), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: ()=>bookTrip(p["name"] as String))),
              ]))
            ]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: ()=>bookTrip("General Trip"), label: Text("Book on WhatsApp - 8919540533"), icon: Icon(Icons.chat), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
    );
  }
}
