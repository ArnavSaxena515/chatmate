// The authentication form widget with all the required fields, methods and the defined enum
// for authentication mode switching

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'form_input.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key, required this.submitMethod}) : super(key: key);
  final void Function(
      {required String email, required String password, required String username, required authMode mode, required BuildContext ctx, XFile? userImageFile}) submitMethod;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _authFormKey = GlobalKey<FormState>();

  //Text field focus nodes for smooth form interaction
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  // form properties to be sent, stored or retrieved as necessary
  String _username = "", _emailAddress = "", _password = "";

  //Auth mode: initially login
  authMode authenticationMode = authMode.LOGIN;

  //animation configurations
  final int _animationDurationInMilliseconds = 150;

  bool _hidePassword = true;
  bool _isLoading = false;

  // image to upload for new users signing up
  XFile? _userImage;

  void _pickedImage(XFile? image) {
    _userImage = image;
  }

  // submit method for the form
  void _submitData() {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    if (_userImage == null && authenticationMode == authMode.SIGNUP) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Theme.of(context).errorColor, content: const Text("Please select an image")));
      setState(() => _isLoading = false);
      return;
    }
    if (_authFormKey.currentState!.validate()) {
      widget.submitMethod(
          // trim method to remove excess white spaces from the strings being submitted
          email: _emailAddress.trim(),
          password: _password.trim(),
          username: _username.trim(),
          mode: authenticationMode,
          ctx: context,
          userImageFile: _userImage);
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(13),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: AnimatedContainer(
          height: authenticationMode == authMode.SIGNUP ? mediaQueryData.size.height / 1.8 : mediaQueryData.size.height / 3.0,
          constraints: BoxConstraints(
            minHeight: authenticationMode == authMode.SIGNUP ? mediaQueryData.size.height / 1.8 : mediaQueryData.size.height / 3.0,
            //minHeight: _heightAnimation.value.height,
          ),
          duration: Duration(milliseconds: _animationDurationInMilliseconds),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _authFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // if user is in sign up mode, prompt up for an image prompt where user can add their image
                    if (authenticationMode == authMode.SIGNUP)
                      ImageHandler(
                        imagePasser: _pickedImage,
                      ),
                    // field for user name
                    if (authenticationMode == authMode.SIGNUP)
                      FormInput(
                        key: const ValueKey("username"),
                        fieldFocusNode: _userNameFocusNode,
                        label: "Username",
                        nextFieldFocusNode: _emailFocusNode,
                        validation: (String? value) {
                          //final regEx = RegExp(r'^[a-zA-Z0-9]([._-](?![._-])|[a-zA-Z0-9]){3,18}[a-zA-Z0-9]');
                          if (value!.length < 3) {
                            return "Username must be longer than 3 characters";
                          }
                          return null;
                          //can replace validation logic as suitable
                        },
                        onChanged: (String? value) {
                          _username = value ?? "";
                        },
                        onSaved: (String? value) {
                          _username = value ?? "";
                        },
                      ),
                    //todo: add email verification, OTP etc
                    //field for email verification
                    FormInput(
                      key: const ValueKey("email"),
                      fieldFocusNode: _emailFocusNode,
                      nextFieldFocusNode: _passwordFocusNode,
                      validation: (String? value) {
                        if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value!)) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                      label: "Email address",
                      onChanged: (String? value) {
                        _emailAddress = value ?? "";
                      },
                      onSaved: (String? value) {
                        _emailAddress = value ?? "";
                      },
                    ),
                    // Password form field
                    FormInput(
                      key: const ValueKey("password"),
                      fieldFocusNode: _passwordFocusNode,
                      nextFieldFocusNode: _confirmPasswordFocusNode,
                      obscureText: _hidePassword,
                      // if auth mode is login, execute submit function otherwise, use the default onFieldSubmit method
                      // that changes the focus node on clicking enter
                      onFieldSubmit: authenticationMode == authMode.LOGIN
                          ? (_) {
                              _submitData();
                            }
                          : null,
                      validation: (String? value) {
                        //password validation logic
                        if (value!.length < 6) {
                          return "Password length should be at least than 6 characters";
                        }
                        return null;
                      },
                      onChanged: (String? value) {
                        _password = value ?? "";
                      },
                      onSaved: (String? value) {
                        _password = value ?? "";
                      },
                      inputDecoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: TextButton(
                          child: Text(_hidePassword ? "Show password" : "Hide Password"),
                          onPressed: () {
                            setState(() => _hidePassword = !_hidePassword);
                          },
                        ),
                      ),
                    ),
                    //confirm password field
                    if (authenticationMode == authMode.SIGNUP)
                      FormInput(
                        key: const ValueKey("confirm password"),
                        fieldFocusNode: _confirmPasswordFocusNode,
                        obscureText: _hidePassword,
                        validation: (String? value) {
                          //match password logic
                          if (value != _password) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                        onFieldSubmit: (_) => _submitData(),
                        inputDecoration: InputDecoration(
                          labelText: "Confirm Password",
                          suffixIcon: TextButton(
                            child: Text(_hidePassword ? "Show password" : "Hide Password"),
                            onPressed: () {
                              setState(() => _hidePassword = !_hidePassword);
                            },
                          ),
                        ),
                        onChanged: (String? value) {},
                        onSaved: (String? value) {},
                      ),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            child: Text(authenticationMode == authMode.LOGIN ? "Login" : "Sign Up"),
                            onPressed: () {
                              _submitData();
                            },
                          ),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : TextButton(
                            child: Text("Change to ${authenticationMode == authMode.SIGNUP ? "login" : "sign up"}"),
                            onPressed: () {
                              // toggle authentication modes
                              setState(() => authenticationMode = authenticationMode == authMode.SIGNUP ? authMode.LOGIN : authMode.SIGNUP);
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum authMode {
  // ignore: constant_identifier_names
  LOGIN,
  // ignore: constant_identifier_names
  SIGNUP
}

class ImageHandler extends StatefulWidget {
  // helps select image and pass it to the auth form via a function it receives as a named argument.
  const ImageHandler({Key? key, required this.imagePasser}) : super(key: key);

  final void Function(XFile? imageFile) imagePasser; // function receives a file as an argument

  @override
  State<ImageHandler> createState() => _ImageHandlerState();
}

class _ImageHandlerState extends State<ImageHandler> {
  bool _isImagePicked = false;
  final _imagePicker = ImagePicker();
  XFile? pickedFile;

  void _pickImage() async {
    ImageSource _imageSource = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Select image source"),
              content: const Text("Please choose an image source"),
              actions: [
                TextButton.icon(
                  icon: const Icon(Icons.camera),
                  onPressed: () {
                    Navigator.of(context).pop(ImageSource.camera);
                  },
                  label: const Text("Camera"),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.image),
                  onPressed: () {
                    Navigator.of(context).pop(ImageSource.gallery);
                  },
                  label: const Text("Gallery"),
                ),
              ],
            ));
    try {
      pickedFile = await _imagePicker.pickImage(
        source: _imageSource,
        imageQuality: 50,
        maxWidth: 150,
      );
      setState(() {
        if (pickedFile != null) {
          _isImagePicked = true;
        }
      });
      widget.imagePasser(pickedFile);
    } catch (error) {
      var message = "Something went wrong\n";
      message += error.toString();
      ScaffoldMessenger.of(context).dispose();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          maxRadius: 40,
          backgroundImage: _isImagePicked
              ? Image.file(
                  File(pickedFile!.path),
                  fit: BoxFit.cover,
                ).image
              : null,
          child: Visibility(
            visible: !_isImagePicked,
            child: Icon(
              Icons.person,
              size: 50,
              color: Theme.of(context).canvasColor,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: _pickImage,
          label: const Text("Add Image"),
          icon: const Icon(Icons.image),
        ),
      ],
    );
  }
}
