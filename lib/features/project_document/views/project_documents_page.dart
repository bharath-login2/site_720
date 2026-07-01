import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:site_720/features/project_document/cubit/project_documents_cubit.dart';
import 'package:site_720/features/project_document/cubit/project_documents_state.dart';
import 'package:site_720/core/widgets/appbar.dart';

class ProjectDocumentsPage extends StatelessWidget {
  final String projectId;

  const ProjectDocumentsPage({
    Key? key,
    required this.projectId,
  }) : super(key: key);

  Future<void> _openDocument(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectDocumentsCubit(projectId),
      child: Scaffold(
        appBar: simpleAppbar(context, "Project Documents", true),
        body: BlocBuilder<ProjectDocumentsCubit, ProjectDocumentsState>(
          builder: (context, state) {
            if (state is ProjectDocumentsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ProjectDocumentsFailure) {
              return Center(
                child: Text(state.error),
              );
            }

            if (state is ProjectDocumentsSuccess) {
              if (state.documents.isEmpty) {
                return const Center(
                  child: Text("No Documents Found"),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.documents.length,
                itemBuilder: (context, index) {
                  final doc = state.documents[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _openDocument(doc.mediaUrl),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                doc.mediaUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey.shade300,
                                    child: const Icon(
                                      Icons.insert_drive_file,
                                      size: 35,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doc.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    doc.remark.isEmpty
                                        ? "No Remark"
                                        : doc.remark,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Tap to View",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
