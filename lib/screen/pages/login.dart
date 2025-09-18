import 'dart:convert';
import 'package:adesa/screen/widgets/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:adesa/core/config/enviroments.dart';
import 'package:adesa/data/services/auth.service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isRegister = false;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      if (!mounted) return;
      showCustomModalAlert(context, "Debes ingresar correo y contraseña");
      return;
    }

    try {
      setState(() => isLoading = true);
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text,
          "password": passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["token"] == null) {
          throw Exception("No se recibió un token en la respuesta");
        }

        String token = data["token"];
        await AuthStorage.saveToken(token);

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, "/home");
      } else if (response.statusCode == 401) {
        if (!mounted) return;
        showCustomModalAlert(context, "Credenciales inválidas");
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error en el servidor (${response.statusCode})"),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error de conexión: $e")));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> register() async {}

  void showCustomModalAlert(
    BuildContext context,
    String message, {
    Color bgColor = Colors.white,
    IconData icon = Icons.error,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.only(top: 50, left: 40, right: 40),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blueAccent, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.blueAccent),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showStyledSnackBar(
    BuildContext context,
    String message, {
    Color bgColor = Colors.redAccent,
    IconData icon = Icons.error,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 3),
        //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.only(
          top:
              MediaQuery.of(context).padding.top +
              10, // Justo debajo del status bar
          left: 20,
          right: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //appBar: CustomAppBar(title: "Barri Boy´s"),
      body: BaseScreen(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 350),
                  child: Column(
                    children: [
                      SizedBox(height: 120),
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/img/logoAAB.png'),
                      ),
                      SizedBox(height: 80),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Correo",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isLoading ? null : login,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 40),
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3, // Grosor del círculo
                                ),
                              )
                            : Text(
                                "Iniciar Sesión",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "¿Olvidaste tu contraseña?",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 170),
                      ElevatedButton(
                        //onPressed: isLoading ? null : login,
                        onPressed: isRegister ? null : register,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 40),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        child: isRegister
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.blueAccent,
                                  strokeWidth: 3, // Grosor del círculo
                                ),
                              )
                            : Text(
                                "Crear cuenta nueva",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/img/logoAAB.png',
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Barri Boy´s ©.",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
