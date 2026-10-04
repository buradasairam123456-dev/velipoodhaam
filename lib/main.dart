import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(TripApp());

class TripApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, title: 'TRIP KI VELTHAAM', home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  // SAI API KEY - aistudio.google.com nundi free key tecchi ikkada vey
  final String geminiKey = "YOUR_API_KEY_HERE";

  final places = [
    {"name": "Araku Valley", "price": "Rs 1500", "img": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800", "desc": "Coffee Hills & Borra Caves"},
    {"name": "Lambasingi", "price": "Rs 1200", "img": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800", "desc": "Andhra Kashmir"},
    {"name": "SKLM Beach", "price": "Rs 800", "img": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800", "desc": "Srikakulam Beach Paradise"},
  ];

  String localAns(String q){
    var l=q.toLowerCase();
    if(l.contains("araku")) return "🏔️ Araku Valley Oct-March best SAI! Borra Caves, Coffee hills super. 2 Days Rs1500.";
    if(l.contains("lamba")) return "❄️ Lambasingi Dec-Jan best, 0 degrees, mist super SAI!";
    if(l.contains("beach")||l.contains("sklm")) return "🏖️ SKLM Beach Sunnapalle beach best SAI! Evening super, Fish curry famous!";
    return "✨ SAI adigindi: $q\n\nNenu SKLM Sai guide ni. 3 places best, Oct-March season. BOOK NOW kottu 8919540533!";
  }

  void bookTrip(String place) async {
    final url = Uri.parse("https://wa.me/918919540533?text=${Uri.encodeComponent("Hi Sai Anna, Nenu $place trip book cheyali - TRIP KI VELTHAAM app")}");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  void openYT(String p) async {
    await launchUrl(Uri.parse("https://www.youtube.com/results?search_query=$p+telugu"), mode: LaunchMode.externalApplication);
  }

  void askGemini(BuildContext context) {
    TextEditingController qc = TextEditingController();
    String ans = "Adugu SAI... Beach ki best time enti?";
    showDialog(context: context, builder: (ctx){
      return StatefulBuilder(builder: (ctx,setState){
        return AlertDialog(
          title: Text("Gemini AI ✨ - SAI"),
          content: Column(mainAxisSize: MainAxisSize.min, children:[
            TextField(controller: qc, decoration: InputDecoration(hintText: "Doubt adugu...", border: OutlineInputBorder())),
            SizedBox(height:10),
            ElevatedButton(onPressed: () async {
              if(qc.text.isEmpty) return;
              setState(()=> ans = "⏳ Thinking...");
              try{
                if(geminiKey.contains("YOUR_API")){
                  setState(()=> ans = "🤖 Local Gemini:\n\n${localAns(qc.text)}\n\n(Real Gemini kosam API Key pettu SAI - aistudio.google.com)");
                  return;
                }
                var url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$geminiKey");
                var body = jsonEncode({"contents": [{"parts": [{"text": "You are Telugu travel guide for SKLM trips. Answer short in Telugu mix: ${qc.text}"}]}]});
                var res = await http.post(url, headers: {"Content-Type":"application/json"}, body: body);
                if(res.statusCode==200){
                  var data = jsonDecode(res.body);
                  var txt = data["candidates"][0]["content"]["parts"][0]["text"];
                  setState(()=> ans = "✨ Gemini:\n\n$txt");
                } else {
                  setState(()=> ans = "Local:\n\n${localAns(qc.text)}");
                }
              }catch(e){
                setState(()=> ans = "Local:\n\n${localAns(qc.text)}");
              }
            }, child: Text("ASK GEMINI")),
            SizedBox(height:10),
            Container(padding: EdgeInsets.all(10), color: Colors.deepPurple.shade50, child: Text(ans)),
          ]),
          actions: [TextButton(onPressed: ()=>Navigator.pop(ctx), child: Text("Close"))],
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TRIP KI VELTHAAM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), backgroundColor: Colors.deepPurple),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: places.length,
        itemBuilder: (c,i){
          var p=places[i];
          return Card(margin: EdgeInsets.only(bottom:18), elevation:10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), child: Column(children:[
            ClipRRect(borderRadius: BorderRadius.vertical(top: Radius.circular(20)), child: Image.network(p["img"] as String, height: 200, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c,e,s)=> Container(height:200, color: Colors.blue, child: Icon(Icons.beach_access, size:60, color: Colors.white)))),
            ListTile(title: Text(p["name"] as String, style: TextStyle(fontWeight: FontWeight.bold)), subtitle: Text("${p["price"]} | ${p["desc"]}"), trailing: IconButton(icon: Icon(Icons.share, color: Colors.deepPurple), onPressed: ()=>Share.share('${p["name"]} - 8919540533'))),
            Padding(padding: EdgeInsets.fromLTRB(12,0,12,12), child: Row(children:[
              Expanded(child: ElevatedButton(onPressed: ()=>openYT(p["name"] as String), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), child: Text("YouTube"))),
              SizedBox(width:10),
              Expanded(child: ElevatedButton(onPressed: ()=>bookTrip(p["name"] as String), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white), child: Text("BOOK NOW"))),
            ]))
          ]));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: ()=>askGemini(context), label: Text("Ask Gemini ✨"), icon: Icon(Icons.auto_awesome), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
    );
  }
}
