import 'package:flutter/material.dart';

import 'package:agrovet/utils/app_theme.dart';
import 'package:agrovet/services/auth_service.dart';
import 'package:agrovet/services/firestore_service.dart';
import 'package:agrovet/screens/conversation_screen.dart';

class ChatScreen extends StatefulWidget {
  final String userId;

  const ChatScreen({required this.userId, super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final FirestoreService _firestoreService;

  @override
  void initState() {
    super.initState();
    _firestoreService = FirestoreService();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _firestoreService.getAllVeterinarians(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text(
                  'Error al cargar veterinarios',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final veterinarians = snapshot.data ?? [];

        if (veterinarians.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_hospital_outlined,
                    size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text(
                  'No hay veterinarios registrados',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: veterinarians.length,
          itemBuilder: (context, index) {
            final vetData = veterinarians[index];
            return _buildVeterinarianCard(context, vetData);
          },
        );
      },
    );
  }

  Widget _buildVeterinarianCard(
      BuildContext context, Map<String, dynamic> vetData) {
    final vetId = (vetData['uid'] ?? '').toString();
    final vetName = (vetData['nombreCompleto'] ?? '').toString();
    final especialidad = (vetData['especialidad'] ?? '').toString();

    final chatId = _firestoreService.getChatId(widget.userId, vetId);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          debugPrint(
            'CHAT_ID=$chatId sender=${widget.userId} vet=$vetId',
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ConversationScreen(
                chatId: chatId,
                otherUserId: vetId,
                otherUserName: vetName.isEmpty ? 'Veterinario' : vetName,
                currentUserId: widget.userId,
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: const Icon(
                  Icons.person,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vetName.isEmpty ? 'Veterinario' : vetName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      especialidad.isEmpty
                          ? 'Disponible para consultas'
                          : especialidad,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
