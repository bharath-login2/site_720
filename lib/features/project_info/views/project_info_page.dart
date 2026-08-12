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
                            _buildTile("Project Type", project.projectType),
                            _buildTile(
                                "Project Category", project.categoryName),
                            _buildTile(
                              "Location Area",
                              project.location.isNotEmpty
                                  ? project.location
                                  : "-",
                            ),

// Clickable location that opens Google Maps using latitude & longitude
                            _buildLocationTile(
                              "Location",
                              project.locationArea.isNotEmpty
                                  ? project.locationArea
                                  : "-",
                              project.latitude,
                              project.longtitude,
                            ),
                            _buildTile("Starting Date", project.startingDate),
                            _buildTile(
                                "Completion Date", project.completionDate),
                            _buildTile("Packages", project.packageName),
                            _buildTile("BHK", project.bhkNo),
                            _buildTile("LPO No", project.lpoNo),
                            _buildTile(
                                "Quotation/Work Order No", project.orderNo),
                            _buildTile("CCTV Address", project.cctvId),
                            _buildTile("Project Details", project.packageId),
                            _buildTile(
                              "Priority",
                              project.priorityId == "1"
                                  ? "High"
                                  : project.priorityId == "2"
                                      ? "Medium"
                                      : project.priorityId == "3"
                                          ? "Low"
                                          : "-",
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildCard(
                          title: "Square Feet Details",
                          children: [
                            Builder(
                              builder: (context) {
                                final sqftList = state.response.data.squareFeet;

                                double totalSqft = 0;
                                double totalAmount = 0;

                                for (var item in sqftList) {
                                  totalSqft +=
                                      double.tryParse(item.sqftVal) ?? 0;
                                  totalAmount +=
                                      double.tryParse(item.sqftTotal) ?? 0;
                                }

                                final average =
                                    totalSqft > 0 ? totalAmount / totalSqft : 0;

                                return Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      Table(
                                        border: TableBorder.all(
                                            color: Colors.grey.shade300),
                                        columnWidths: const {
                                          0: FlexColumnWidth(2.5),
                                          1: FlexColumnWidth(1.2),
                                          2: FlexColumnWidth(1.2),
                                          3: FlexColumnWidth(1.5),
                                        },
                                        children: [
                                          const TableRow(
                                            decoration: BoxDecoration(
                                              color: Color(0xfff3f3f3),
                                            ),
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  "Work",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  "Sq.ft",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  "Rate",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  "Total",
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          ...sqftList.map(
                                            (e) => TableRow(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Text(e.sqftName),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Text(
                                                    e.sqftVal,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Text(
                                                    e.sqftRate,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Text(
                                                    e.sqftTotal,
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _summaryCard(
                                                  "Total Sq.ft",
                                                  totalSqft.toStringAsFixed(2),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: _summaryCard(
                                                  "Average",
                                                  average.toStringAsFixed(2),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            width: double.infinity,
                                            child: _summaryCard(
                                              "Total Amount",
                                              totalAmount.toStringAsFixed(2),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildCard(
                          title: "Description",
                          children: [
                            _buildTile("Project Description",
                                project.projectDescription),
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
                          title: "Client Details",
                          children: [
                            _buildTile("Client Name", project.clientName),
                            _buildTile("Contact Number", project.phoneNumber),
                            _buildTile(
                                "Whatsapp Number", project.whatsappNumber),
                            _buildTile("Email", project.emailId),
                            _buildTile("civil Id", project.civilId),
                            _buildTile("Address", project.address),
                          ],
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

  Widget _summaryCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            value.isEmpty ? "-" : value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTile(
    String title,
    String value,
    String latitude,
    String longitude,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        if (latitude.isEmpty || longitude.isEmpty) return;

        final uri = Uri.parse(
          "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude",
        );

        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                size: 19,
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value.isEmpty ? "-" : value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                      decoration: TextDecoration.underline,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.open_in_new_rounded,
              size: 18,
              color: Colors.grey.shade500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(ProjectDetails project) {
    return Container(
      height: 190,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              color: Colors.white70,
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              project.clientName,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
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
                      ],
                    ),
                  ),
                  //STATUS
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
                  ),
                ],
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
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 2,
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Divider(
              height: 1,
              color: Colors.grey.shade200,
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
    String title,
    String value, {
    IconData icon = Icons.info_outline_rounded,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value.isEmpty ? "-" : value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
