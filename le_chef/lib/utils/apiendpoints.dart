class ApiEndPoints {
  static const String baseUrl = "http://www.lechefpro.com/";
  static AuthEndPoint authEndPoint = AuthEndPoint();
  static UserManage userManage = UserManage();
  static Quiz quiz = Quiz();
  static Content content = Content();
  static Chat chat = Chat();
  static Payment payment = Payment();
  static Session session = Session();
  static Notification notification = Notification();
}

class AuthEndPoint {
  final String loginEmail = "Users/login";
}

class UserManage {
  final String AddStudent = "userManage/AddStudents";
  final String GetStudents = "userManage/ShowAllStudents";
  final String DelStudent = "userManage/DeleteStudent/";
  final String editProfile = 'userManage/editProfile/';
  final String getAdmin = 'userManage/AdminProfile';
  final String getAdminForStd = 'userManage/GetAdminDetails';
}

class Quiz {
  final String addQuiz = 'Quiz/AddQuiz';
  final String Quizbyid = 'Quiz/';
  final String getAllQuizzes = 'Quiz/ShowAllQuizzes';
  final String getExamUnits = 'Quiz/Unit';
  final String delQuiz = 'Quiz/DeleteQuiz/';
  final String updateQuiz = 'Quiz/UpdateQuiz/';
  final String submitQuiz = 'UserQuiz/SubmitQuiz/';
  final String submittedQuizs = 'Quiz/GetSubmittedQuizzesIds';
  final String submittedQuizbyID = 'Quiz/GetSubmittedQuizzes/';
}

class Content {
  final String uploadVideo = 'content/videos';
  final String uploadPDF = 'content/Pdfs';
  final String allPDFs = 'content/ShowAllPdfs';
  final String allNotes = 'content/ShowAllNotes';
  final String addNote = 'content/Notes';
  final String StudentNotes = 'content/ShowLevelNotes';
}

class Chat {
  final sendDirectMsg = 'Chat/SendDirectMessage/';
  final getDirectMsg = 'Chat/getDirectMessages/';
  final sendGrpMsg = 'Chat/SendGroupMessage/';
  final createGrp = 'Chat/CreateGroup';
  final getAdminGroups = 'Chat/GetAdminGroups';
  final addStudentstoGroup = 'Chat/AddStudentToGroup/';
  final getStudentGroups = 'Chat/GetStudentGroups';
  final deleteGroup = 'Chat/DeleteGroup/';
  final getGroupMembers = 'Chat/GetGroupMembers/';
  final removeStudent = 'Chat/RemoveStudent/';
  final getGroupMsg = 'Chat/getGroupMessages/';
  final getAdminChats = 'Chat/getAdminChats';
}

class Payment {
  final credieCard = 'Pay/paymob/creditCard';
  final E_Wallet = 'Pay/WalletRequest/';
  final Cash = 'Pay/CashRequest/';
  final getPaymentReq = 'Pay/PendingRequests';
  final requests = 'Pay/Requests/';
  final accept = '/accept';
  final reject = '/reject';
}

class Session {
  final createSession = 'zoom/create-zoom-meeting';
  final getSession = 'zoom/get-zoom-meetings';
  final joinSession = 'zoom/join-zoom-meeting';
}

class Notification {
  final getAdminNotification = 'Notifications/AdminNotification';
  final getUserNotification = 'Notifications/UserNotification';
}
