import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:site_720/features/livemap/cubit/livemap_cubit.dart';
import '../../../data/models/livemap/livemap_model.dart';
import 'package:site_720/core/widgets/appbar.dart';
import '../widgets/project_popup.dart';

class LivemapScreen extends StatefulWidget {
  const LivemapScreen({super.key});

  @override
  State<LivemapScreen> createState() => _LivemapScreenState();
}

class _LivemapScreenState extends State<LivemapScreen> {
  String searchText = "";
  final MapController mapController = MapController();
  LiveMapData? selectedProject;
  @override
  void initState() {
    super.initState();
    context.read<LiveMapCubit>().getLiveMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: simpleAppbar(context, "Live Map", true),
        body: BlocBuilder<LiveMapCubit, LiveMapState>(
          builder: (context, state) {
            if (state is LiveMapLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is LiveMapLoaded) {
              return Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: LatLng(10.8505, 76.2711),
                      initialZoom: 8,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        userAgentPackageName: "com.example.site_720",
                      ),
                      MarkerLayer(
                        markers: state.model.data
                            .where(
                          (project) =>
                              (project.projectName
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase()) ||
                                  project.district
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase()) ||
                                  project.supervisor
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase()) ||
                                  project.location
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase())) &&
                              project.latitude != null &&
                              project.longitude != null &&
                              project.latitude!.toString().isNotEmpty &&
                              project.longitude!.toString().isNotEmpty,
                        )
                            .map((project) {
                          return Marker(
                            point: LatLng(
                              project.latitude!,
                              project.longitude!,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedProject = project;
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_pin,
                                    color:
                                        getStatusColor(project.status)["text"],
                                    size: 40,
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                    width: 160,
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      project.projectName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 10,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5DC),
                        border: Border.all(
                          color: const Color(0xFFE85D2C),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchText = value;
                          });
                          final matches = state.model.data.where(
                            (project) =>
                                (project.projectName
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    project.supervisor
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    project.location
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    project.district
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) &&
                                project.latitude != null &&
                                project.longitude != null &&
                                project.latitude!.toString().isNotEmpty &&
                                project.longitude!.toString().isNotEmpty,
                          );

                          if (matches.isNotEmpty) {
                            final project = matches.first;

                            mapController.move(
                              LatLng(
                                project.latitude!,
                                project.longitude!,
                              ),
                              15,
                            );
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Search by district/site/supervisor",
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 14,
                          ),
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFFE85D2C),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (selectedProject != null)
                    Positioned(
                      top: 20,
                      left: 20,
                      right: 20,
                      child: ProjectPopup(
                        project: selectedProject!,
                        getStatusColor: getStatusColor,
                        onClose: () {
                          setState(() {
                            selectedProject = null;
                          });
                        },
                      ),
                    ),
                ],
              );
            }

            if (state is LiveMapError) {
              return Text(state.message);
            }

            return const SizedBox();
          },
        ));
  }

  //Status fuction
  Map<String, Color> getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "completed":
        return {
          "bg": Colors.lightGreen.shade100,
          "text": Colors.green.shade800,
        };

      case "running":
        return {
          "bg": Colors.orange.shade100,
          "text": Colors.orange.shade800,
        };

      case "upcoming":
        return {
          "bg": Colors.yellow.shade100,
          "text": Colors.yellow.shade800,
        };

      default:
        return {
          "bg": Colors.grey.shade200,
          "text": Colors.black,
        };
    }
  }
}
