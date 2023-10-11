import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
} 
//63477  4294924066 home

// import 'package:flutter/material.dart';
// import 'package:app_usage/app_usage.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   List<AppUsageInfo> _infos = [];

//   @override
//   void initState() {
//     super.initState();
//   }

//   void getUsageStats() async {
//     try {
//       DateTime endDate = DateTime.now();
//       DateTime startDate = endDate.subtract(Duration(hours: 1));
//       List<AppUsageInfo> infoList =
//           await AppUsage().getAppUsage(startDate, endDate);
//       setState(() => _infos = infoList);

//       for (var info in infoList) {
//         print(info.toString());
//       }
//     } on AppUsageException catch (exception) {
//       print(exception);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('App Usage Example'),
//           backgroundColor: Colors.green,
//         ),
//         body: ListView.builder(
//             itemCount: _infos.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                   title: Text(_infos[index].appName),
//                   trailing: Text(_infos[index].usage.toString()));
//             }),
//         floatingActionButton: FloatingActionButton(
//             onPressed: getUsageStats, child: Icon(Icons.file_download)),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_iconpicker/flutter_iconpicker.dart';

// void main() {
//   runApp(
//     const MaterialApp(
//       home: HomeScreen(),
//     ),
//   );
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
  // Icon? _icon;

  // _pickIcon() async {
  //   IconData? icon = await FlutterIconPicker.showIconPicker(context,
  //       iconPackModes: [IconPack.material]);

    
  //   setState(() {});
  //   int? codePoint = icon?.codePoint;

  //   IconData data =  IconData(codePoint ?? 0, fontFamily: 'MaterialIcons');
    
  //   _icon = Icon(data);
  //   debugPrint('Picked Icon:  $codePoint');
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: _pickIcon,
//               child: const Text('Open IconPicker'),
//             ),
//             const SizedBox(height: 10),
//             AnimatedSwitcher(
//               duration: const Duration(milliseconds: 300),
//               child: _icon ?? Container(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// void main(){
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Home(),
//     );
//   }
// }

// class Home extends StatefulWidget{
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {

//   Color mycolor = Colors.lightBlue;
//   @override
//   Widget build(BuildContext context) {
    
//     return  Scaffold(
//           appBar: AppBar( 
//              title: Text("Flutter Color Picker"),
//              backgroundColor: Colors.redAccent,
//           ),
//           body: Container(
//              color: mycolor, //background color of app from color picker
//              alignment: Alignment.center,
//              padding: EdgeInsets.all(20),
//              child: Column(
//                  children:[
//                       ElevatedButton(
//                         onPressed: (){
//                             showDialog(
//                                 context: context,
//                                 builder: (BuildContext context){
//                                   return AlertDialog(
//                                       title: Text('Pick a color!'),
//                                       content: SingleChildScrollView(
//                                         child: ColorPicker(
//                                           pickerColor: mycolor, //default color
//                                           onColorChanged: (Color color){ //on color picked
//                                               setState(() {
//                                                 mycolor = color;
//                                               });
//                                           }, 
//                                         ),
//                                       ),
//                                       actions: <Widget>[
//                                         ElevatedButton(
//                                           child: const Text('DONE'),
//                                           onPressed: () {
//                                             Navigator.of(context).pop(); //dismiss the color picker
//                                           },
//                                         ),
//                                       ],
//                                   );
//                               }
//                             ); 
                              
//                         },
//                         child: Text("Default Color Picker"),
//                     ),


//                     ElevatedButton(
//                         onPressed: (){
//                           showDialog(
//                               context: context,
//                               builder: (BuildContext context){
//                                 return AlertDialog(
//                                     title: Text('Pick a color!'),
//                                     content: SingleChildScrollView(
//                                       child: MaterialPicker(
//                                         pickerColor: mycolor, //default color
//                                         onColorChanged: (Color color){ //on color picked
//                                            setState(() {
//                                             debugPrint('color :   $color');
//                                               mycolor = color;
//                                            });
//                                         }, 
//                                       ),
//                                     ),
//                                     actions: <Widget>[
//                                       ElevatedButton(
//                                         child: const Text('DONE'),
//                                         onPressed: () {
//                                           Navigator.of(context).pop(); //dismiss the color picker
//                                         },
//                                       ),
//                                     ],
//                                 );
//                             }
//                           ); 
                              
//                         },
//                         child: Text("Material Color Picker"),
//                     ),


                    // ElevatedButton(
                    //     onPressed: (){
                    //       showDialog(
                    //           context: context,
                    //           builder: (BuildContext context){
                    //             return AlertDialog(
                    //                 title: Text('Pick a color!'),
                    //                 content: SingleChildScrollView(
                    //                   child: BlockPicker(
                    //                     pickerColor: mycolor, //default color
                    //                     onColorChanged: (Color color){ //on color picked
                    //                     int data = color.value;
                                        
                    //                        debugPrint('color :   $color $data');
                    //                        setState(() {
                    //                           mycolor = Color(data);
                    //                        });
                    //                     }, 
                    //                   ),
                    //                 ),
                    //                 actions: <Widget>[
                    //                   ElevatedButton(
                    //                     child: const Text('DONE'),
                    //                     onPressed: () {
                    //                       Navigator.of(context).pop(); //dismiss the color picker
                    //                     },
                    //                   ),
                    //                 ],
                    //             );
                    //         }
                    //       ); 
                              
                    //     },
                    //     child: Text("Block Color Picker"),
                    // ),


//                     ElevatedButton(
//                         onPressed: (){
//                           showDialog(
//                               context: context,
//                               builder: (BuildContext context){
//                                 return AlertDialog(
//                                     title: Text('Pick a color!'),
//                                     content: SingleChildScrollView(
//                                       child: MultipleChoiceBlockPicker(
//                                         pickerColors: [Colors.red, Colors.orange], //default color
//                                         onColorsChanged: (List<Color> colors){ //on colors picked
//                                            print(colors);
//                                         }, 
//                                       ),
//                                     ),
//                                     actions: <Widget>[
//                                       ElevatedButton(
//                                         child: const Text('DONE'),
//                                         onPressed: () {
//                                           Navigator.of(context).pop(); //dismiss the color picker
//                                         },
//                                       ),
//                                     ],
//                                 );
//                             }
//                           ); 
                              
//                         },
//                         child: Text("Multiple Choice Color Picker"),
//                     ),

                    
//                  ]
//              )
//           )
//        );
//   }
// }

// import 'dart:async';
// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';

// Future<void> main() async {
//   // Ensure that plugin services are initialized so that `availableCameras()`
//   // can be called before `runApp()`
//   WidgetsFlutterBinding.ensureInitialized();

//   // Obtain a list of the available cameras on the device.
//   final cameras = await availableCameras();

//   // Get a specific camera from the list of available cameras.
//   final firstCamera = cameras.first;

//   runApp(
//     MaterialApp(
//       theme: ThemeData.dark(),
//       home: TakePictureScreen(
//         // Pass the appropriate camera to the TakePictureScreen widget.
//         camera: firstCamera,
//       ),
//     ),
//   );
// }

// // A screen that allows users to take a picture using a given camera.
// class TakePictureScreen extends StatefulWidget {
//   const TakePictureScreen({
//     super.key,
//     required this.camera,
//   });

//   final CameraDescription camera;

//   @override
//   TakePictureScreenState createState() => TakePictureScreenState();
// }

// class TakePictureScreenState extends State<TakePictureScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;

//   @override
//   void initState() {
//     super.initState();
//     // To display the current output from the Camera,
//     // create a CameraController.
//     _controller = CameraController(
//       // Get a specific camera from the list of available cameras.
//       widget.camera,
//       // Define the resolution to use.
//       ResolutionPreset.medium,
//     );

//     // Next, initialize the controller. This returns a Future.
//     _initializeControllerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     // Dispose of the controller when the widget is disposed.
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Take a picture')),
//       // You must wait until the controller is initialized before displaying the
//       // camera preview. Use a FutureBuilder to display a loading spinner until the
//       // controller has finished initializing.
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             // If the Future is complete, display the preview.
//             return CameraPreview(_controller);
//           } else {
//             // Otherwise, display a loading indicator.
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         // Provide an onPressed callback.
//         onPressed: () async {
//           // Take the Picture in a try / catch block. If anything goes wrong,
//           // catch the error.
//           try {
//             // Ensure that the camera is initialized.
//             await _initializeControllerFuture;

//             // Attempt to take a picture and get the file `image`
//             // where it was saved.
//             final image = await _controller.takePicture();

//             if (!mounted) return;

//             // If the picture was taken, display it on a new screen.
//             await Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => DisplayPictureScreen(
//                   // Pass the automatically generated path to
//                   // the DisplayPictureScreen widget.
//                   imagePath: image.path,
//                 ),
//               ),
//             );
//           } catch (e) {
//             // If an error occurs, log the error to the console.
//             print(e);
//           }
//         },
//         child: const Icon(Icons.camera_alt),
//       ),
//     );
//   }
// }

// // A widget that displays the picture taken by the user.
// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;

//   const DisplayPictureScreen({super.key, required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Display the Picture')),
//       // The image is stored as a file on the device. Use the `Image.file`
//       // constructor with the given path to display the image.
//       body: Image.file(File(imagePath)),
//     );
//   }
// }

// my_flutter_app/
//   ├── lib/
//   │   ├── main.dart                   # Entry point of your app
//   │   ├── app.dart                    # Main application configuration
//   │   ├── routes.dart                 # Route definitions
//   │   ├── utils/                      # Utility functions and classes
//   │   │   ├── api_client.dart         # API client for making network requests
//   │   │   ├── constants.dart          # App-wide constants
//   │   │   └── helpers.dart            # Helper functions
//   │   ├── models/                     # Data models
//   │   │   ├── user.dart               # Example: User model
//   │   │   ├── post.dart               # Example: Post model
//   │   ├── services/                   # Business logic services
//   │   │   ├── authentication_service.dart # Authentication logic
//   │   │   ├── api_service.dart        # Service for API interaction
//   │   ├── screens/                    # Screens or pages
//   │   │   ├── home_screen.dart        # Example: Home screen
//   │   │   ├── profile_screen.dart     # Example: Profile screen
//   │   │   ├── login_screen.dart       # Example: Login screen
//   │   ├── widgets/                    # Reusable UI components
//   │   │   ├── custom_button.dart      # Example: Custom button widget
//   │   │   ├── loading_spinner.dart    # Example: Loading spinner widget
//   │   ├── state/                      # State management
//   │   │   ├── providers/              # Provider package for state management
//   │   │   │   ├── user_provider.dart  # Example: User provider
//   │   │   ├── blocs/                  # Bloc package for state management (optional)
//   │   │   │   ├── authentication_bloc.dart # Example: Authentication bloc
//   │   │   ├── cubits/                # Cubit package for state management (optional)
//   │   │   │   ├── counter_cubit.dart  # Example: Counter cubit
//   │   ├── resources/                  # Assets, fonts, and translations
//   │   │   ├── assets/                 # Images, fonts, etc.
//   │   │   ├── lang/                   # Localization files
//   │   ├── main_dev.dart               # Main entry point for development environment
//   │   ├── main_prod.dart              # Main entry point for production environment
//   ├── test/                           # Unit and widget tests
//   ├── pubspec.yaml                    # Flutter package dependencies
//   ├── README.md                       # Project documentation
//   └── .gitignore                      # Git ignore file
