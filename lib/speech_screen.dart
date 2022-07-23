import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String,HighlightedWord>_highlights={
    'flutter':HighlightedWord(
      onTap: ()=>print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      )
    ),
    'voice':HighlightedWord(
      onTap: ()=>print('voice'),
      textStyle: TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold
      )
    ),
    'subscribe':HighlightedWord(
        onTap: ()=>print('subscribe'),
        textStyle: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold
        )
    ),

  };
  late stt.SpeechToText _speech;
// var _speech= stts.SpeechToText;
 // stt.SpeechToText _speech= stt.SpeechToText();
  bool _isListening =false;
  String _text = 'Press the button and start voice';
  double _confidence = 1.0;

  void _listen()async{
    if(!_isListening){
      bool available = await _speech.initialize(
        onStatus: (val)=>print('onStatus: $val'),
      onError: (val)=>print('onError: $val'),
      );
      if(available){
        setState(() {
          _isListening=true;
        });
        _speech.listen(
          onResult: (val)=>setState(() {
            _text=val.recognizedWords;
            if(val.hasConfidenceRating && val.confidence>0){
              _confidence=val.confidence;
            }
          }),
        );
      }
    }
    else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speech=stt.SpeechToText();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
title: Text("Confidence: ${(_confidence*100.0).toStringAsFixed(1)}%"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 150),
          child: TextHighlight(
            text: _text,
            words: _highlights,
            textStyle: TextStyle(
              fontSize: 20,color: Colors.black,fontWeight: FontWeight.w400
            ),
          ),
        ),
      ),
      floatingActionButton: AvatarGlow(
        animate:_isListening,
        glowColor: Colors.red,
        endRadius: 75,
        duration: Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening?Icons.mic:Icons.mic_off),
        ),
      ),
    );
  }
}


