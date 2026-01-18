import 'package:flutter/material.dart';
import '../../../controller/common/customDrawer_controller.dart';
import 'package:get/get.dart';
import '../../../controller/project/project_dashboard_controller.dart';
import '../../../core/constant/color.dart';
import '../../../core/constant/responsive.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_drawer.dart';
import '../../widgets/common/project_dropdown.dart';
import '../../widgets/common/project_charts_widget.dart';
class ProjectDashboardScreen extends StatelessWidget {
  const ProjectDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<CustomDrawerControllerImp>()) {
      Get.put(CustomDrawerControllerImp());
    }
    if (!Get.isRegistered<ProjectDashboardControllerImp>()) {
      Get.put(ProjectDashboardControllerImp());
    }
    final CustomDrawerControllerImp customDrawerController =
        Get.find<CustomDrawerControllerImp>();
    return Scaffold(
      drawer: CustomDrawer(
        onItemTap: (item) {
          customDrawerController.onMenuItemTap(item);
        },
      ),
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            final controller = Get.isRegistered<ProjectDashboardControllerImp>()
                ? Get.find<ProjectDashboardControllerImp>()
                : Get.put(ProjectDashboardControllerImp());
            await controller.loadAllProjects(refresh: true);
            await controller.loadStats();
          },
          color: AppColor.primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              color: AppColor.backgroundColor,
              child: GetBuilder<ProjectDashboardControllerImp>(
                init: Get.isRegistered<ProjectDashboardControllerImp>()
                    ? Get.find<ProjectDashboardControllerImp>()
                    : Get.put(ProjectDashboardControllerImp()),
                builder: (controller) => Padding(
                  padding: Responsive.padding(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              "Projects",
                              style: TextStyle(
                                fontSize: Responsive.fontSize(
                                  context,
                                  mobile: 24,
                                ),
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: ProjectDropdown(
                              projects: controller.allProjects,
                              selectedProject: controller.selectedProject,
                              onChanged: (project) {
                                controller.changeSelectedProject(project);
                              },
                              isLoading: controller.isLoading,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Responsive.spacing(context, mobile: 20)),
                      if (controller.selectedProject != null) ...[
                        SizedBox(height: Responsive.spacing(context, mobile: 20)),
                        Text(
                          "Project Details",
                          style: TextStyle(
                            fontSize: Responsive.fontSize(
                              context,
                              mobile: 20,
                            ),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        SizedBox(height: Responsive.spacing(context, mobile: 16)),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE0E0E0),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.selectedProject!.title,
                                style: TextStyle(
                                  fontSize: Responsive.fontSize(
                                    context,
                                    mobile: 18,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                              SizedBox(
                                height: Responsive.spacing(context, mobile: 12),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoCard(
                                      context,
                                      "Total Tasks",
                                      "${controller.selectedProject!.totalTasks ?? 0}",
                                      Icons.check_box_outlined,
                                      const Color(0xFF8B5CF6),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.spacing(context, mobile: 12),
                                  ),
                                  Expanded(
                                    child: _buildInfoCard(
                                      context,
                                      "Completed",
                                      "${controller.selectedProject!.completedTasks ?? 0}",
                                      Icons.check_circle_outline,
                                      const Color(0xFF10B981),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.spacing(context, mobile: 12),
                                  ),
                                  Expanded(
                                    child: _buildInfoCard(
                                      context,
                                      "Progress",
                                      "${(controller.selectedProject!.progressPercentage ?? 0.0).toStringAsFixed(0)}%",
                                      Icons.trending_up,
                                      const Color(0xFFF59E0B),
                                    ),
                                  ),
                                ],
                              ),
                              ProjectChartsWidget(project: controller.selectedProject!),
                            ],
                          ),
                        ),
                      ] else if (!controller.isLoading && controller.allProjects.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "No projects found",
                              style: TextStyle(
                                fontSize: Responsive.fontSize(
                                  context,
                                  mobile: 16,
                                ),
                                color: const Color(0xFF666666),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, mobile: 12),
                    color: const Color(0xFF666666),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.fontSize(context, mobile: 18),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
