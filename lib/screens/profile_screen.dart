import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/services/authentication_service.dart';
import 'package:todo_app/state/providers/user_provider.dart';
import 'package:todo_app/widgets/Modal/add_task.dart';
import 'package:todo_app/widgets/Modal/pick_image.dart';
import 'package:todo_app/widgets/bottom_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _MyProfileWidgetState();
}

class _MyProfileWidgetState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(31, 163, 163, 163),
        title: const Center(child: Text('Profile')),
      ),
      body: Consumer<UserInformationProvider>(
        builder: (context, userInfo, child) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(60)),
                child: userInfo.user?.photoURL == null
                    ? const CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 60,
                      )
                    : CircleAvatar(
                        radius: 60,
                        child: ClipOval(
                          child: Image.network(
                            userInfo.user?.photoURL ?? '',
                            width: 120, // Set the width to twice the radius
                            height: 120, // Set the height to twice the radius
                            fit: BoxFit
                                .cover, // This ensures the image covers the oval shape
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.only(top: 8),
                child: Text(
                  userInfo.user?.displayName ?? 'User Name',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTextButton('5 Task left', Colors.white),
                  _buildTextButton('10 Task done', Colors.white),
                ],
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Settings'),
              _buildListTile(
                  'App Setting',
                  'lib/resources/assets/svg/settings.svg',
                  context,
                  () => {},
                  ''),
              _buildSectionTitle('Account'),
              _buildListTile(
                  'Change Account Name',
                  'lib/resources/assets/svg/profile.svg',
                  context,
                  _changeAccountName,
                  userInfo.user?.displayName),
              _buildListTile(
                  'Change Account Password',
                  'lib/resources/assets/svg/key.svg',
                  context,
                  _changeAccountPassword,
                  ''),
              _buildListTile(
                  'Change Account Image',
                  'lib/resources/assets/svg/len.svg',
                  context,
                  _addAccountImage,
                  ''),
              _buildSectionTitle('UpTodo'),
              _buildListTile('About Us', 'lib/resources/assets/svg/about.svg',
                  context, () => {}, ''),
              _buildListTile('FAQ', 'lib/resources/assets/svg/faq.svg', context,
                  () => {}, ''),
              _buildListTile('Help & Feedback',
                  'lib/resources/assets/svg/help.svg', context, () => {}, ''),
              _buildListTile(
                  'Support US',
                  'lib/resources/assets/svg/support.svg',
                  context,
                  () => {},
                  ''),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () => {
                    FirebaseAuth.instance.signOut(),
                    Navigator.pushReplacementNamed(context, '/login')
                  },
                  child: Row(children: [
                    SvgPicture.asset('lib/resources/assets/svg/logout.svg'),
                    const SizedBox(width: 16),
                    const Text('Logout',
                        style: TextStyle(color: Colors.red, fontSize: 16)),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTaskModal(context);
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color.fromARGB(31, 163, 163, 163),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomBar(),
    );
  }

  Widget _buildTextButton(String text, Color color) {
    return TextButton(
      onPressed: () => {},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black),
        padding: MaterialStateProperty.all(
          const EdgeInsets.only(left: 48, right: 48, top: 16, bottom: 16),
        ),
      ),
      child: Text(text, style: TextStyle(color: color)),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.topLeft,
          child: Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }

  Widget _buildListTile(String title, String iconPath, BuildContext context,
      Function dialogBuilder, String? username) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(iconPath),
                const SizedBox(width: 16),
                Text(title,
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
            InkWell(
              onTap: () => {dialogBuilder(context, username)},
              child:
                  SvgPicture.asset('lib/resources/assets/svg/rightArrow.svg'),
            )
          ],
        ),
      ],
    );
  }
}

void _addTaskModal(BuildContext context) {
  showModalBottomSheet(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext buildContext) {
        return const AddTask();
      });
}

void _addAccountImage(BuildContext context, String? username) {
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext buildContext) {
        return const PickImage();
      });
}

Future<void> _changeAccountName(BuildContext context, String? username) {
  AuthService authService = AuthService();
  TextEditingController usernameController =
      TextEditingController(text: username);
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          //backgroundColor: Colors,
          title: const Center(child: Text('Change Account Name')),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * .7,
            height: MediaQuery.of(context).size.height * .1,
            child: TextField(
              style: const TextStyle(color: Colors.black),
              controller: usernameController,
              decoration: const InputDecoration(
                hintText: 'Enter Your Username',
                hintStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.black)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.black)),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Save'),
              onPressed: () async {
                User? user =
                    await authService.updateUsername(usernameController.text);
                final userInformationProvider =
                    // ignore: use_build_context_synchronously
                    Provider.of<UserInformationProvider>(context,
                        listen: false);
                userInformationProvider.getUserInfo(user);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
    },
  );
}

Future<void> _changeAccountPassword(BuildContext context, String? username) {
  AuthService authService = AuthService();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          //backgroundColor: Colors,
          title: const Center(child: Text('Change Account Password')),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * .7,
            height: MediaQuery.of(context).size.height * .2,
            child: Column(
              children: [
                TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: oldPasswordController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Your Old Password',
                    hintStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: newPasswordController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Your New Password',
                    hintStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Save'),
              onPressed: () async {
                User? user = await authService.updatePassword(
                    oldPasswordController.text, newPasswordController.text);
                final userInformationProvider =
                    // ignore: use_build_context_synchronously
                    Provider.of<UserInformationProvider>(context,
                        listen: false);
                userInformationProvider.getUserInfo(user);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
    },
  );
}

// Future<void> _pickImage(BuildContext context, String? username) {
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//         return AlertDialog(
//           //backgroundColor: Colors,
//           title: const Center(child: Text('Change Account Password')),
//           content: SizedBox(
//             width: MediaQuery.of(context).size.width * .7,
//             height: MediaQuery.of(context).size.height * .2,
//             child: Column(
//               children: [
//                 TextButton.icon(
//                     onPressed: () => {
//                           pickImageForGallery(context),
//                           Navigator.of(context).pop(),
//                         },
//                     icon: const Icon(Icons.camera),
//                     label: const Text('Gallery'))
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               style: TextButton.styleFrom(
//                 textStyle: Theme.of(context).textTheme.labelLarge,
//               ),
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               style: TextButton.styleFrom(
//                 textStyle: Theme.of(context).textTheme.labelLarge,
//               ),
//               child: const Text('Save'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       });
//     },
//   );
// }

Future pickImageForGallery(BuildContext context) async {
  final userInformationProvider =
      // ignore: use_build_context_synchronously
      Provider.of<UserInformationProvider>(context, listen: false);
  await userInformationProvider.pickImageForGallery(context);

  //print(user);
  //userInformationProvider.getUserInfo(user);
}
