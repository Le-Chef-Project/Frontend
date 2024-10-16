class ApiEndPoints {
  static final String baseUrl = "http://192.168.1.12:3000/";
  static AuthEndPoint authEndPoint = AuthEndPoint();
  static UserManage userManage = UserManage();
  static Quiz quiz = Quiz();
}

class AuthEndPoint {
  final String loginEmail = "Users/login";
}

class UserManage {
  final String AddStudent = "userManage/AddStudents";
  final String GetStudents = "userManage/ShowAllStudents";
  final String DelStudent = "userManage/DeleteStudent/";
}

class Quiz {
  final String addQuiz = 'Quiz/AddQuiz';
}
