import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
            height: size.height,
            width: size.width,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                      top: size.height * 0.20,
                      child: const Center(
                        child: Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 75,
                          ),
                        ),
                      )),
                  Positioned(
                      top: size.height * 0.33,
                      child: const Center(
                        child: Text(
                          'User X',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      )),
                  Positioned(
                    top: size.height * 0.60,
                    child: const Center(child: SizedBox(child: CircularProgressIndicator())),
                  ),
                  Positioned(
                    top: size.height * 0.70,
                    child: Center(
                      child: TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: SizedBox(
                            child:Row(
                              children: const [
                                Icon(Icons.arrow_back),
                                Text('Home')
                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
