// BE_SAFE 
// is an app I intended to design to help protect women, children 
// and elders, against street harassment.
// I dreamt that anyone could just say a pre-recorded sentence, 
// the app would detect it, and fetch help.
// 
// The idea is that we open the app ONCE, then record a "security phrase".
// We are then asked to insert the phone numers of a couple of close relatives 
// to build a "contact list" in case of need.
// After that, the app can be closed, and stays active in the background. 
// (permissions needed)
//
// The app then uses voice detection to listen to the persons call for help. 
// (like "hey SIRI")
// If detected, the security phrase will launch a program that will:
//  1. record immediately 10 seconds of audio,
//  2. fetch the localisation of the user,
//  3. Send both to the "contact list" mentionned above, 
//  asking to call them asap. 

// THIS IS WAY HARDER THE I EXPECTED, SINCE I HAVE ALMOST NO EXPERIENCE...
// I CAN'T EVEN MAKE THE RECORDER FUNCTION BE IMPLEMENTED PROPERLY.
// Yet, there's so many idea's that can be implemented 
// to improve this basic concept.

// I honestly think this is a PROJECT OF PUBLIC UTILITY, 
// that would benefit so many people.

// I have no idea how to make this thing work, 
// even in it's simplest form, but i would love to see it help many.
// I don't know if this is even possible, 
// but maybe WE CAN BUILD THIS AS A COMMUNITY?
// I'm willing to learn and work hard, I just don't know where to start.
// I've tried youtube ,chat gpt + (paid), and forums,
// but I'm getting nowhere after 48h+ of work.

// So, here I am, with a code full of errors, and still nothing more than a
// landing page implemented.
// Anyone care to join this crazy adventure?
// Any help is welcome: tips, ressources, help coding, templates,
// ...
// I don't even have enough disk space free to upload this on github.
// If you read this, it means i made it somehow.. <3

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Be Safe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Be Safe',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Your guardian angel, in case of street harassment.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 32.0), // Ajout d'un espace vertical
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const PageSuivante()));
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}

class PageSuivante extends StatefulWidget {
  const PageSuivante({super.key});

  @override
  _PageSuivanteState createState() => _PageSuivanteState();
}

class _PageSuivanteState extends State<PageSuivante> {
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;

  @override
  void initState() {
    super.initState();

    initRecorder();
  }  

  @override
  void dispose() {
      recorder.closeRecorder();

      super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();
    
    isRecorderReady = true;
    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500)
    );
  }

  Future record() async {
    if (!isRecorderReady) return;

    await recorder.startRecorder(toFile: 'audio');
  } 
          
  Future stop() async {
    if (isRecorderReady) return;

    final Path= await recorder.stopRecorder();
    final audioFile = File(Path!);

    print('Recorded audio: $audioFile');
  }

          setState(() {});
        },
 
  @override
  Widget build(BuildContext context) => Scaffold (
    backgroundColor: Colors.grey.shade900,
    body: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<RecordingDisposition>(
            stream: recorder.onProgress,
            builder: (context, snapshot) {
              final duration = snapshot.hasData
                  ? snapshot.data!.duration
                  : Duration.zero;
              return Text('${duration.inSeconds} s')
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
          child: Icon(
            recorder.isRecording ? Icons.stop : Icons.mic,
            size: 80,
          ),
          onPressed: () async {
            if (recorder.isRecording) {
              await stop();
            } else {
              await record();
            }
          
            setState(() {});
           },
          )
        ],
      )
        
      ),
    ),
  );
}
