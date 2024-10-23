import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';

class PhoneScreen extends StatelessWidget {
  const PhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teléfonos'),
      ),
      body: const Center(
        child: Text('Teléfonos: 02-3063 / 0983245830'),
      ),
    );
  }
}

// Pantalla para Horarios
class HoursScreen extends StatelessWidget {
  const HoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Horarios de Atención',
          style: TextStyle(fontWeight: FontWeight.bold), // Negrita
        ),
      ),
      body: const Center(
        child: Text('Lunes a Viernes: 08:00 - 17:00\nSábados: 08:00 - 12:00'),
      ),
    );
  }
}

// Pantalla para Correo Electrónico
class EmailScreen extends StatelessWidget {
  const EmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Correo Electrónico'),
      ),
      body: const Center(
        child: Text('e-mail: info@nrectificadora.com'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Nueva Rectificadora',
    home: const HomePage(),
    theme: ThemeData(
      primarySwatch: Colors.red,
      fontFamily: 'Montserrat',
    ),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 230, end: 270).animate(_controller);
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('usuario') ?? '';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_userName.isEmpty
            ? 'Nueva Rectificadora'
            : 'Bienvenidos, $_userName'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: Tooltip(
              message: 'Registrar',
              child: IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistroPage()),
                  ).then((_) => _loadUserName());
                },
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(150, 26, 206, 131),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return SizedBox(
                    width: _animation.value,
                    height: _animation.value,
                    child: Image.asset(
                      'assets/images/logo.gif',
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'NUEVA RECTIFICADORA',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                _userName.isEmpty
                    ? '¡Bienvenido a nuestra empresa!\nOfrecemos los mejores servicios de rectificación de motores.'
                    : '¡Hola $_userName, estás logueado!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 55, 5),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 55, 5),
                    foregroundColor: Colors.white),
                child: const Text('Nosotros'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NosotrosPage()),
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 55, 5),
                    foregroundColor: Colors.white),
                child: const Text('Servicios'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ServiciosPage()),
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 55, 5),
                    foregroundColor: Colors.white),
                child: const Text('Contacto'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactoPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página de registro
class RegistroPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  RegistroPage({super.key});

  Future<void> _saveCredentials(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario', _userController.text);

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Bienvenido, ${_userController.text}!'),
        duration: const Duration(seconds: 2),
      ),
    );

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

//--------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: const Color.fromARGB(150, 26, 206, 131), // Fondo verde
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                _userController,
                'Usuario',
                'Por favor ingrese un usuario',
                icon: Icons.person, // Ícono de usuario
              ),
              _buildTextField(
                _emailController,
                'Email',
                'Por favor ingrese un correo electrónico',
                icon: Icons.email, // Ícono de email
              ),
              _buildTextField(
                _passwordController,
                'Contraseña',
                'Por favor ingrese una contraseña',
                isPassword: true,
                icon: Icons.lock, // Ícono de contraseña
              ),
              _buildTextField(
                _phoneController,
                'Teléfono',
                'Por favor ingrese un teléfono',
                icon: Icons.phone, // Ícono de teléfono
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 55, 5),
                    foregroundColor: Colors.white),
                child: const Text('Registrar'),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _saveCredentials(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String errorText,
      {bool isPassword = false, IconData? icon}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null, // Agregar el ícono
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      ),
      obscureText: isPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        }
        return null;
      },
      textAlign: TextAlign.center, // Centrar el texto
    );
  }

//----------------
  Widget buildTextField(
      TextEditingController controller, String label, String errorText,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      obscureText: isPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        }
        return null;
      },
    );
  }
}

/// Página "Nosotros"
class NosotrosPage extends StatelessWidget {
  const NosotrosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nosotros'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: const Color.fromARGB(150, 26, 206, 131), // Color de fondo
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Imagen principal (reemplaza 'assets/images/mision.jpg' con la ruta correcta)

                  const SizedBox(height: 16.0),
                  const Text(
                    '"NUEVA RECTIFICADORA"',
                    style: TextStyle(fontSize: 26),
                    textAlign: TextAlign.center,
                  ),
                  Image.asset(
                    'assets/images/mision.jpg',
                    height: 200,
                    fit: BoxFit.cover,
                  ), // Misión
                  const Text(
                    'Misión',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 3.0),
                  const Text(
                    'Proveer servicios de calidad en la rectificación de motores,\n'
                    'siendo una empresa confiable y eficiente para nuestros clientes.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 3.0), // Espacio adicional
                  Image.asset(
                    'assets/images/vision.jpg',
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16.0),
                  // Visión
                  const Text(
                    'Visión',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Ser líderes en el sector de rectificación de motores,\n'
                    'reconocidos por la calidad de nuestro servicio y la satisfacción de nuestros clientes.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Servicio {
  final String nombre;
  final String imagen;
  final String descripcion;

  const Servicio(
      {required this.nombre, required this.imagen, required this.descripcion});
}

// Página "Servicios"
class ServiciosPage extends StatelessWidget {
  const ServiciosPage({super.key});
  final services = const [
    {
      'name': 'Rectificación de cigueñales',
      'image': 'assets/images/rectificacion_ciguenales.jpg',
      'description':
          'Proceso de rectificado de alta precisión para corregir el cigüeñal y garantizar su correcto funcionamiento en el motor.',
    },
    {
      'name': 'Rectificación de cabezotes',
      'image': 'assets/images/rectificacion_cabezotes.jpg',
      'description':
          'Restauración de la superficie de la culata del motor para asegurar un sellado perfecto y un rendimiento óptimo.',
    },
    {
      'name': 'Rectificación de bloques',
      'image': 'assets/images/rectificacion_bloques.jpg',
      'description':
          'Recuperación de las paredes del bloque del motor para corregir desgastes y garantizar la lubricación adecuada.',
    },
    {
      'name': 'Rectificación de brazo de biela',
      'image': 'assets/images/rectificacion_biela.jpg',
      'description':
          'Corrección de la alineación y rectificado de la biela para asegurar un movimiento suave y sin fricción.',
    },
    {
      'name': 'Armado de motores',
      'image': 'assets/images/armado_motores.jpeg',
      'description':
          'Servicio integral de armado de motores con componentes de alta calidad y mano de obra especializada.',
    },
    {
      'name': 'Soluciones personalizadas',
      'image': 'assets/images/soluciones_personalizadas.jpg',
      'description':
          'Atendemos necesidades específicas de cada cliente, ofreciendo soluciones a medida para el óptimo rendimiento de su motor.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
      ),
      body: Container(
        color: const Color.fromARGB(150, 26, 206, 131),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Proveemos las mejores soluciones en reparación integral de motores al sector automotriz ecuatoriano, a través de procedimientos industriales de alta tecnología, técnicos comprometidos con la excelencia y una sólida estructura organizacional.',
                    style: TextStyle(fontSize: 19),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Nuestros servicios constan de:',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 15),
                  _buildServicesGrid(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Service data with descriptions

  // Método que construye un GridView con los servicios
  Widget _buildServicesGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceCard(context, service['name']!, service['image']!,
            service['description']!);
      },
    );
  }

  // Método que construye una tarjeta para cada servicio con una imagen y descripción
  Widget _buildServiceCard(BuildContext context, String service,
      String imagePath, String description) {
    return GestureDetector(
      onTap: () {
        _showServiceDialog(context, service, description);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0), // Adjust padding as needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4), // Adjust spacing as needed
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    maxLines: 2, // Adjust max lines for description length
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showServiceDialog(
    BuildContext context, String service, String description) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(service),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}

//PAGINA CONTACTOS*******************************************

// Define el StatefulWidget ContactoPage
class ContactoPage extends StatefulWidget {
  const ContactoPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactoPageState createState() => _ContactoPageState();
}

// Define el estado asociado con ContactoPage
class _ContactoPageState extends State<ContactoPage> {
  // Variables para controlar la opacidad de los textos
  double _textOpacity = 1.0;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _startTextAnimation(); // Iniciar la animación de los textos
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTextAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        // Optional check for mounted
        setState(() {
          _textOpacity = _textOpacity == 1.0 ? 0.0 : 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacto'),
      ),
      body: Container(
        color: const Color.fromARGB(150, 26, 206, 131),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centrar horizontalmente
            children: [
              // Texto estático de la Agencia Matriz
              const Text(
                '         Agencia Matriz:\n Calle Chanchagua y Pilaló \n     (SECTOR LA GATAZO)',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Ícono de Teléfono con rotación + texto que aparece y desaparece
              _buildContactInfo(
                icon: Icons.phone,
                text: 'Teléfonos: 02-3063 / 0983245830 ',
                context: context,
                destination: const PhonePage(),
              ),
              const SizedBox(height: 20),
              // Ícono de Horarios con rotación + texto que aparece y desaparece
              _buildContactInfo(
                icon: Icons.access_time,
                text:
                    'Horarios de Atención:\n Lunes a Viernes: 08:00 - 17:00\n Sábados: 08:00 - 12:00',
                context: context,
                destination: const HoursPage(),
              ),
              const SizedBox(height: 20),
              // Ícono de Correo Electrónico con rotación + texto que aparece y desaparece
              _buildContactInfo(
                icon: Icons.email,
                text: 'e-mail: info@nrectificadora.com',
                context: context,
                destination: const EmailPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Función para construir el ícono con animación de rotación y texto asociado
  Widget _buildContactInfo({
    required IconData icon,
    required String text,
    required BuildContext context,
    required Widget destination,
  }) {
    return Column(
      children: [
        _buildRotatingIcon(icon), // Ícono giratorio
        const SizedBox(height: 10),
        AnimatedOpacity(
          opacity: _textOpacity,
          duration: const Duration(seconds: 1),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destination),
              );
            },
            child: Text(
              text,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center, // Centrar el texto
            ),
          ),
        ),
      ],
    );
  }

  // Función para construir el ícono con animación de rotación
  Widget _buildRotatingIcon(IconData icon) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 15 * pi),
      duration: const Duration(
          seconds: 60), // Duración de la rotación aumentada a 60 segundos
      builder: (context, double angle, child) {
        return Transform.rotate(
          angle: angle,
          child: Icon(icon,
              size: 48,
              color: const Color.fromARGB(
                  255, 255, 55, 55)), // Aumentar tamaño del ícono
        );
      },
    );
  }
}

// Pantallas secundarias

class PhonePage extends StatelessWidget {
  const PhonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teléfonos'),
      ),
      body: const Center(
        child: Text('Teléfonos: 02-3063 / 0983245830'),
      ),
    );
  }
}

class HoursPage extends StatelessWidget {
  const HoursPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horarios de Atención'),
      ),
      body: const Center(
        child: Text('Lunes a Viernes: 08:00 - 17:00\nSábados: 08:00 - 12:00'),
      ),
    );
  }
}

class EmailPage extends StatelessWidget {
  const EmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Correo Electrónico'),
      ),
      body: const Center(
        child: Text('e-mail: info@nrectificadora.com'),
      ),
    );
  }
}
