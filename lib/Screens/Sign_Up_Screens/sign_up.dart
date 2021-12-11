import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Constants/ui_styles.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/email_password_validators.dart";
import "package:tumbler/Methods/get_all_blogs.dart";
import "package:tumbler/Methods/initializer.dart";
import "package:tumbler/Methods/local_db.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Screens/Intro_Carousel/intro_carousel.dart";
import "package:tumbler/Screens/Log_In_Screens/log_in.dart";

/// Sign Up Page
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController _nameController;
  late TextEditingController _passController;
  late TextEditingController _emailController;
  late GlobalKey<FormState> _formKey;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _passController = TextEditingController();
    _emailController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Form form() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              validator: emailValidator,
              controller: _emailController,
              onChanged: (final String s) => setState(() {}),
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: formEnabledFieldBorderStyle,
                focusedBorder: formFocusedFieldBorderStyle,
                hintStyle: const TextStyle(color: Colors.white30),
                hintText: "Email",
                suffixIcon: _emailController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () =>
                            setState(() => _emailController.clear()),
                        color: Colors.white30,
                      )
                    : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextFormField(
              validator: passValidator,
              controller: _passController,
              onChanged: (final String s) => setState(() {}),
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.white),
              obscureText: _obscureText,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  color: Colors.white,
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                enabledBorder: formEnabledFieldBorderStyle,
                focusedBorder: formFocusedFieldBorderStyle,
                hintStyle: const TextStyle(color: Colors.white30),
                hintText: "Password",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: _nameController,
              onChanged: (final String s) => setState(() {}),
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: formEnabledFieldBorderStyle,
                focusedBorder: formFocusedFieldBorderStyle,
                hintStyle: const TextStyle(color: Colors.white30),
                hintText: "Name",
                suffixIcon: _nameController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () =>
                            setState(() => _nameController.clear()),
                        color: Colors.white30,
                      )
                    : null,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Call API Sign Up Function
  ///
  /// Get the [response] from the [Api.signU] function
  /// and sets [User.name], [User.userID], [User.blogAvatar]
  /// , [User.accessToken] from the database if no error happened.
  /// Call API Sign Up Function
  ///
  /// Get the [response] from the [Api.signU] function
  /// and sets [User.name], [User.id], [User.blogAvatar]
  /// , [User.accessToken] from the database if no error happened.
  Future<void> signUp() async {
    final Map<String, dynamic> response = await Api().signUp(
      _nameController.text,
      _passController.text,
      _emailController.text,
      User.age,
    );
    if (response["meta"]["status"] == "200") {
      User.email = response["response"]["email"];
      User.userID = response["response"]["id"].toString();
      User.accessToken = response["response"]["access_token"];
      // the index of the primary user
      User.currentProfile = 0;
      await LocalDataBase.instance.insertIntoUserTable(
        User.userID,
        User.email,
        User.age,
        User.accessToken,
        User.currentProfile,
      );

      // Note: May be it is not wanted in sign up
      // he only has one blog
      if (await fillUserBlogs()) {
        await initializeUserBlogs();
        await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<IntroCarousel>(
            builder: (final BuildContext context) => IntroCarousel(),
          ),
          (final Route<dynamic> route) => false,
        );
      } else {
        await Fluttertoast.showToast(
          msg: "Failed to get your blogs",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16,
        );
      }
    } else {
      await Fluttertoast.showToast(
        msg: response["meta"]["msg"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16,
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    final AppBar appBar = AppBar(
      backgroundColor: appBackgroundColor,
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await signUp();
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                "Done",
                style: TextStyle(
                  fontSize: 15,
                  color: (_nameController.text.isEmpty ||
                          _emailController.text.isEmpty ||
                          _passController.text.isEmpty)
                      ? Colors.blue.withOpacity(0.5)
                      : Colors.blue,
                ),
              ),
            ),
          ),
        )
      ],
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: appBackgroundColor,
        appBar: appBar,
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.vertical,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                Text(
                  "What Should we call you?",
                  style: titleTextStyle,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 75, vertical: 10),
                  child: Text(
                    """
You'll need a name to make your own posts, customize your blog, and message people.""",
                    style: subTitleTextStyle,
                    textAlign: TextAlign.justify,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: form(),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 19,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<LogIN>(
                                builder: (final BuildContext context) =>
                                    LogIN(),
                              ),
                            );
                          },
                          child: const Text(
                            "Log in",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 19,
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const Text(
                          "Privacy dashboard",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 19,
                            fontWeight: FontWeight.w300,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const SizedBox(height: 20)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
