import '../models/question.dart';

class QuizData {
  static final List<Question> alGkQuestions = [
    Question(
      questionText: "ලංකාවේ ප්‍රථම විධායක ජනාධිපතිවරයා කවුද? (Who was the first Executive President of Sri Lanka?)",
      options: [
        "එස්.ඩබ්ලිව්.ආර්.ඩී. බණ්ඩාරනායක (S.W.R.D. Bandaranaike)",
        "ජේ.ආර්. ජයවර්ධන (J.R. Jayewardene)",
        "ආර්. ප්‍රේමදාස (R. Premadasa)",
        "ඩී.එස්. සේනානායක (D.S. Senanayake)"
      ],
      correctAnswerIndex: 1,
      explanation: "ජේ.ආර්. ජයවර්ධන මහතා 1978 දී ලංකාවේ ප්‍රථම විධායක ජනාධිපති ලෙස පත් විය.",
    ),
    Question(
      questionText: "ශ්‍රී ලංකාවේ උසම දිය ඇල්ල කුමක්ද? (What is the highest waterfall in Sri Lanka?)",
      options: [
        "දියලුම (Diyaluma)",
        "බඹරකන්ද (Bambarakanda)",
        "දුන්හිඳ (Dunhinda)",
        "ශාන්ත ක්ලෙයාර් (St. Clair's)"
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: "ලෝකයේ විශාලතම සාගරය කුමක්ද? (Which is the largest ocean in the world?)",
      options: [
        "අත්ලාන්තික් සාගරය (Atlantic Ocean)",
        "ඉන්දියන් සාගරය (Indian Ocean)",
        "පැසිෆික් සාගරය (Pacific Ocean)",
        "ආක්ටික් සාගරය (Arctic Ocean)"
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: "IQ: 2, 4, 8, 16, ... ඊළඟ අංකය කුමක්ද? (What is the next number?)",
      options: ["20", "24", "32", "64"],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: "ශ්‍රී ලංකාවේ මධ්‍යම කඳුකරයේ පිහිටි උසම කන්ද කුමක්ද? (What is the highest mountain in Sri Lanka?)",
      options: [
        "සමනල කන්ද (Sri Pada)",
        "නමුණුකුල (Namunukula)",
        "පිදුරුතලාගල (Pidurutalagala)",
        "කතලහේන (Katalana)"
      ],
      correctAnswerIndex: 2,
    ),
  ];
}
