import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'voice_chat_service.dart';
import 'attractions.dart'; // Asegúrate de que este archivo exista

class VoiceChatWidget extends StatefulWidget {
  final String defaultVoice;
  const VoiceChatWidget({super.key, this.defaultVoice = 'verse'});

  @override
  State<VoiceChatWidget> createState() => _VoiceChatWidgetState();
}

class _VoiceChatWidgetState extends State<VoiceChatWidget> {
  final service = VoiceChatService();
  final player = AudioPlayer();

  // Mantenemos la variable para la lógica interna, aunque ya no haya selector visual
  String? selectedAttraction = kAttractions.first;
  String? userText;
  String? botText;
  bool recording = false;
  bool loading = false;

  final Color primaryColor = const Color(0xFF9D2449);
  final Color darkBackground = const Color(0xFF121212);
  final Color botBubbleColor = const Color(0xFF2C3E50).withOpacity(0.8);

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> _askMicPermission() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de micrófono denegado')),
      );
    }
  }

  Future<void> _startRecordingLogic() async {
    await _askMicPermission();
    if (await service.hasMicPermission()) {
      setState(() => recording = true);
      await service.startRecording();
    }
  }

  Future<void> _stopRecordingLogic() async {
    setState(() {
      recording = false;
      loading = true;
    });

    try {
      final text = await service.stopAndTranscribe();
      if (text == null || text.isEmpty) throw 'No se pudo transcribir.';
      setState(() => userText = text);

      final gateResp = await service.gate(text, attraction: selectedAttraction);
      final allowed = gateResp['allowed'] == true;
      final matched =
          (gateResp['matched'] as String?) ?? selectedAttraction ?? '';

      if (!allowed) {
        setState(
          () => botText =
              'Fuera de tema: ${gateResp['reason'] ?? 'sin razón'}. Tema: $matched',
        );
        setState(() => loading = false);
        return;
      }

      final answer = await service.chat(text, attraction: matched);
      setState(() => botText = answer);

      final bytes = await service.tts(answer, voice: widget.defaultVoice);
      final file = await service.saveBytesAsTempMp3(bytes);
      await player.play(DeviceFileSource(file.path));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Widget _buildChatBubble(String text, {required bool isUser}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? primaryColor.withOpacity(0.9) : botBubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isUser ? const Radius.circular(20) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 1. HEADER LIMPIO (Solo botón atrás) ---
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  // Al quitar el selector, alineamos el botón atrás a la izquierda
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white70,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    // Aquí estaba el dropdown, eliminado.
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // --- 2. ZONA DEL BANNER Y MICRÓFONO ---
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                // Fondo y Ajolote
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/Fondo.png'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Image.asset(
                        'assets/images/ajolotito.png',
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                // Botón Micrófono
                Positioned(bottom: -40, child: _buildMicButton()),
              ],
            ),

            const SizedBox(height: 60),

            // --- 3. CHAT ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  if (loading)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(color: Colors.white),
                    ),

                  if (userText == null && botText == null && !loading)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Hola, soy tu asistente inteligente.\nMantén presionado el micrófono para preguntar.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),

                  if (userText != null)
                    _buildChatBubble(userText!, isUser: true),
                  if (botText != null && !loading)
                    _buildChatBubble(botText!, isUser: false),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onTapDown: (_) => _startRecordingLogic(),
      onTapUp: (_) => _stopRecordingLogic(),
      onTapCancel: () => _stopRecordingLogic(),
      child: AvatarGlow(
        animate: recording,
        glowColor: primaryColor,
        duration: const Duration(milliseconds: 2000),
        repeat: true,
        glowRadiusFactor: 0.6,
        child: Material(
          elevation: 15.0,
          shape: const CircleBorder(),
          color: Colors.transparent,
          child: CircleAvatar(
            backgroundColor: recording ? primaryColor : const Color(0xFF2C3E50),
            radius: 40.0,
            child: Icon(
              recording ? Icons.mic : Icons.mic_none_outlined,
              size: 35,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
