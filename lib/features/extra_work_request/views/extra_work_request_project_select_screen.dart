import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:site_720/core/constants/colors.dart';
import '../../../data/models/projectListRequest/projectListRequestModel.dart';
import '../cubit/extra_work_request_cubit.dart';
import '../cubit/extra_work_request_state.dart';
import 'extra_work_request_screen.dart';

class ExtraWorkRequestProjectSelectScreen extends StatefulWidget {
  const ExtraWorkRequestProjectSelectScreen({
    super.key,
  });

  @override
  State<ExtraWorkRequestProjectSelectScreen> createState() =>
      _ExtraWorkRequestProjectSelectScreenState();
}

class _ExtraWorkRequestProjectSelectScreenState
    extends State<ExtraWorkRequestProjectSelectScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  List<WorkRequestProject> _allProjects = [];
  List<WorkRequestProject> _filteredProjects = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_onSearchChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProjects();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // GET WORK REQUEST PROJECTS
  // ============================================================

  Future<void> _fetchProjects() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cubit = context.read<ExtraWorkRequestCubit>();

      await cubit.getProjectList();

      if (!mounted) return;

      setState(() {
        _allProjects = List<WorkRequestProject>.from(
          cubit.projectList,
        );

        _filteredProjects = List<WorkRequestProject>.from(
          cubit.projectList,
        );

        _isLoading = false;
      });

      print(
        "EXTRA WORK PROJECT COUNT: ${_allProjects.length}",
      );

      for (final project in _allProjects) {
        print(
          "PROJECT ID: ${project.id} | "
          "CLIENT ID: ${project.clientId} | "
          "NAME: ${project.projectName}",
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage =
            e.toString().replaceAll("Exception: ", "");
        _isLoading = false;
      });
    }
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void _onSearchChanged() {
    final query =
        _searchController.text.toLowerCase().trim();

    if (!mounted) return;

    setState(() {
      if (query.isEmpty) {
        _filteredProjects =
            List<WorkRequestProject>.from(_allProjects);
        return;
      }

      _filteredProjects = _allProjects.where((project) {
        final nameMatches =
            project.projectName.toLowerCase().contains(query);

        final idMatches =
            project.id.toLowerCase().contains(query);

        final clientIdMatches =
            project.clientId.toLowerCase().contains(query);

        return nameMatches ||
            idMatches ||
            clientIdMatches;
      }).toList();
    });
  }

  // ============================================================
  // PROJECT SELECT
  // ============================================================

  void _onProjectSelected(
    WorkRequestProject selectedProject,
  ) {
    // NEW API:
    // id = actual project ID
    final projectId = selectedProject.id;

    print(
      "========== EXTRA WORK PROJECT SELECTED ==========",
    );
    print(
      "PROJECT NAME : ${selectedProject.projectName}",
    );
    print(
      "PROJECT ID   : ${selectedProject.id}",
    );
    print(
      "CLIENT ID    : ${selectedProject.clientId}",
    );
    print(
      "SENDING ID   : $projectId",
    );
    print(
      "=================================================",
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ExtraWorkRequestCubit(),
          child: ExtraWorkRequestScreen(
            projectId: projectId,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.2,
        ),
        child: Container(
          height:
              MediaQuery.of(context).size.height * .15,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/appbar.png",
              ),
              fit: BoxFit.fill,
            ),
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 35,
              right: 20,
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Select Project",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontFamily: "Lobster",
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: Column(
        children: [
          // ----------------------------------------------------
          // SEARCH
          // ----------------------------------------------------

          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              10,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset:
                        const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText:
                      "Search by project name or ID...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color:
                        AppColors.primaryColor,
                  ),
                  suffixIcon:
                      _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          // ----------------------------------------------------
          // LIST
          // ----------------------------------------------------

          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding:
              const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: _fetchProjects,
                icon: const Icon(
                  Icons.refresh,
                  size: 18,
                ),
                label:
                    const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredProjects.isEmpty) {
      return Center(
        child: Padding(
          padding:
              const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                Icons.folder_off_outlined,
                size: 56,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 12),
              Text(
                _searchController.text.isNotEmpty
                    ? "No projects found matching \"${_searchController.text}\""
                    : "No projects available",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchProjects,
      child: ListView.separated(
        physics:
            const AlwaysScrollableScrollPhysics(),
        padding:
            const EdgeInsets.fromLTRB(
          16,
          6,
          16,
          20,
        ),
        itemCount:
            _filteredProjects.length,
        separatorBuilder:
            (context, index) =>
                const SizedBox(height: 10),
        itemBuilder:
            (context, index) {
          final project =
              _filteredProjects[index];

          return _buildProjectCard(project);
        },
      ),
    );
  }

  // ============================================================
  // PROJECT CARD
  // ============================================================

  Widget _buildProjectCard(
    WorkRequestProject project,
  ) {
    return InkWell(
      borderRadius:
          BorderRadius.circular(16),
      onTap: () =>
          _onProjectSelected(project),
      child: Container(
        padding:
            const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset:
                  const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors
                    .primaryColor
                    .withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.apartment,
                color:
                    AppColors.primaryColor,
                size: 24,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    project.projectName.isNotEmpty
                        ? project.projectName
                        : "Project #${project.id}",
                    style:
                        const TextStyle(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          Colors.black87,
                    ),
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          Colors.grey.shade100,
                      borderRadius:
                          BorderRadius.circular(
                        6,
                      ),
                      border: Border.all(
                        color:
                            Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      "ID: ${project.id}",
                      style:
                          TextStyle(
                        fontSize: 11,
                        color:
                            Colors.grey.shade700,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}