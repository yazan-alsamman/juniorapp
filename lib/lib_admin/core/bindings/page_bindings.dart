import 'package:get/get.dart';
import '../../controller/ai_assistance/ai_assistance_controller.dart';
import '../../controller/assignment/add_assignment_controller.dart';
import '../../controller/assignment/assignments_controller.dart';
import '../../controller/assignment/assignments_tabs_controller.dart';
import '../../controller/auth/add_client_controller.dart';
import '../../controller/common/customAppBar_controller.dart';
import '../../controller/common/customDrawer_controller.dart';
import '../../controller/common/filter_button_controller.dart';
import '../../controller/common/profile_controller.dart';
import '../../controller/delays/delays_controller.dart';
import '../../controller/employee/add_employee_controller.dart';
import '../../controller/employee/team_controller.dart';
import '../../controller/project/add_project_controller.dart';
import '../../controller/project/project_dashboard_controller.dart';
import '../../controller/project/projects_controller.dart';
import '../../controller/task/add_task_controller.dart';
import '../../controller/task/tasks_controller.dart';

class TeamScreenBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CustomDrawerControllerImp>()) {
      Get.put(CustomDrawerControllerImp());
    }
    if (!Get.isRegistered<CustomappbarControllerImp>()) {
      Get.put(CustomappbarControllerImp());
    }
    if (!Get.isRegistered<TeamControllerImp>()) {
      Get.put(TeamControllerImp());
    }
  }
}

class TasksScreenBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CustomDrawerControllerImp>()) {
      Get.put(CustomDrawerControllerImp());
    }
    if (!Get.isRegistered<CustomappbarControllerImp>()) {
      Get.put(CustomappbarControllerImp());
    }
    if (!Get.isRegistered<TasksControllerImp>()) {
      Get.put(TasksControllerImp());
    }
    if (!Get.isRegistered<FilterButtonController>()) {
      Get.put(FilterButtonController());
    }
  }
}

class ProjectsScreenBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CustomDrawerControllerImp>()) {
      Get.put(CustomDrawerControllerImp());
    }
    if (!Get.isRegistered<CustomappbarControllerImp>()) {
      Get.put(CustomappbarControllerImp());
    }
    if (!Get.isRegistered<ProjectsControllerImp>()) {
      Get.put(ProjectsControllerImp());
    }
    if (!Get.isRegistered<FilterButtonController>()) {
      Get.put(FilterButtonController());
    }
  }
}


class ProjectDashboardScreenBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CustomDrawerControllerImp>()) {
      Get.put(CustomDrawerControllerImp());
    }
    if (!Get.isRegistered<CustomappbarControllerImp>()) {
      Get.put(CustomappbarControllerImp());
    }
    if (!Get.isRegistered<ProjectDashboardControllerImp>()) {
      Get.put(ProjectDashboardControllerImp());
    }
  }
}

class AddEmployeeScreenBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AddEmployeeControllerImp>()) {
      Get.put(AddEmployeeControllerImp());
    }
  }
}

class EditEmployeeScreenBinding extends Bindings {
  @override
  void dependencies() {
  }
}

class AddTaskScreenBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AddTaskControllerImp>()) {
      Get.put(AddTaskControllerImp());
    }
  }
}

class EditTaskScreenBinding extends Bindings {
  @override
  void dependencies() {
  }
}

class TaskDetailScreenBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CustomDrawerControllerImp>()) {
      Get.put(CustomDrawerControllerImp());
    }
    if (!Get.isRegistered<CustomappbarControllerImp>()) {
      Get.put(CustomappbarControllerImp());
    }
  }
}

class TaskCommentsScreenBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CustomDrawerControllerImp>()) {
      Get.put(CustomDrawerControllerImp());
    }
    if (!Get.isRegistered<CustomappbarControllerImp>()) {
      Get.put(CustomappbarControllerImp());
    }
  }
}

class RequestDelayScreenBinding extends Bindings {
  @override
  void dependencies() {
  }
}

class AddProjectScreenBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AddProjectControllerImp>()) {
      Get.put(AddProjectControllerImp());
    }
  }
}

class EditProjectScreenBinding extends Bindings {
  @override
  void dependencies() {
  }
}

class ProjectDetailsScreenBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CustomDrawerControllerImp>()) {
      Get.put(CustomDrawerControllerImp());
    }
    if (!Get.isRegistered<CustomappbarControllerImp>()) {
      Get.put(CustomappbarControllerImp());
    }
  }
}

class ProjectCommentsScreenBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CustomDrawerControllerImp>()) {
      Get.put(CustomDrawerControllerImp());
    }
    if (!Get.isRegistered<CustomappbarControllerImp>()) {
      Get.put(CustomappbarControllerImp());
    }
  }
}

class ProfileScreenBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CustomDrawerControllerImp>()) {
      Get.put(CustomDrawerControllerImp());
    }
    if (!Get.isRegistered<CustomappbarControllerImp>()) {
      Get.put(CustomappbarControllerImp());
    }
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController());
    }
  }
}

class AssignmentsScreenBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CustomDrawerControllerImp>()) {
      Get.put(CustomDrawerControllerImp());
    }
    if (!Get.isRegistered<CustomappbarControllerImp>()) {
      Get.put(CustomappbarControllerImp());
    }
    if (!Get.isRegistered<AssignmentsControllerImp>()) {
      Get.put(AssignmentsControllerImp());
    }
    if (!Get.isRegistered<EmployeeScheduleController>()) {
      Get.put(EmployeeScheduleController());
    }
    if (!Get.isRegistered<TaskAssignmentsController>()) {
      Get.put(TaskAssignmentsController());
    }
  }
}

class AddAssignmentScreenBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AddAssignmentControllerImp>()) {
      Get.put(AddAssignmentControllerImp());
    }
  }
}

class ReassignAssignmentScreenBinding extends Bindings {
  @override
   void dependencies() {
  }
}

class AddClientScreenBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AddClientControllerImp>()) {
      Get.put(AddClientControllerImp());
    }
  }
}

class AiAssistanceScreenBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CustomDrawerControllerImp>()) {
      Get.put(CustomDrawerControllerImp());
    }
    if (!Get.isRegistered<AiAssistanceControllerImp>()) {
      Get.put(AiAssistanceControllerImp());
    }
  }
}

class DelaysScreenBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CustomDrawerControllerImp>()) {
      Get.put(CustomDrawerControllerImp());
    }
    if (!Get.isRegistered<CustomappbarControllerImp>()) {
      Get.put(CustomappbarControllerImp());
    }
    if (!Get.isRegistered<DelaysController>()) {
      Get.put(DelaysController());
    }
  }
}

