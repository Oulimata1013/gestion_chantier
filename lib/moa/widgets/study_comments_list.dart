import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_chantier/moa/bloc/study_comments/study_comments_bloc.dart';
import 'package:gestion_chantier/moa/bloc/study_comments/study_comments_event.dart';
import 'package:gestion_chantier/moa/bloc/study_comments/study_comments_state.dart';
import 'package:gestion_chantier/moa/models/study_comment.dart';
import 'package:gestion_chantier/moa/utils/HexColor.dart';
import 'package:intl/intl.dart';

/// Widget pour afficher la liste des commentaires d'une étude
class StudyCommentsList extends StatelessWidget {
  final int studyRequestId;

  const StudyCommentsList({super.key, required this.studyRequestId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudyCommentsBloc, StudyCommentsState>(
      builder: (context, state) {
        if (state is StudyCommentsLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is StudyCommentsError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur lors du chargement des commentaires',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<StudyCommentsBloc>().add(
                        LoadStudyComments(studyRequestId: studyRequestId),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor('#1A365D'),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is StudyCommentsLoaded ||
            state is StudyCommentAdded ||
            state is StudyCommentAddError) {
          List<StudyComment> comments = [];
          if (state is StudyCommentsLoaded) {
            comments = state.comments;
          } else if (state is StudyCommentAdded) {
            comments = state.comments;
          } else if (state is StudyCommentAddError) {
            comments = state.comments;
          }

          if (comments.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun commentaire pour le moment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Soyez le premier à commenter cette étude',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return _CommentCard(comment: comment);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

/// Widget pour afficher une carte de commentaire
class _CommentCard extends StatelessWidget {
  final StudyComment comment;

  const _CommentCard({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête du commentaire
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 16,
                backgroundColor: HexColor('#1A365D'),
                child: Text(
                  comment.authorName.isNotEmpty
                      ? comment.authorName[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Nom et date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.authorName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: HexColor('#1A365D'),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(comment.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Contenu du commentaire
          Text(
            comment.content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'À l\'instant';
        } else {
          return 'Il y a ${difference.inMinutes} min';
        }
      } else {
        return 'Il y a ${difference.inHours}h';
      }
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else {
      return DateFormat('dd/MM/yyyy à HH:mm').format(date);
    }
  }
}
