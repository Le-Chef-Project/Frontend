import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class MeetingPage extends StatefulWidget {
  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final _localRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  bool _isCameraOn = false;
  bool _isMicOn = false;

  @override
  void initState() {
    super.initState();
    _initRenderers();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _localStream?.dispose();
    super.dispose();
  }

  void _initRenderers() async {
    await _localRenderer.initialize();
  }

  Future<bool> _handleCameraAndMicPermission() async {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();

    bool cameraGranted = await Permission.camera.isGranted;
    bool micGranted = await Permission.microphone.isGranted;

    if (!cameraGranted || !micGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Camera and microphone permissions are required for video calling.'),
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> _getUserMedia() async {
    bool permissionGranted = await _handleCameraAndMicPermission();
    if (!permissionGranted) {
      return;
    }

    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': _isCameraOn ? {'facingMode': 'user'} : false,
    };

    try {
      var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      setState(() {
        _localStream = stream;
        _localRenderer.srcObject = _localStream;
      });
    } catch (e) {
      print('Error getting user media: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Failed to access camera and microphone. Please check your device settings.'),
        ),
      );
    }
  }

  Future<void> _toggleCamera() async {
    setState(() {
      _isCameraOn = !_isCameraOn;
    });

    if (_isCameraOn) {
      await _getUserMedia();
    } else {
      _localStream?.getVideoTracks().forEach((track) {
        track.stop();
      });
      _localStream?.removeTrack(_localStream!.getVideoTracks()[0]);
      setState(() {
        _localRenderer.srcObject = null;
      });
    }
  }

  void _toggleMic() {
    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = !track.enabled;
    });
    setState(() {
      _isMicOn = !_isMicOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: OrientationBuilder(
          builder: (context, orientation) {
            return Column(
              children: [
                Expanded(
                  child: _isCameraOn && _localRenderer.srcObject != null
                      ? Container(
                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: RTCVideoView(_localRenderer, mirror: true),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 15),
                          itemCount: 8,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0xFFD9D9D9).withOpacity(0.1),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundImage: Image.asset(
                                      'assets/bccb46bd-67fe-47c7-8e5e-3dd39329d638.webp',
                                    ).image,
                                  ),
                                  Text('Thaowpsta Saiid')
                                ],
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Color(0xFFEA5B5B)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 7, vertical: 12))
                        ),
                        onPressed: () {
                          dispose();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.call_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Leave Call',
                              style: GoogleFonts.ibmPlexMono(textStyle: TextStyle(color: Colors.white, fontSize: 14,),)

                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ButtonStyle(
                          elevation: WidgetStateProperty.all(0),
                          backgroundColor:
                              WidgetStateProperty.all(Color(0xFFFBFAFA)),
                          shape: WidgetStateProperty.all(
                            CircleBorder(),
                          ),
                        ),
                        onPressed: () async {
                          await _toggleCamera();
                        },
                        child: Icon(
                          _isCameraOn ? Icons.videocam : Icons.videocam_off_outlined,
                          size: 30,
                          color: Color(0xFF164863),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          elevation: WidgetStateProperty.all(0),
                          backgroundColor:
                              WidgetStateProperty.all(Color(0xFFFBFAFA)),
                          shape: WidgetStateProperty.all(
                            CircleBorder(),
                          ),
                        ),
                        onPressed: _toggleMic,
                        child: Icon(
                          _isMicOn ? Icons.mic : Icons.mic_off_outlined,
                          size: 30,
                          color: Color(0xFF164863),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
