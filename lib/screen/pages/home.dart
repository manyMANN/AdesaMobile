import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:adesa/screen/widgets/bar.dart';
import 'package:adesa/screen/navigation/adesa_nav_bar.dart';
import 'package:adesa/data/services/auth.service.dart';
import 'package:adesa/screen/pages/login.dart';
import 'package:adesa/screen/widgets/base_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _token = '';

  final List<Widget> _pages = const [
    Center(child: Text('Pedidos')),
    Center(child: Text('Clientes y Proveedores')),
    Center(child: Text('Catálogo')),
    Center(child: Text('Finanzas')),
    Center(child: Text('Menú')),
  ];

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    String? token = await AuthStorage.getToken();

    if (token == null || token.isEmpty) {
      // Redirigir al login si no hay token
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
        );
      });
    } else {
      setState(() {
        _token = token;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Future<void> _logout() async {
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Cerrar sesión?"),
        content: const Text("¿Estás seguro de que deseas cerrar sesión?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Sí"),
          ),
        ],
      ),
    );

    if (confirmLogout == true) {
      await AuthStorage.deleteToken();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseScreen(
        child: Column(
          children: [
            // AppBar personalizada
            CustomAppBar(
              title: "Barri Boy´s",
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.blueAccent),
                  tooltip: "Cerrar sesión",
                  onPressed: _logout,
                ),
              ],
            ),

            // Contenido de la página seleccionada
            Expanded(child: _pages[_selectedIndex]),

            // Mostrar token solo en modo debug
            if (kDebugMode && _token.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Token: $_token',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),

      // Barra de navegación inferior
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.grey[300],
        ),
        child: AdesaNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
