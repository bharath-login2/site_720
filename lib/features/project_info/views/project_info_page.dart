import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/appbar.dart';
import '../cubit/project_info_cubit.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/project_info/project_info_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectInfoPage extends StatefulWidget {
  const ProjectInfoPage({super.key});

  @override
  State<ProjectInfoPage> createState() => _ProjectInfoPageState();
}

class _ProjectInfoPageState extends State<ProjectInfoPage> {
  late String projectId;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_loaded) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      projectId = args["id"].toString();

      context.read<ProjectInfoCubit>().getProjectInfo(projectId);

      _loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProjectInfoCubit, ProjectInfoState>(
        builder: (context, state) {
          if (state is ProjectInfoLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ProjectInfoFailure) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is ProjectInfoSuccess) {
            final project = state.response.data.projectDetails;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProjectInfoCubit>().refresh(projectId);
              },
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _header(project),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildCard(
                          title: "Project Details",
                          children: [
                            _buildTile("Project Name", project.projectName),
                            _buildTile("Client Name", project.clientName),
                            _buildTile("Phone", project.phoneNumber),
                            _buildTile("Whatsapp", project.whatsappNumber),
                            _buildTile("Email", project.emailId),
                            _buildTile("Address", project.address),
                            _buildTile("Status", project.workStatus),
                            _buildTile("Project Type", project.projectType),
                            _buildTile("Package", project.packageName),
                            _buildTile("Category", project.categoryName),
                            _buildTile("BHK", project.bhkNo),
                            _buildTile(
                              "Estimate Amount",
                              project.totalEstimateAmount,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildCard(
                          title: "Plan Files",
                          children: state.response.data.planImages.isEmpty
                              ? [
                                  const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Center(
                                      child: Text("No Plan Files"),
                                    ),
                                  )
                                ]
                              : state.response.data.planImages.map((e) {
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.red,
                                        size: 32,
                                      ),
                                      title: Text(
                                        e.fileName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: const Text("Tap to open"),
                                      trailing: const Icon(Icons.open_in_new),
                                      onTap: () async {
                                        final uri = Uri.parse(e.mediaUrl);

                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(
                                            uri,
                                            mode:
                                                LaunchMode.externalApplication,
                                          );
                                        }
                                      },
                                    ),
                                  );
                                }).toList(),
                        ),
                        const SizedBox(height: 15),
                        _buildCard(
                          title: "Elevation Images",
                          children: [
                            if (state.response.data.elevationImages.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(12),
                                child: Text("No Images"),
                              )
                            else
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    state.response.data.elevationImages.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (context, index) {
                                  final image = state
                                      .response.data.elevationImages[index];

                                  return InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        barrierColor: Colors.black87,
                                        builder: (context) {
                                          return Dialog(
                                            backgroundColor: Colors.transparent,
                                            insetPadding:
                                                const EdgeInsets.all(16),
                                            child: Stack(
                                              children: [
                                                InteractiveViewer(
                                                  minScale: 1,
                                                  maxScale: 5,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: Image.network(
                                                      image.mediaUrl,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 10,
                                                  right: 10,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.black54,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        image.mediaUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildCard(
                          title: "Square Feet Details",
                          children: state.response.data.squareFeet.map((e) {
                            return Column(
                              children: [
                                _buildTile("Work", e.sqftName),
                                _buildTile("Sq.ft", e.sqftVal),
                                _buildTile("Rate", e.sqftRate),
                                _buildTile("Total", e.sqftTotal),
                                const Divider(),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _header(ProjectDetails project) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        image: DecorationImage(
          image: AssetImage("assets/images/appbar.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      project.projectName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    color: Colors.white70,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      project.clientName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.phone_outlined,
                    color: Colors.white70,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    project.phoneNumber,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  project.workStatus.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String title, String value) {
    return ListTile(
      dense: true,
      title: Text(title),
      subtitle: Text(
        value.isEmpty ? "-" : value,
      ),
    );
  }
}
