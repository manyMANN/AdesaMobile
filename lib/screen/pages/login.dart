import 'dart:convert';
import 'package:adesa/screen/widgets/bar.dart';
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

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Debes ingresar correo y contraseña")),
      );
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Credenciales inválidas")));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(title: "Barri Boy´s"),
      body: BaseScreen(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 350),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Bienvenido",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Correo",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : login, // Deshabilita el botón si está cargando
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Iniciar Sesión",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                ),
                SizedBox(height: 10),
                Text(
                  "¿Olvidaste tu contraseña?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueAccent,
                  ),
                ),

                Spacer(),

                Text(
                  "Copyright © 2025 - Barri Boys INC.",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey,
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
