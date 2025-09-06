import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_chantier/moa/bloc/study_comments/study_comments_bloc.dart';
import 'package:gestion_chantier/moa/bloc/study_comments/study_comments_event.dart'
    as comment_events;
import 'package:gestion_chantier/moa/bloc/study_comments/study_comments_state.dart'
    as comment_states;
import 'package:gestion_chantier/moa/bloc/home/home_bloc.dart';
import 'package:gestion_chantier/moa/bloc/home/home_state.dart';
import 'package:gestion_chantier/moa/models/Study.dart';
import 'package:gestion_chantier/moa/repository/study_comment_repository.dart';
import 'package:gestion_chantier/moa/widgets/study_comment_form.dart';
import 'package:gestion_chantier/moa/widgets/study_comments_list.dart';

/// Page de détails d'une étude BET
class EtudeDetailPage extends StatelessWidget {
  const EtudeDetailPage({super.key, required this.study});

  final Study study;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => StudyCommentsBloc(repository: StudyCommentRepository())
            ..add(
              comment_events.LoadStudyComments(
                studyRequestId: int.parse(study.id),
              ),
            ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2C3E50),
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            study.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StudyHeader(study: study),
              const SizedBox(height: 24),
              if (study.status == StudyStatus.rejected) ...[
                _RejectionSection(
                  reason: study.rejectionReason ?? 'Aucun motif spécifié',
                ),
              ] else ...[
                _ReportsSection(reports: study.reports),
              ],
              const SizedBox(height: 24),
              _CommentsSection(studyId: study.id),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudyHeader extends StatelessWidget {
  const _StudyHeader({required this.study});
  final Study study;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  study.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _StatusBadge(status: study.status),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            study.description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          // Ligne orange de séparation
          Container(
            height: 3,
            width: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFFF5A00),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 6),
              Text(
                'Créé: ${_formatDate(study.createdAt)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.person_outline,
                size: 16,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 6),
              Text(
                'Assigné: ${study.assignedTo}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RejectionSection extends StatelessWidget {
  const _RejectionSection({required this.reason});
  final String reason;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Motif du rejet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE9ECEF)),
            ),
            child: Text(
              reason,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF495057),
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportsSection extends StatelessWidget {
  const _ReportsSection({required this.reports});
  final List<Report> reports;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rapports produits(${reports.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          if (reports.isEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 48,
                    color: Color(0xFFCBD5E1),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Aucun rapport',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            ...reports.map(
              (report) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ReportCard(report: report),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.report});
  final Report report;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.picture_as_pdf,
              color: Color(0xFFDC2626),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        report.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    Text(
                      report.version,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Créé le ${_formatDateLong(report.createdAt)} • ${report.fileSize}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              // TODO: Download or view report
            },
            icon: const Icon(
              Icons.download_outlined,
              color: Color(0xFF64748B),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final StudyStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.badgeBg(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: status.badgeFg(context),
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

String _formatDate(DateTime d) {
  const months = [
    'janv.',
    'févr.',
    'mars',
    'avr.',
    'mai',
    'juin',
    'juil.',
    'août',
    'sept.',
    'oct.',
    'nov.',
    'déc.',
  ];
  final day = d.day.toString().padLeft(2, '0');
  final month = months[d.month - 1];
  final year = d.year;
  return '$day/$month/$year';
}

String _formatDateLong(DateTime d) {
  const months = [
    'janv.',
    'févr.',
    'mars',
    'avr.',
    'mai',
    'juin',
    'juil.',
    'août',
    'sept.',
    'oct.',
    'nov.',
    'déc.',
  ];
  final day = d.day.toString().padLeft(2, '0');
  final month = months[d.month - 1];
  final year = d.year;
  return '$day/$month/$year';
}

/// Section des commentaires
class _CommentsSection extends StatelessWidget {
  const _CommentsSection({required this.studyId});
  final String studyId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, homeState) {
        if (homeState.currentUser == null) {
          return const SizedBox.shrink();
        }

        final userId = homeState.currentUser!.id;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre avec compteur
              BlocBuilder<StudyCommentsBloc, comment_states.StudyCommentsState>(
                builder: (context, state) {
                  int commentCount = 0;
                  if (state is comment_states.StudyCommentsLoaded) {
                    commentCount = state.comments.length;
                  } else if (state is comment_states.StudyCommentAdded) {
                    commentCount = state.comments.length;
                  } else if (state is comment_states.StudyCommentAddError) {
                    commentCount = state.comments.length;
                  }

                  return Text(
                    'Commentaires($commentCount)',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C3E50),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Formulaire de commentaire
              StudyCommentForm(
                studyRequestId: int.parse(studyId),
                userId: userId,
              ),
              const SizedBox(height: 16),

              // Liste des commentaires
              StudyCommentsList(studyRequestId: int.parse(studyId)),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
