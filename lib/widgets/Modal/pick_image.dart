import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/state/providers/user_provider.dart';

class PickImage extends StatefulWidget {
  const PickImage({super.key});

  @override
  State<PickImage> createState() => _PickImageModal();
}

class _PickImageModal extends State<PickImage> {
  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
      height: MediaQuery.of(context).size.height * .2 + keyboardHeight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Center(child: Text('Change Account Image',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
            const SizedBox(
              height: 16,
            ),
            TextButton(
              
                onPressed: () => {},
                style: TextButton.styleFrom(
                  
                    minimumSize: const Size.fromHeight(50)),
                child: const Align(
                    alignment: Alignment.topLeft, child: Text('Take Picture',style: TextStyle(color: Colors.white),))),
            TextButton(
                onPressed: () => {pickImageForGallery(context), Navigator.of(context).pop(),},
                style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                child: const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Import form gallery',style: TextStyle(color: Colors.white)))),
          ],
        ),
      ),
    );
  }
}

Future pickImageForGallery(BuildContext context) async {
  final userInformationProvider =
      // ignore: use_build_context_synchronously
      Provider.of<UserInformationProvider>(context, listen: false);
  await userInformationProvider.pickImageForGallery(context);
}
