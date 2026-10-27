import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'dart:io';
import 'dart:ui';
String uiText(String languageCode, String key) {
  final Map<String, Map<String, String>> translations = {
    'en-US': {
      'chooseLanguage': 'Choose Your Language',
      'uploadForm': 'Upload Form',
      'takePhoto': 'Take Photo',
      'gallery': 'Choose from Gallery',
      'choosePdf': 'Choose PDF',
      'next': 'Next',
      'answerQuestions': 'Answer Questions',
      'askAloud': 'Ask Question Aloud',
      'speakAnswer': 'Speak Your Answer',
      'skipQuestion':'skip Question',
      'listening': 'Listening...',
      'saveNext': 'Save Answer and Next',
      'finish': 'Finish: Review Answers',
      'review': 'Review Answers',
      'backHome': 'Back to Home',
      'save': 'Save Form',
      'error': 'Something went wrong. Please try again.',
      'yesCorrect': 'Yes, correct',
      'tryAgain': 'Try again',
      'answerSaved': 'Answer saved.',
      'heardAnswer': 'I heard: ',
      'confirmAnswer': 'Please check the answer on the screen.',
      'answerRequired':
      'Please answer and confirm this question before continuing.',
    },
    'te-IN': {
      'chooseLanguage': 'మీ భాషను ఎంచుకోండి',
      'uploadForm': 'ఫారమ్‌ను అప్‌లోడ్ చేయండి',
      'takePhoto': 'ఫోటో తీయండి',
      'gallery': 'గ్యాలరీ నుంచి ఎంచుకోండి',
      'choosePdf': 'PDF ఎంచుకోండి',
      'next': 'తర్వాత',
      'answerQuestions': 'ప్రశ్నలకు సమాధానం ఇవ్వండి',
      'askAloud': 'ప్రశ్నను వినండి',
      'skipQuestion':'ప్రశ్నను దాటవేయి',
      'speakAnswer': 'మీ సమాధానం చెప్పండి',
      'listening': 'వింటోంది...',
      'saveNext': 'సమాధానాన్ని సేవ్ చేసి తర్వాతకు వెళ్లండి',
      'finish': 'సమాధానాలను పరిశీలించండి',
      'review': 'సమాధానాలను పరిశీలించండి',
      'backHome': 'హోమ్‌కు తిరిగి వెళ్లండి',
      'save': 'ఫారమ్‌ను సేవ్ చేయండి',
      'error': 'ఏదో సమస్య వచ్చింది. మళ్లీ ప్రయత్నించండి.',
      'yesCorrect': 'అవును, సరైనది',
      'tryAgain': 'మళ్లీ ప్రయత్నించండి',
      'answerSaved': 'సమాధానం సేవ్ అయింది.',
      'heardAnswer': 'మీరు చెప్పిన సమాధానం: ',
      'confirmAnswer': 'సమాధానాన్ని తెరపై చూసి నిర్ధారించండి.',
      'answerRequired':
      'కొనసాగించే ముందు ఈ ప్రశ్నకు సమాధానం చెప్పి నిర్ధారించండి.',
    },
    'hi-IN': {
      'chooseLanguage': 'अपनी भाषा चुनें',
      'uploadForm': 'फ़ॉर्म अपलोड करें',
      'takePhoto': 'फ़ोटो लें',
      'gallery': 'गैलरी से चुनें',
      'choosePdf': 'PDF चुनें',
      'next': 'आगे बढ़ें',
      'answerQuestions': 'प्रश्नों के उत्तर दें',
      'askAloud': 'प्रश्न सुनें',
      'skipQuestion':'प्रश्न छोड़ें',
      'speakAnswer': 'अपना उत्तर बोलें',
      'listening': 'सुन रहा है...',
      'saveNext': 'उत्तर सेव करके आगे बढ़ें',
      'finish': 'उत्तर जाँचें',
      'review': 'उत्तर जाँचें',
      'backHome': 'होम पर वापस जाएँ',
      'save': 'फ़ॉर्म सेव करें',
      'error': 'कुछ गलत हुआ। कृपया फिर कोशिश करें।',
      'yesCorrect': 'हाँ, सही है',

      'tryAgain': 'फिर से कोशिश करें',
      'answerSaved': 'उत्तर सेव हो गया।',
      'heardAnswer': 'आपने यह उत्तर दिया: ',
      'confirmAnswer': 'स्क्रीन पर उत्तर जाँचें।',
      'answerRequired':
      'आगे बढ़ने से पहले इस प्रश्न का उत्तर दें और पुष्टि करें।',
    },
  };

  return translations[languageCode]?[key] ??
      translations['en-US']![key] !;

}
void main() {
  runApp(const VoiceFormApp());
}

class VoiceFormApp extends
  StatelessWidget {
  const VoiceFormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const LanguagePage(),
    );
  }
}

class FormAnswer {
  FormAnswer(this.label, this.question);

  final String label;
  final String question;
  String answer = '';
  double? x;
  double? y;
  double? width;
  double? height;
}
class LanguagePage extends
 StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final languages = [
      {
        'name': 'English',
        'code': 'en-US',
        'subtitle': 'Continue in English',
        'notAnswered': 'Not answered',
      },
      {
        'name': 'తెలుగు',
        'code': 'te-IN',
        'subtitle': 'తెలుగులో కొనసాగించండి',
        'notAnswered': 'సమాధానం ఇవ్వలేదు',
      },
      {
        'name': 'हिन्दी',
        'code': 'hi-IN',
        'subtitle': 'हिंदी में जारी रखें',
        'notAnswered': 'उत्तर नहीं दिया गया',
      },
    ];

    final colors = [
      Colors.blue,
      Colors.green,
      Colors.deepOrange,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Voice Form',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 20),
            const Icon(
              Icons.record_voice_over_rounded,
              size: 100,
              color: Colors.teal,
            ),
            const SizedBox(height: 20),


            const Text(
              'Select your preferred language',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 30),
            for (int i = 0; i < languages.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: SizedBox(
                  height: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors[i],
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(16),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UploadPage(
                            languageName: languages[i]['name']!,
                            languageCode: languages[i]['code']!,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          languages[i]['name']!,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          languages[i]['subtitle']!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class UploadPage extends StatefulWidget {
  const UploadPage({
    super.key,
    required this.languageName,
    required this.languageCode,
  });

  final String languageName;
  final String languageCode;

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final ImagePicker picker = ImagePicker();

  String? imagePath;
  String? fileName;
  bool loading = false;
  String status = '';

  Future<void> chooseImage(ImageSource source) async {
    try {
      final image = await picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (image == null) return;
      setState(() {
        imagePath = image.path;
        fileName = image.name;
        status = '';
      });
    } catch (e) {
      showMessage('Could not open image: $e');
    }
  }

  Future<void> choosePdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.isEmpty) return;

      setState(() {
        fileName = result.files.first.name;
        imagePath = null;
        status =
        'PDF selected, but PDF reading is not yet supported. '
            'Please select a form image to continue.';
      });
    } catch (e) {
      showMessage('Could not select PDF: $e');
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> continueToQuestions() async {
    if (imagePath == null) {
      showMessage('Please select a form image first.');
      return;
    }

    setState(() {
      loading = true;
      status = 'Reading your form...';
    });

    final recognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );

    try {
      final input = InputImage.fromFilePath(imagePath!);
      final result = await recognizer.processImage(input);
      final decodedImage = await decodeImageFromList(
        await File(imagePath!).readAsBytes(),
      );

      final originalImageWidth = decodedImage.width.toDouble();
      final originalImageHeight = decodedImage.height.toDouble();

      debugPrint('Original image: $originalImageWidth x $originalImageHeight');
      final Map<String, List<double>> fieldPositions = {};

      for (final block in result.blocks) {
        for (final line in block.lines) {
          final label = line.text.trim().toLowerCase();

          if (label.contains('name') ||
              label.contains('age') ||
              label.contains('address') ||
              label.contains('email') ||
              label.contains('phone')) {
            fieldPositions[label] = [
              line.boundingBox.left,
              line.boundingBox.top,
              line.boundingBox.width,
              line.boundingBox.height,
            ];
          }
        }
      }

      debugPrint('Detected field positions: $fieldPositions');
      if (!mounted) return;

      final formLanguageCode = detectFormLanguage(result.text);
      debugPrint('FORM LANGUAGE: $formLanguageCode');
      debugPrint('OCR TEXT: ${result.text}');

      final questions = await buildQuestions(
        result.text,
        widget.languageCode,
      );
      debugPrint('FORM LANGUAGE: $formLanguageCode');
      debugPrint('OCR TEXT: ${result.text}');
      debugPrint('TRANSLATION CHECK: Form language is $formLanguageCode');
      for (final item in questions) {
        final key = item.label
            .replaceAll(':', '')
            .trim()
            .toLowerCase();

        for (final block in result.blocks) {
          for (final line in block.lines) {
            final detectedLabel = line.text
                .replaceAll(':', '')
                .trim()
                .toLowerCase();

            if (detectedLabel == key) {
              item.x = line.boundingBox.right;
              item.y = line.boundingBox.top;
              item.width = line.boundingBox.width;
              item.height = line.boundingBox.height;
              break;
            }
          }
        }
      }
      if (questions.isEmpty) {
        setState(() {
          status =
          'No supported form labels were detected. '
              'Try a clearer image containing common English labels.';
        });
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuestionsPage( formLanguageCode: formLanguageCode,
            languageName: widget.languageName,
            languageCode: widget.languageCode,
            answers: questions,
            recognizedText: result.text,
            imagePath: imagePath!,
          ),
        ),
      );
    } catch (e) {
      showMessage('Could not read the image: $e');
    } finally {
      await recognizer.close();
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Form • ${widget.languageName}'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(Icons.upload_file, size: 70, color: Colors.teal),
            const SizedBox(height: 12),
            Text(
              uiText(widget.languageCode, 'uploadForm'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => chooseImage(ImageSource.camera),
            icon: const Icon(Icons.camera_alt),
            label: Text(uiText(widget.languageCode, 'takePhoto')),
          ),
          ElevatedButton.icon(
            onPressed: () => chooseImage(ImageSource.gallery),
            icon: const Icon(Icons.photo_library),
            label: Text(uiText(widget.languageCode, 'gallery')),
          ),
            ElevatedButton.icon(
              onPressed: choosePdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: Text(uiText(widget.languageCode, 'choosePdf')),
            ),
            if (fileName != null) ...[
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text(fileName!),
                subtitle: const Text('Selected file'),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      imagePath = null;
                      fileName = null;
                      status = '';
                    });
                  },
                ),
              ),
            ],
            if (status.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(status),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed:
              loading || imagePath == null ? null : continueToQuestions,
              child: Text(uiText(widget.languageCode, 'answerQuestions'))
            ),
          ],
        ),
      ),
    );
  }
}
Future<List<FormAnswer>> buildQuestions(
    String text,
    String languageCode,
    ) async {
  final lines = text
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();
  final questions = <FormAnswer>[];
  final seen = <String>{};

  final knownFields = <String, Map<String, String>>{
    'full name': {
      'en': 'What is your full name?',
      'te': 'మీ పూర్తి పేరు ఏమిటి?',
      'hi': 'आपका पूरा नाम क्या है?',
    },
    'name': {
      'en': 'What is your name?',
      'te': 'మీ పేరు ఏమిటి?',
      'hi': 'आपका नाम क्या है?',
    },
    'age': {
      'en': 'What is your age?',
      'te': 'మీ వయస్సు ఎంత?',
      'hi': 'आपकी उम्र कितनी है?',
    },
    'father name': {
      'en': 'What is your father’s name?',
      'te': 'మీ తండ్రి పేరు ఏమిటి?',
      'hi': 'आपके पिता का नाम क्या है?',
    },
    'mother name': {
      'en': 'What is your mother’s name?',
      'te': 'మీ తల్లి పేరు ఏమిటి?',
      'hi': 'आपकी माता का नाम क्या है?',
    },
    'address': {
      'en': 'What is your address?',
      'te': 'మీ చిరునామా ఏమిటి?',
      'hi': 'आपका पता क्या है?',
    },
    'phone number': {
      'en': 'What is your phone number?',
      'te': 'మీ ఫోన్ నంబర్ ఏమిటి?',
      'hi': 'आपका फोन नंबर क्या है?',
    },
    'mobile number': {
      'en': 'What is your mobile number?',
      'te': 'మీ మొబైల్ నంబర్ ఏమిటి?',
      'hi': 'आपका मोबाइल नंबर क्या है?',
    },
    'email': {
      'en': 'What is your email address?',
      'te': 'మీ ఈమెయిల్ చిరునామా ఏమిటి?',
      'hi': 'आपका ईमेल पता क्या है?',
    },
    'date of birth': {
      'en': 'What is your date of birth?',
      'te': 'మీ పుట్టిన తేదీ ఏమిటి?',
      'hi': 'आपकी जन्म तिथि क्या है?',
    },
    'gender': {
      'en': 'What is your gender?',
      'te': 'మీ లింగం ఏమిటి?',
      'hi': 'आपका लिंग क्या है?',
    },
    'occupation': {
      'en': 'What is your occupation?',
      'te': 'మీ వృత్తి ఏమిటి?',
      'hi': 'आपका व्यवसाय क्या है?',
    },
      'eligible': {
        'en': 'Are you eligible for this?',
        'te': 'మీరు దీనికి అర్హులా?',
        'hi': 'क्या आप इसके लिए पात्र हैं?',
      },
      'eligibility': {
        'en': 'Are you eligible for this?',
        'te': 'మీరు దీనికి అర్హులా?',
        'hi': 'क्या आप इसके लिए पात्र हैं?',
      },
      'qualification': {
        'en': 'What is your educational qualification?',
        'te': 'మీ విద్యార్హత ఏమిటి?',
        'hi': 'आपकी शैक्षणिक योग्यता क्या है?',
      },
      'income': {
        'en': 'What is your income?',
        'te': 'మీ ఆదాయం ఎంత?',
        'hi': 'आपकी आय कितनी है?',
      },
      'nationality': {
        'en': 'What is your nationality?',
        'te': 'మీ జాతీయత ఏమిటి?',
        'hi': 'आपकी राष्ट्रीयता क्या है?',
      },
  };
  final languageKey = languageCode == 'te-IN'
      ? 'te'
      : languageCode == 'hi-IN'
      ? 'hi'
      : 'en';

  bool looksLikeField(String line) {
    final cleaned = line.trim();

    if (cleaned.length < 2 || cleaned.length > 100) {
      return false;
    }

    if (RegExp(r'^[\d\s./-]+$').hasMatch(cleaned)) {
      return false;
    }

    return cleaned.contains(':') ||
        cleaned.contains('?') ||
        RegExp(r'_{2,}|\.{3,}|-{3,}').hasMatch(cleaned) ||
        RegExp(
          r'\b(name|number|address|date|birth|age|gender|email|'
          r'phone|mobile|occupation|signature|account|income|'
          r'qualification|nationality|city|state|country|'
          r'father|mother|guardian|relationship|emergency|'
          r'purpose|reference|identity|document|applicant)\b',
          caseSensitive: false,
        ).hasMatch(cleaned);
  }

  OnDeviceTranslator? translator;

  if (languageKey == 'te') {
    translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.telugu,
    );
  } else if (languageKey == 'hi') {
    translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.hindi,
    );
  }

  try {
    for (final originalLine in lines) {
      var line = originalLine
          .replaceAll(RegExp(r'^[\s\d.)]+'), '')
          .trim();

      if (line.isEmpty || !looksLikeField(line)) {
        continue;
      }

      line = line.replaceAll(RegExp(r'[:?]+$'), '').trim();
      line = line.replaceAll(RegExp(r'[_*]+'), ' ').trim();
      line = line.replaceAll(RegExp(r'\s+'), ' ');

      if (line.isEmpty) continue;

      final normalized = line.toLowerCase();

      if (!seen.add(normalized)) continue;

      String? knownQuestion;

      for (final entry in knownFields.entries) {
        final key = entry.key.toLowerCase();

        if (normalized == key ||
            normalized.startsWith('$key ') ||
            normalized.startsWith('$key(')) {
          knownQuestion = entry.value[languageKey];
          break;
        }
      }

      String question;

      if (knownQuestion != null) {
        question = knownQuestion;
      } else if (translator != null) {
        try {
          question = await translator.translateText(line);
        } catch (_) {
          question = languageKey == 'te'
              ? 'దయచేసి ఈ ప్రశ్నకు సమాధానం చెప్పండి.'
              : 'कृपया इस प्रश्न का उत्तर बताएं।';
        }
      } else {
        question = 'Please answer: $line';
      }

      questions.add(FormAnswer(line, question));
    }
  } finally {
    await translator?.close();
  }

  return questions;
}
String detectFormLanguage(String text) {
  if (RegExp(r'[\u0C00-\u0C7F]').hasMatch(text)) {
    return 'te-IN'; // Telugu
  }

  if (RegExp(r'[\u0900-\u097F]').hasMatch(text)) {
    return 'hi-IN'; // Hindi
  }

  return 'en-US'; // English
}
TranslateLanguage _getTranslateLanguage(String languageCode) {
  if (languageCode.startsWith('te')) {
    return TranslateLanguage.telugu;
  }

  if (languageCode.startsWith('hi')) {
    return TranslateLanguage.hindi;
  }

  return TranslateLanguage.english;
}
String extractAnswer(String label, String spoken) {
  var answer = spoken.trim();
  final lowerLabel = label.toLowerCase();

  if (lowerLabel.contains('name')) {
    answer = answer.replaceFirst(
      RegExp(
        r"^(my name is|i am|i'm)\s+",
        caseSensitive: false,
      ),
      '',
    );
  }

  final isEmail = lowerLabel.contains('email') ||
      lowerLabel.contains('e-mail');

  if (isEmail) {
    answer = answer
        .replaceAll(
      RegExp(r'\s+at the rate\s+', caseSensitive: false),
      '@',
    )
        .replaceAll(
      RegExp(r'\s+at sign\s+', caseSensitive: false),
      '@',
    )
        .replaceAll(
      RegExp(r'\s+at\s+', caseSensitive: false),
      '@',
    )
        .replaceAll(
      RegExp(r'\s+dot\s+', caseSensitive: false),
      '.',
    )
        .replaceAll(
      RegExp(r'\s+underscore\s+', caseSensitive: false),
      '_',
    )
        .replaceAll(
      RegExp(r'\s+hyphen\s+', caseSensitive: false),
      '-',
    )
        .replaceAll(' ', '')
        .toLowerCase();
  }

  return answer.trim();
}
class QuestionsPage extends StatefulWidget {
  const QuestionsPage({
    super.key,
    required this.languageName,
    required this.languageCode,
    required this.answers,
    required this.recognizedText,
    required this.imagePath,
    required this.formLanguageCode,
  });

  final String languageName;
  final String languageCode;
  final List<FormAnswer> answers;
  final String recognizedText;
  final String imagePath;
  final String formLanguageCode;
  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
final FlutterTts tts = FlutterTts();
final stt.SpeechToText speech = stt.SpeechToText();

int currentQuestion = 0;
bool listening = false;
bool awaitingConfirmation = false;
String pendingAnswer = '';
  @override
  void dispose() {
    tts.stop();
    speech.stop();
    super.dispose();
  }

Future<void> askQuestion() async {
  if (widget.answers.isEmpty) return;

  await tts.setLanguage(widget.languageCode);
  print('TTS languages: ${await tts.getLanguages}');
  print('TTS voices: ${await tts.getVoices}');
  print('Selected TTS language: ${widget.languageCode}');
  print('Available TTS languages: ${await tts.getLanguages}');
  await tts.setSpeechRate(0.38);
  await tts.setPitch(1.0);

  var question = widget.answers[currentQuestion].question;
  print('QUESTION TEXT: $question');

  if (widget.languageCode == 'te-IN') {
    question = question
        .replaceAll(
      RegExp(r'\bemail\b', caseSensitive: false),
      'ఈ మెయిల్',
    )
        .replaceAll(
      RegExp(r'\bemployment\b', caseSensitive: false),
      'ఎంప్లాయ్‌మెంట్',
    )
        .replaceAll(
      RegExp(r'\bemployee\b', caseSensitive: false),
      'ఎంప్లాయీ',
    )
        .replaceAll(
      RegExp(r'\bapplication\b', caseSensitive: false),
      'అప్లికేషన్',
    );
  }

  await tts.speak(question);
}
Future<void> recordAnswer() async {
  final available = await speech.initialize(
    onStatus: (value) {
      if (value == 'notListening' && mounted) {
        setState(() => listening = false);
      }
    },
    onError: (error) {
      if (mounted) {
        setState(() => listening = false);
        showMessage('Speech recognition error: ${error.errorMsg}');
      }
    },
  );

  if (!mounted) return;

  if (!available) {
    showMessage(
      'Speech recognition is unavailable. '
          'Check that speech services are enabled on your phone.',
    );
    return;
  }

  setState(() => listening = true);

  await speech.listen(
    listenOptions: stt.SpeechListenOptions(
      localeId: widget.languageCode,
      listenMode: stt.ListenMode.dictation,
      partialResults: true,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
    ),
    onResult: (result) async {
      if (!mounted) return;

      final spoken = result.recognizedWords.trim();
      if (spoken.isEmpty || !result.finalResult) return;

      setState(() => listening = false);

      final answerIndex = currentQuestion;
      final item = widget.answers[answerIndex];

      String finalAnswer = extractAnswer(item.label, spoken);
      final label = item.label.toLowerCase();

      final isPersonalDetail =
          label.contains('name') ||
              label.contains('email') ||
              label.contains('e-mail') ||
              label.contains('phone') ||
              label.contains('mobile') ||
              label.contains('number');

      final sourceLanguage =
      _getTranslateLanguage(widget.languageCode);
      final targetLanguage =
      _getTranslateLanguage(widget.formLanguageCode);

      if (sourceLanguage != targetLanguage && !isPersonalDetail) {
        final translator = OnDeviceTranslator(
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
        );

        try {
          finalAnswer = await translator.translateText(finalAnswer);
        } catch (e) {
          if (mounted) {
            showMessage('Translation failed. Please try again.');
          }
          return;
        } finally {
          await translator.close();
        }
      }

      if (!mounted) return;

      setState(() {
        pendingAnswer = finalAnswer;
        awaitingConfirmation = true;
      });

      await tts.setLanguage(widget.languageCode);
      await tts.speak(
        'I heard: $finalAnswer. Please check the answer on the screen.',
      );
      await tts.setLanguage(widget.formLanguageCode);
      await tts.speak(
        '${uiText(widget.languageCode, 'heardAnswer')}'
            '$finalAnswer. '
            '${uiText(widget.languageCode, 'confirmAnswer')}',
      );
    },
  );
}
  void showMessage(String message) {
    Future<void> recordAnswer() async {
      // Your existing recordAnswer code stays here.
    }

    String extractAnswer(String label, String spoken) {
      var answer = spoken.trim();
      final lowerLabel = label.toLowerCase();

      if (lowerLabel.contains('name')) {
        answer = answer.replaceFirst(
          RegExp(
            r"^(my name is|i am|i'm)\s+",
            caseSensitive: false,
          ),
          '',
        );
      }

      final isEmail = lowerLabel.contains('email') ||
          lowerLabel.contains('e-mail');

      if (isEmail) {
        answer = answer
            .replaceAll(
          RegExp(r'\s+at the rate\s+', caseSensitive: false),
          '@',
        )
            .replaceAll(
          RegExp(r'\s+at sign\s+', caseSensitive: false),
          '@',
        )
            .replaceAll(
          RegExp(r'\s+at\s+', caseSensitive: false),
          '@',
        )
            .replaceAll(
          RegExp(r'\s+dot\s+', caseSensitive: false),
          '.',
        )
            .replaceAll(
          RegExp(r'\s+underscore\s+', caseSensitive: false),
          '_',
        )
            .replaceAll(
          RegExp(r'\s+hyphen\s+', caseSensitive: false),
          '-',
        )
            .replaceAll(' ', '')
            .toLowerCase();
      }

      return answer.trim();
    }
    void showMessage(String message) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> nextQuestion() async {
    await speech.stop();
    if (!mounted) return;
    if (widget.answers[currentQuestion].answer.trim().isEmpty) {
      final message = uiText(
        widget.languageCode,
        'answerRequired',
      );

      showMessage(message);
      await tts.speak(message);
      return;
    }
    if (currentQuestion < widget.answers.length - 1) {
      setState(() => currentQuestion++);
      await askQuestion();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ReviewPage(
            languageName: widget.languageName,
            answers: widget.answers,
            imagePath: widget.imagePath,
          ),
        ),
      );
    }
  }
Future<void> skipQuestion() async {
  await speech.stop();
  await tts.stop();

  if (!mounted) return;

  setState(() {
    awaitingConfirmation = false;
    pendingAnswer = '';
    listening = false;

    if (currentQuestion < widget.answers.length - 1) {
      currentQuestion++;
    }
  });

  if (currentQuestion < widget.answers.length - 1) {
    await askQuestion();
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewPage(
          languageName: widget.languageName,
          answers: widget.answers,
          imagePath: widget.imagePath,
        ),
      ),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    if (widget.answers.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Answer Questions • ${widget.languageName}'),
        ),
        body: const Center(
          child: Text('No questions were found.'),
        ),
      );
    }

    final item = widget.answers[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text('Answer Questions • ${widget.languageName}'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Question ${currentQuestion + 1} of ${widget.answers.length}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Icon(
              Icons.record_voice_over,
              size: 70,
              color: Colors.teal,
            ),
            const SizedBox(height: 20),
            Text(
              item.question,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26),
            ),
            const SizedBox(height: 24),
            Text(
              'Answer: ${item.answer.isEmpty ? "(not answered yet)" : item.answer}',
              style: const TextStyle(fontSize: 18),
            ),
            if (awaitingConfirmation) ...[
              const SizedBox(height: 16),
              Text(
                'I heard: $pendingAnswer',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  setState(() {
                    widget.answers[currentQuestion].answer = pendingAnswer;
                    awaitingConfirmation = false;
                  });

                  await tts.speak(
                    uiText(widget.languageCode, 'answerSaved'),
                  );
                },
                icon: const Icon(Icons.check_circle),
                label: Text(uiText(widget.languageCode, 'yesCorrect')),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await tts.stop();

                  setState(() {
                    pendingAnswer = '';
                    awaitingConfirmation = false;
                  });

                  await recordAnswer();
                },
                icon: const Icon(Icons.refresh),
                label: Text(uiText(widget.languageCode, 'tryAgain')),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: askQuestion,
              icon: const Icon(Icons.volume_up),
              label:Text(uiText(widget.languageCode, 'askAloud'))
            ),
            ElevatedButton.icon(
              onPressed: listening ? null : recordAnswer,
              icon: const Icon(Icons.mic),
              label: Text(uiText(widget.languageCode, 'speakAnswer')),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: nextQuestion,
              child: Text(
                currentQuestion == widget.answers.length - 1
                    ? uiText(widget.languageCode, 'finish')
                    : uiText(widget.languageCode, 'saveNext'),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: skipQuestion,
              icon: const Icon(Icons.skip_next),
              label: Text(
                uiText(widget.languageCode, 'skipQuestion'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewPage extends StatelessWidget {
const ReviewPage({
super.key,
required this.languageName,
required this.answers,
required this.imagePath,
});

final String languageName;
final List<FormAnswer> answers;
final String imagePath;

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('Review Answers • $languageName'),
),
body: ListView(
padding: const EdgeInsets.all(20),
children: [
LayoutBuilder(
builder: (context, constraints) {
return FutureBuilder<Size>(
future: _getImageSize(),
builder: (context, snapshot) {
if (!snapshot.hasData) {
return const Center(
child: CircularProgressIndicator(),
);
}

final originalSize = snapshot.data!;
final displayWidth = constraints.maxWidth;
final scale = displayWidth / originalSize.width;
final displayHeight = originalSize.height * scale;

return InteractiveViewer(
minScale: 1,
maxScale: 4,
child: SizedBox(
width: displayWidth,
height: displayHeight,
child: Stack(
children: [
Image.file(
File(imagePath),
width: displayWidth,
height: displayHeight,
fit: BoxFit.fill,
),
for (final item in answers)
if (item.answer.isNotEmpty &&
item.x != null &&
item.y != null)
Positioned(
left: item.x! * scale,
top: item.y! * scale,
child: Container(
padding: const EdgeInsets.all(2),
color: Colors.white,
child: Text(
item.answer,
style: const TextStyle(
color: Colors.blue,
fontSize: 12,
),
),
),
),
],
),
),
);
},
);
},
),
const SizedBox(height: 16),
const Text(
'Check your answers',
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 12),
for (final item in answers)
Card(
child: ListTile(
title: Text(item.label),
subtitle: Text(
item.answer.isEmpty ? 'Not answered' : item.answer,
),
),
),
const SizedBox(height: 12),
const Text(
'Review the answers before saving your form.',
),
const SizedBox(height: 20),
ElevatedButton(
onPressed: () => Navigator.popUntil(
context,
(route) => route.isFirst,
),
child: const Text('Back to Home'),
),
],
),
);
}
Future<Size> _getImageSize() async {
final bytes = await File(imagePath).readAsBytes();
final codec = await instantiateImageCodec(bytes);
final frame = await codec.getNextFrame();
final image = frame.image;

return Size(
image.width.toDouble(),
image.height.toDouble(),
);
}
}