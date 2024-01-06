import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gtk_flutter/profile_creation.dart';

class YearbookPage extends StatefulWidget {
  const YearbookPage({super.key});

  @override
  State<YearbookPage> createState() => _YearbookPageState();
}

class _YearbookPageState extends State<YearbookPage> {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    // The path in Firebase Storage where the yearbook images are stored
    final ListResult result = await storage.ref('yearbook 2020').listAll();

    for (var file in result.items) {
      final String url = await file.getDownloadURL();
      files.add({
        "url": url,
        "path": file.fullPath,
      });
    }

    return files;
  }

  //send image to profile page
  void _navigateToProfileCreation(BuildContext context, String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileCreationPage(imageUrl: imagePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: FutureBuilder(
        future: _loadImages(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => _navigateToProfileCreation(
                        context, snapshot.data![index]['url']),
                    child: Image.network(
                      snapshot.data![index]['url'],
                      fit: BoxFit.cover,
                    ),
                  );
                });
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return Container();
        },
      ),
    );
  }
}
