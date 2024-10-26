class ApiEndPoints {
  static const String baseUrl = "http://192.168.1.13:3000/";
  static AuthEndPoint authEndPoint = AuthEndPoint();
  static UserManage userManage = UserManage();
  static Quiz quiz = Quiz();
  static Content content = Content();
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

class Content {
  final String uploadVideo = 'content/videos';
  final String uploadPDF = 'content/Pdfs';
  final String allPDFs = 'content/ShowAllPdfs';
  final String allNotes = 'content/ShowAllNotes';
  final String addNote = 'content/Notes';
}
