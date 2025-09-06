import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_chantier/moa/bloc/study_comments/study_comments_bloc.dart';
import 'package:gestion_chantier/moa/bloc/study_comments/study_comments_event.dart';
import 'package:gestion_chantier/moa/bloc/study_comments/study_comments_state.dart';
import 'package:gestion_chantier/moa/utils/HexColor.dart';

/// Widget de formulaire pour ajouter un commentaire à une étude
class StudyCommentForm extends StatefulWidget {
  final int studyRequestId;
  final int userId;

  const StudyCommentForm({
    super.key,
    required this.studyRequestId,
    required this.userId,
  });

  @override
  State<StudyCommentForm> createState() => _StudyCommentFormState();
}

class _StudyCommentFormState extends State<StudyCommentForm> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _submitComment() {
    final content = _commentController.text.trim();

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir un commentaire'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (content.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le commentaire doit contenir au moins 3 caractères'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Envoyer le commentaire
    context.read<StudyCommentsBloc>().add(
      AddStudyComment(
        studyRequestId: widget.studyRequestId,
        userId: widget.userId,
        content: content,
      ),
    );

    // Vider le champ et perdre le focus
    _commentController.clear();
    _commentFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudyCommentsBloc, StudyCommentsState>(
      listener: (context, state) {
        if (state is StudyCommentAdded) {
          setState(() {
            _isSubmitting = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Commentaire ajouté avec succès'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is StudyCommentAddError) {
          setState(() {
            _isSubmitting = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is StudyCommentAdding) {
          setState(() {
            _isSubmitting = true;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            Text(
              'Ajouter un commentaire',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: HexColor('#1A365D'),
              ),
            ),
            const SizedBox(height: 16),

            // Champ de texte
            TextField(
              controller: _commentController,
              focusNode: _commentFocusNode,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Saisissez votre commentaire...',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: HexColor('#1A365D'), width: 2),
                ),
                contentPadding: const EdgeInsets.all(12),
                counterText: '${_commentController.text.length}/500',
              ),
              onChanged: (value) {
                setState(() {}); // Pour mettre à jour le compteur
              },
            ),
            const SizedBox(height: 16),

            // Bouton d'envoi
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Bouton Annuler
                TextButton(
                  onPressed:
                      _isSubmitting
                          ? null
                          : () {
                            _commentController.clear();
                            _commentFocusNode.unfocus();
                          },
                  child: Text(
                    'Annuler',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Bouton Envoyer
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitComment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor('#1A365D'),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child:
                      _isSubmitting
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Text(
                            'Envoyer',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
