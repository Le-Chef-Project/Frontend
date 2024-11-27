import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';
import 'end_meeting.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({super.key});

  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final _localRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  bool _isCameraOn = false;
  bool _isMicOn = false;
  bool _isFrontCamera = true;
  final String? role = sharedPreferences!.getString('role');

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
        const SnackBar(
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
      'video': _isCameraOn
          ? {
              'facingMode': _isFrontCamera ? 'user' : 'environment',
            }
          : false,
    };

    try {
      // Stop existing tracks if any
      _localStream?.getTracks().forEach((track) => track.stop());

      var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      setState(() {
        _localStream = stream;
        _localRenderer.srcObject = _localStream;
      });
    } catch (e) {
      print('Error getting user media: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Failed to access camera and microphone. Please check your device settings.'),
        ),
      );
    }
  }

  Future<void> _switchCamera() async {
    if (!_isCameraOn) return;

    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });
    await _getUserMedia();
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

  Widget _buildParticipantTile(BuildContext context, int index) {
    if (index == 0 && _isCameraOn && _localRenderer.srcObject != null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: RTCVideoView(_localRenderer, mirror: _isFrontCamera),
            ),
            if (_isCameraOn)
              Positioned(
                bottom: 0,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 16,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.flip_camera_ios, size: 20),
                    color: const Color(0xFF164863),
                    onPressed: _switchCamera,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: Image.network(
                    'https://t4.ftcdn.net/jpg/02/15/84/43/360_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg',
                  ).image,
                ),
                const SizedBox(height: 21),
                Text(
                  'Thaowpsta Saiid',
                  style: GoogleFonts.ibmPlexMono(
                    color: const Color(0xFF083344),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: 10,
            child: _isMicOn
                ? const Icon(Icons.mic, color: Color(0xFF164863))
                : const Icon(
                    Icons.mic_off,
                    color: Color(0xFF164863),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantThumbnail(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 120, // Fixed width for thumbnails
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30, // Smaller radius for thumbnails
                  backgroundImage: Image.network(
                          'https://t4.ftcdn.net/jpg/02/15/84/43/360_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg')
                      .image,
                ),
                const SizedBox(height: 8),
                Text(
                  'Participant $index',
                  style: GoogleFonts.ibmPlexMono(
                    color: const Color(0xFF083344),
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: Icon(
              _isMicOn ? Icons.mic : Icons.mic_off,
              color: const Color(0xFF164863),
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminLayout() {
    return Column(
      children: [
        // Main video container (takes most of the screen)
        Expanded(
          flex: 4,
          child: Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: _isCameraOn && _localRenderer.srcObject != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        RTCVideoView(_localRenderer, mirror: _isFrontCamera),
                        if (_isCameraOn)
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.7),
                              radius: 20,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.flip_camera_ios),
                                color: const Color(0xFF164863),
                                onPressed: _switchCamera,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : const Center(
                    child: Text('Camera is off'),
                  ),
          ),
        ),
        // Horizontal list of participants
        Container(
          height: 150, // Fixed height for participant list
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7, // Number of other participants
            itemBuilder: _buildParticipantThumbnail,
            padding: const EdgeInsets.symmetric(horizontal: 15),
          ),
        ),
        // Controls
        _buildControls(),
      ],
    );
  }

  Widget _buildRegularLayout() {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 0,
              crossAxisSpacing: 10,
            ),
            itemCount: 8,
            itemBuilder: _buildParticipantTile,
          ),
        ),
        _buildControls(),
      ],
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Row(
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(const Color(0xFFEA5B5B)),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 7, vertical: 12),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EndMeeting()),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.call_outlined, color: Colors.white),
                const SizedBox(width: 5),
                Text(
                  'Leave Call',
                  style: GoogleFonts.ibmPlexMono(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),
              backgroundColor: WidgetStateProperty.all(const Color(0xFFFBFAFA)),
              shape: WidgetStateProperty.all(const CircleBorder()),
            ),
            onPressed: _toggleCamera,
            child: Icon(
              _isCameraOn ? Icons.videocam : Icons.videocam_off_outlined,
              size: 30,
              color: const Color(0xFF164863),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),
              backgroundColor: WidgetStateProperty.all(const Color(0xFFFBFAFA)),
              shape: WidgetStateProperty.all(const CircleBorder()),
            ),
            onPressed: _toggleMic,
            child: Icon(
              _isMicOn ? Icons.mic : Icons.mic_off,
              size: 30,
              color: const Color(0xFF164863),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF3D3D3D),
        body: role == 'admin' && _isCameraOn
            ? _buildAdminLayout()
            : _buildRegularLayout(),
      ),
    );
  }
}
