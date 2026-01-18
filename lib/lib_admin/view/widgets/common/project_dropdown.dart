import 'package:flutter/material.dart';
import '../../../data/Models/project_model.dart';

class ProjectDropdown extends StatelessWidget {
  final List<ProjectModel> projects;
  final ProjectModel? selectedProject;
  final ValueChanged<ProjectModel?> onChanged;
  final bool isLoading;

  const ProjectDropdown({
    super.key,
    required this.projects,
    this.selectedProject,
    required this.onChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final selectedId = selectedProject?.id;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      constraints: const BoxConstraints(minWidth: 120, maxWidth: 200),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: selectedId,
          isExpanded: true,
          hint: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.filter_list, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  projects.isEmpty ? "No Projects" : "Select Project",
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF666666),
            size: 20,
          ),
          style: const TextStyle(
            color: Color(0xFF333333),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          selectedItemBuilder: (BuildContext context) {
            return projects.map((project) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.folder, size: 16, color: Color(0xFF666666)),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      project.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            }).toList();
          },
          items: [
            ...projects.map((project) {
              return DropdownMenuItem<String?>(
                value: project.id,
                child: Row(
                  children: [
                    const Icon(
                      Icons.folder,
                      size: 16,
                      color: Color(0xFF666666),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        project.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
          onChanged: isLoading
              ? null
              : (String? newId) {
                  if (newId != null) {
                    final project = projects.firstWhere(
                      (p) => p.id == newId,
                      orElse: () => projects.first,
                    );
                    onChanged(project);
                  }
                },
        ),
      ),
    );
  }
}
