import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'voice_chat_service.dart';
import 'attractions.dart';

class VoiceChatWidget extends StatefulWidget {
  final String defaultVoice;
  const VoiceChatWidget({super.key, this.defaultVoice = 'verse'});

  @override
  State<VoiceChatWidget> createState() => _VoiceChatWidgetState();
}

class _VoiceChatWidgetState extends State<VoiceChatWidget> {
  final service = VoiceChatService();
  final player = AudioPlayer();

  String? selectedAttraction = kAttractions.first;
  String? userText;
  String? botText;
  bool recording = false;
  bool loading = false;

  Future<void> _askMicPermission() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de micrófono denegado')),
      );
    }
  }

  Future<void> _onHoldStart() async {
    await _askMicPermission();
    if (await service.hasMicPermission()) {
      setState(() => recording = true);
      await service.startRecording();
    }
  }

  Future<void> _onHoldEnd() async {
    setState(() {
      recording = false;
      loading = true;
      userText = null;
      botText = null;
    });

    try {
      // 1) STT
      final text = await service.stopAndTranscribe();
      if (text == null || text.isEmpty) throw 'No se pudo transcribir.';
      setState(() => userText = text);

      // 2) Gate (manda selección del dropdown; el backend puede resolver o detectar)
      final gateResp = await service.gate(text, attraction: selectedAttraction);
      final allowed = gateResp['allowed'] == true;
      final matched =
          (gateResp['matched'] as String?) ?? selectedAttraction ?? '';

      if (!allowed) {
        setState(
          () => botText =
              'Fuera de tema: ${gateResp['reason'] ?? 'sin razón'}. Tema: $matched',
        );
        return;
      }

      // 3) Chat (acota al matched del gate)
      final answer = await service.chat(text, attraction: matched);
      setState(() => botText = answer);

      // 4) TTS
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

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = recording ? Colors.redAccent : Colors.blueGrey.shade800;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // selector del atractivo
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Atractivo:  '),
            DropdownButton<String>(
              value: selectedAttraction,
              items: kAttractions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: loading
                  ? null
                  : (v) => setState(() => selectedAttraction = v),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (userText != null || botText != null)
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (userText != null) ...[
                    const Text(
                      'Tú:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(userText!),
                    const SizedBox(height: 8),
                  ],
                  if (botText != null) ...[
                    const Text(
                      'Asistente:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(botText!),
                  ],
                ],
              ),
            ),
          ),

        GestureDetector(
          onLongPressStart: (_) => _onHoldStart(),
          onLongPressEnd: (_) => _onHoldEnd(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: loading ? Colors.grey : color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.4), blurRadius: 14),
              ],
            ),
            child: Icon(
              recording ? Icons.mic : Icons.mic_none,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          recording
              ? 'Grabando… suelta para enviar'
              : (loading ? 'Procesando…' : 'Mantén presionado para hablar'),
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }
}
