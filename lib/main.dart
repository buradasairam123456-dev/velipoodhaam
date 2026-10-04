import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() => runApp(TripApp());

class TripApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, title: 'TRIP KI VELTHAAM', home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  // SAI - ikkada nee API Key pettu - aistudio.google.com nundi techuko
  final String geminiKey = "YOUR_API_KEY_HERE";

  final places = [
    {"name": "Araku Valley", "price": "Rs 1500", "img": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800", "icon": "🏔️", "desc": "Coffee Hills & Borra Caves"},
    {"name": "Lambasingi", "price": "Rs 1200", "img": "https://images.unsplash.com/photo-1491002052546-bf38f186af56?w=800", "icon": "❄️", "desc": "Andhra Kashmir - Misty Hills"},
    {"name": "SKLM Beach", "price": "Rs 800", "img": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800", "icon": "🏖️", "desc": "Srikakulam Beach Paradise"},
  ];

  String localAnswer(String q){
    var l = q.toLowerCase();
    if(l.contains("araku")) return "🏔️ Araku Valley - Oct to March best SAI! Borra Caves, Coffee plantation, Train journey super. 2 Days Rs 1500.";
    if(l.contains("lamba")) return "❄️ Lambasingi - Dec-Jan mist super SAI! 0 degrees, camping, sweater compulsory!";
    if(l.contains("beach")||l.contains("sklm")) return "🏖️ SKLM Beach - Sunnapalle beach best SAI! Evening time super, Fish curry famous!";
    if(l.contains("cost")||l.contains("price")) return "💰 Cost: Araku Rs1500, Lambasingi Rs1200, Beach Rs800. Group ki discount - 8919540533 ki msg chey!";
    return "✨ SAI! Adigindi: $q\n\nNenu Sai Ram Charan SKLM guide ni. 3 places kuda best. Oct-March best season. BOOK NOW kottu!";
  }

  void bookTrip(String place) async {
    final url = Uri.parse("https://wa.me/918919540533?text=${Uri.encodeComponent("Hi Sai Anna, Nenu $place trip book cheyali. TRIP KI VELTHAAM app nundi - $place")}");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  void openYT(String place) async {
    await launchUrl(Uri.parse("https://www.youtube.com/results?search_query=$place+telugu+vlog"), mode: LaunchMode.externalApplication);
  }

  void askGemini(BuildContext context) {
    TextEditingController qc = TextEditingController();
    String ans = "Adugu SAI... Ex: Beach ki best time enti?";
    showDialog(context: context, builder: (ctx){
      return StatefulBuilder(builder: (ctx,setState){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(children:[Icon(Icons.auto_awesome, color: Colors.deepPurple), SizedBox(width:8), Text("Gemini AI ✨")]),
          content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children:[
            TextField(controller: qc, decoration: InputDecoration(hintText: "Nee doubt adugu SAI...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), maxLines: 2)),
            SizedBox(height:10),
            SizedBox(width: double.infinity, child: ElevatedButton.icon(icon: Icon(Icons.auto_awesome), label: Text("ASK GEMINI"), style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white), onPressed: () async {
              if(qc.text.isEmpty) return;
              setState(()=> ans = "⏳ Gemini alochistondi...");
              try{
                if(geminiKey.contains("YOUR_API")){
                  await Future.delayed(Duration(milliseconds: 600));
                  setState(()=> ans = "🤖 (Local Gemini Mode)\n\n" + localAnswer(qc.text) + "\n\nNote: Real Gemini kosam aistudio.google.com nundi API Key techi geminiKey lo pettu SAI!");
                  return;
                }
                final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: geminiKey);
                final res = await model.generateContent([Content.text("You are Telugu travel guide for Araku, Lambasingi, SKLM Beach. Answer in Telugu mix, short. Question: ${qc.text}")]);
                setState(()=> ans = "✨ Gemini:\n\n${res.text}");
              }catch(e){
                setState(()=> ans = "⚠️ Net issue, Local Answer:\n\n${localAnswer(qc.text)}");
              }
            })),
            SizedBox(height:12),
            Container(width: double.infinity, padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.deepPurple.shade50, borderRadius: BorderRadius.circular(12)), child: Text(ans, style: TextStyle(fontSize: 13, height: 1.4))),
          ])),
          actions: [TextButton(onPressed: ()=>Navigator.pop(ctx), child: Text("Close")), ElevatedButton(onPressed: (){Navigator.pop(ctx); bookTrip(qc.text);}, child: Text("Book Now"))],
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TRIP KI VELTHAAM - SKLM', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)), backgroundColor: Colors.deepPurple),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: places.length,
        itemBuilder: (c,i){
          var p = places[i];
          return Card(margin: EdgeInsets.only(bottom:20), elevation: 12, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), child: Column(children:[
            ClipRRect(borderRadius: BorderRadius.vertical(top: Radius.circular(20)), child: Stack(children:[
              Image.network(p["img"] as String, height: 200, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c,e,s)=> Container(height: 200, decoration: BoxDecoration(gradient: LinearGradient(colors:[Colors.blue, Colors.cyan])), child: Center(child: Text(p["icon"] as String, style: TextStyle(fontSize:60))))),
              Positioned(bottom:0, left:0, right:0, child: Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black87, Colors.transparent])), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(p["name"] as String, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), Text(p["desc"] as String, style: TextStyle(color: Colors.white70, fontSize: 13))]))),
            ])),
            ListTile(title: Text(p["name"] as String, style: TextStyle(fontWeight: FontWeight.bold)), subtitle: Text("${p["price"]} | ${p["desc"]}"), trailing: IconButton(icon: Icon(Icons.share, color: Colors.deepPurple), onPressed: ()=>Share.share('Trip Ki Velthaam - ${p["name"]} - Book: 8919540533 - Sai SKLM'))),
            Padding(padding: EdgeInsets.fromLTRB(12,0,12,14), child: Row(children:[
              Expanded(child: ElevatedButton.icon(icon: Icon(Icons.play_circle, size:18), label: Text("YouTube"), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), onPressed: ()=>openYT(p["name"] as String))),
              SizedBox(width:10),
              Expanded(child: ElevatedButton.icon(icon: Icon(Icons.book, size:18), label: Text("BOOK NOW"), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), onPressed: ()=>bookTrip(p["name"] as String))),
            ]))
          ]));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: ()=>askGemini(context), label: Text("Ask Gemini ✨"), icon: Icon(Icons.auto_awesome), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
    );
  }
}
