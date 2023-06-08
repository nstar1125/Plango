import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plango/screens/createPlanScreens/placeDetailPage.dart';
import 'package:plango/screens/createPlanScreens/preferencePage.dart';
import 'package:plango/screens/createPlanScreens/showPlacesPage.dart';
import 'package:plango/screens/loginScreens/initialPage.dart';
import 'package:plango/screens/loginScreens/makeUserPage.dart';
import 'package:plango/screens/loginScreens/signInPage.dart';
import 'package:plango/screens/loginScreens/signUpPage.dart';
import 'package:plango/screens/loginScreens/splashPage.dart';
import 'package:plango/screens/homeScreens/navigationBarPage.dart';
import 'package:plango/utilities/firebase_options.dart';
import 'package:plango/utilities/getAPI.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AndroidOptions _getAndroidOptions() => const AndroidOptions( //secure storage 사용 위한 옵션 초기화
    encryptedSharedPreferences: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plango',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(), //스플래시화면
        '/toInitialPage': (context) => const InitialPage(), //시작 페이지 이동
        '/toSignInPage': (context) => const SignInPage(), //로그인 페이지 이동
        '/toSignUpPage': (context) => const SignUpPage(), //계정생성 페이지 이동
        '/toMakeUserPage': (context) => const MakeUserPage(), //유저 정보 작성 페이지 이동
        '/toNavigationBarPage': (context) => const NavigationBarPage(), //네비게이션 바 페이지 이동
        '/toPreferencePage': (context) => const PreferencePage(), //여행 스타일 설정 페이지 이동
        '/toGetAPIPage' : (context) => const GetAPI(),
        '/toShowPlacesPage' : (context) => const ShowPlacesPage(),
        '/toPlaceDetailPage' : (context) => const PlaceDetailPage(),

      }
    );
  }
}