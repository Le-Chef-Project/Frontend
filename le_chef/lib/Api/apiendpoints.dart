import 'package:le_chef/Models/direct_chat.dart';

class ApiEndPoints {
  static const String baseUrl = "http://192.168.1.3:3000/";
  static AuthEndPoint authEndPoint = AuthEndPoint();
  static UserManage userManage = UserManage();
  static Quiz quiz = Quiz();
  static Content content = Content();
  static Chat chat = Chat();
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
  final String getAllQuizzes = 'Quiz/ShowAllQuizzes';
  final String getExamUnits = 'Quiz/Unit';
  final String delQuiz = 'Quiz/DeleteQuiz/';
  final String updateQuiz = 'Quiz/UpdateQuiz/';
  final String submitQuiz = 'UserQuiz/SubmitQuiz/';
}

class Content {
  final String uploadVideo = 'content/videos';
  final String uploadPDF = 'content/Pdfs';
  final String allPDFs = 'content/ShowAllPdfs';
  final String allNotes = 'content/ShowAllNotes';
  final String addNote = 'content/Notes';
}

class Chat {
  final sendDirectMsg = 'Chat/SendDirectMessage/';
  final sendGrpMsg = 'Chat/SendGroupMessage/';
}
