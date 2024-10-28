import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prestige_vender/firebase_options.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/view/authView/splashScreen.dart';
import 'package:prestige_vender/viewModel/searchProvider.dart';
import 'package:prestige_vender/viewModel/googleMapViewModel.dart';
import 'package:prestige_vender/viewModel/authViewModel.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';
import 'package:prestige_vender/viewModel/categoryViewModel.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';
import 'package:prestige_vender/viewModel/weeksProvider.dart';
import 'package:provider/provider.dart';



Future main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.storage.request();
 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  FirebaseMessaging.onBackgroundMessage(_onBackgroundMessageHandler);

   runApp(
    const MyApp(),
    // DevicePreview(
    //   enabled: true,
    //   tools: const [
    //     ...DevicePreview.defaultTools,
    //     // const CustomPlugin(),
    //   ],
    //   builder: (context) => 
    // ),
  );
}
@pragma('vm:entry-point')
Future<void> _onBackgroundMessageHandler(RemoteMessage message)async{
   
  await Firebase.initializeApp();
  if (kDebugMode) {
    print({"notification Vendor main :${message.notification!.title.toString()}"});
  }

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      
        ChangeNotifierProvider(
          create: (context) => UserViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(),
        ),ChangeNotifierProvider(
          create: (context) => SearchProvider(),
        ),
      
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(),
        ), 
        ChangeNotifierProvider(
          create: (context) => CategoryViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => GoogleMapViewModel(),
        ), ChangeNotifierProvider(
          create: (context) => WeeksProvider(),
        ),
       
      ],
      child: ScreenUtilInit(
       designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'Prestige Vendor',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
             primarySwatch: Colors.teal,
        colorScheme: const ColorScheme.light(
          primary: colorPrimary, // Header background color
          onPrimary: Colors.white, // Header text color
          onSurface: Colors.black, // Body text color
        ),  
            useMaterial3: true,
          ),
          home:SplashScreen(),
        );}
      ),
    );
  }
}
