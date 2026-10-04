import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() => runApp(TripApp());

class TripApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TRIP KI VELTHAAM',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final places = [
    {"name": "Araku Valley", "img": "https://images.unsplash.com/photo-1586016413661-bd4f3e7e01f6?w=500", "price": "Rs 1500"},
    {"name": "Lambasingi", "img": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=500", "price": "Rs 1200"},
    {"name": "Srikakulam Beach", "img": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500", "price": "Rs 800"},
  ];

  void bookTrip(String place) async {
    String msg = "Hi Sai Ram Charan Anna, Nenu $place trip book cheyali - TRIP KI VELTHAAM app nundi";
    final url = Uri.parse("https://wa.me/918919540533?text=${Uri.encodeComponent(msg)}");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  void openYT() async {
    await launchUrl(Uri.parse("https://www.youtube.com/results?search_query=araku+valley+trip"), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TRIP KI VELTHAAM', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(icon: Icon(Icons.smart_toy), onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>GeminiScreen()))),
          IconButton(icon: Icon(Icons.person), onPressed: (){
            showDialog(context: context, builder: (_)=>AlertDialog(
              title: Text("My Details"),
              content: Text("App: TRIP KI VELTHAAM\n\nOwner: Sai Ram Charan Burada\nFrom: SKLM (Srikakulam)\nPhone: 8919540533\n\nBooking cheste na WhatsApp ki direct vastadi!"),
              actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: Text("OK"))],
            ));
          })
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: places.length,
        itemBuilder: (c,i){
          return Card(
            margin: EdgeInsets.only(bottom:16),
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(places[i]["img"]!, height: 220, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (c,e,s)=>Container(height:220,color:Colors.grey[300],child:Icon(Icons.landscape,size:50)),
                ),
              ),
              ListTile(
                title: Text(places[i]["name"]!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                subtitle: Text("${places[i]["price"]} - Best Trip"),
                trailing: IconButton(icon: Icon(Icons.share, color: Colors.blue), onPressed: ()=>Share.share('Check ${places[i]["name"]} in TRIP KI VELTHAAM App by Sai Ram Charan! Book: 8919540533')),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Row(children: [
                  Expanded(child: ElevatedButton.icon(icon: Icon(Icons.play_circle), label: Text("YouTube"), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: openYT)),
                  SizedBox(width:10),
                  Expanded(child: ElevatedButton.icon(icon: Icon(Icons.book_online), label: Text("BOOK NOW"), style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: ()=>bookTrip(places[i]["name"]!))),
                ]),
              )
            ]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>GeminiScreen())),
        label: Text("Ask Gemini AI"),
        icon: Icon(Icons.auto_awesome),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}

class GeminiScreen extends StatefulWidget {
  @override
  _GeminiScreenState createState() => _GeminiScreenState();
}
class _GeminiScreenState extends State<GeminiScreen> {
  final controller = TextEditingController();
  String answer = "Hi Sai! Nenu Gemini ni. Trip gurinchi emaina adugu!";
  bool loading = false;

  Future<void> askGemini() async {
    if(controller.text.isEmpty) return;
    setState(()=>loading=true);
    try{
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: 'YOUR_API_KEY_HERE');
      final response = await model.generateContent([Content.text(controller.text)]);
      setState(()=>answer = response.text?? "Error");
    }catch(e){
      setState(()=>answer = "API Key pettale SAI - aistudiopro.google.com lo free key teesuko - 'YOUR_API_KEY_HERE' place lo paste chey!");
    }
    setState(()=>loading=false);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Gemini AI - Trip Assistant"), backgroundColor: Colors.deepPurple),
      body: Padding(padding: EdgeInsets.all(16), child: Column(children: [
        TextField(controller: controller, decoration: InputDecoration(labelText: "Trip gurinchi adugu...", border: OutlineInputBorder(), suffixIcon: IconButton(icon: Icon(Icons.send), onPressed: askGemini))),
        SizedBox(height:20),
        loading? CircularProgressIndicator() : Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.purple[50], borderRadius: BorderRadius.circular(12)), child: Text(answer)),
        SizedBox(height:20),
        Text("Free Gemini API Key kosam: aistudiopro.google.com", style: TextStyle(color: Colors.grey, fontSize: 12))
      ])),
    );
  }
}
