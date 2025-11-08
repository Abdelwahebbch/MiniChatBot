import 'package:flutter/material.dart';
import 'package:mini_chatbot/services/api_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _ctrl = TextEditingController();
  final List<Map<String, String>> messages = [];
  bool isload = false;
  Future<void> sendMessage() async {
    final msg = _ctrl.text;
    if (msg.isEmpty) {
      return;
    }
    setState(() {
      messages.add({"role": "user", "text": msg});
      isload = true;
    });

    _ctrl.clear();

    final response = await ApiConnection.getResponse(msg);

    setState(() {
      messages.add({"role": "gemini", "text": response});
      isload = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tunisian Chat GPT")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, pos) {
                final msg = messages[pos];
                final isUser = msg["role"] == "user";

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 5, bottom: 12),
                    padding: EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[300],
                    ),
                    child: Text(
                      msg["text"]!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (isload) Center(child: CircularProgressIndicator()),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _ctrl,
                    decoration: InputDecoration(
                      hintText: "Saisie votre message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide(color: Colors.blue, width: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(onPressed: sendMessage, icon: Icon(Icons.send)),
            ],
          ),
        ],
      ),
    );
  }
}
