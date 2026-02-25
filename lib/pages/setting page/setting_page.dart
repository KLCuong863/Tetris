import 'package:flutter/material.dart';
import '../../manager/audio_manager.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final audio = AudioManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.boardBackground,
        title: const Text("SETTINGS"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            const SizedBox(height: 40),

            Text(
              "VOLUME",
              style: AppFonts.pixeloidSemiBold20
                  .copyWith(color: AppColors.textPrimary),
            ),

            Slider(
              value: audio.volume,
              min: 0,
              max: 1,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  audio.setVolume(value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}