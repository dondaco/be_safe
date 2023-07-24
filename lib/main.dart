
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
