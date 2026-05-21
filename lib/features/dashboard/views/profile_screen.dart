import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../data/services/http_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;

  Map<String, dynamic>? profile;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  /// GET PROFILE
  Future<void> getProfile() async {
    var response = await HttpServices.getProfile();

    if (response != null && response["status"] == true) {
      setState(() {
        profile = response["data"];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      /// APPBAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(
          247,
          100,
          38,
          53,
        ),
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            )
          : profile == null
              ? const Center(
                  child: Text(
                    "Profile not found",
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      /// PROFILE CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            /// PROFILE IMAGE
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                  width: 3,
                                ),
                                image: profile!["pro_pic_thumb"] != null &&
                                        profile!["pro_pic_thumb"]
                                            .toString()
                                            .isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(
                                          profile!["pro_pic_thumb"],
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                color: const Color(
                                  0xffF5F5F5,
                                ),
                              ),
                              child: profile!["pro_pic_thumb"] == null ||
                                      profile!["pro_pic_thumb"]
                                          .toString()
                                          .isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      size: 55,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),

                            const SizedBox(height: 18),

                            /// NAME
                            Text(
                              profile!["staff_name"] ?? "",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            /// DESIGNATION
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                profile!["designation"] ?? "",
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// DETAILS CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            buildProfileTile(
                              icon: Icons.badge_outlined,
                              title: "User ID",
                              value: profile!["user_id"] ?? "",
                            ),
                            const Divider(height: 30),
                            buildProfileTile(
                              icon: Icons.email_outlined,
                              title: "Email",
                              value: profile!["email"] == null ||
                                      profile!["email"].toString().isEmpty
                                  ? "Not Available"
                                  : profile!["email"],
                            ),
                            const Divider(height: 30),
                            buildProfileTile(
                              icon: Icons.phone_outlined,
                              title: "Phone Number",
                              value: profile!["phone_no"] ?? "",
                            ),
                            const Divider(height: 30),
                            buildProfileTile(
                              icon: Icons.work_outline,
                              title: "Designation",
                              value: profile!["designation"] ?? "",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  /// PROFILE TILE
  Widget buildProfileTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
