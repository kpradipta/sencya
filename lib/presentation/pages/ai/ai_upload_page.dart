import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors.dart';
import '../../bloc/ai/ai_bloc.dart';
import '../../bloc/ai/ai_event.dart';
import '../../bloc/ai/ai_state.dart';

class AIUploadPage extends StatefulWidget {
  const AIUploadPage({super.key});

  @override
  State<AIUploadPage> createState() => _AIUploadPageState();
}

class _AIUploadPageState extends State<AIUploadPage> {
  File? _image;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI PHOTO ANALYZER'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: BlocListener<AIBloc, AIState>(
        listener: (context, state) {
          if (state is AIAnalysisLoaded) {
            context.pushReplacement(
              '/ai-results',
              extra: {'analysis': state.analysis},
            );
          } else if (state is AIError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: TextStyle(color: AppColors.background),
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Upload a photo to get started.',
                style: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 16),
              Text(
                'Our AI will analyze your face shape and recommend the best hairstyles for you.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),
              Expanded(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.borderStroke,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: _image == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                size: 64,
                                color: AppColors.elegantGold.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Tap to select photo',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.file(_image!, fit: BoxFit.cover),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              BlocBuilder<AIBloc, AIState>(
                builder: (context, state) {
                  if (state is AILoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.elegantGold,
                      ),
                    );
                  }
                  return ElevatedButton(
                    onPressed: _image == null
                        ? null
                        : () {
                            context.read<AIBloc>().add(
                              AnalyzePhotoRequested(_image!),
                            );
                          },
                    child: const Text('ANALYZE PHOTO'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
