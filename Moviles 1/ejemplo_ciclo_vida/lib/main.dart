import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ciclo de Vida Widget',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de Ciclo de Vida'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Presiona el botón para crear el widget',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CicloVidaPage(),
                  ),
                );
              },
              child: const Text('Crear Widget'),
            ),
          ],
        ),
      ),
    );
  }
}

class CicloVidaPage extends StatefulWidget {
  const CicloVidaPage({super.key});

  @override
  State<CicloVidaPage> createState() {
    print('createState() - Creando el State');
    return _CicloVidaPageState();
  }
}

class _CicloVidaPageState extends State<CicloVidaPage> with WidgetsBindingObserver {
  int _contador = 0;
  String _texto = 'Inicial';
  final List<String> _logs = [];

  _CicloVidaPageState() {
    _agregarLog('1. Constructor');
  }

  @override
  void initState() {
    super.initState();
    _agregarLog('2. initState()');
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_logs.where((log) => log.contains('didChangeDependencies')).isEmpty) {
      _agregarLog('3. didChangeDependencies()');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ciclo de Vida en Acción'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Contador: $_contador',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Texto: $_texto',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _agregarLog('4. setState() llamado');
                      _contador++;
                    });
                  },
                  child: const Text('Incrementar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _agregarLog('4. setState() llamado');
                      _texto = 'Actualizado ${DateTime.now().second}';
                    });
                  },
                  child: const Text('Cambiar Texto'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CicloVidaPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Recrear Widget (didUpdateWidget)'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Registro de Eventos:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: Text(
                        _logs[index],
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Regresar (deactivate + dispose)'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(CicloVidaPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _agregarLog('5. didUpdateWidget()');
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    _agregarLog('6. reassemble() - Hot reload');
  }

  @override
  void deactivate() {
    _agregarLog('7. deactivate()');
    super.deactivate();
  }

  @override
  void dispose() {
    _agregarLog('8. dispose()');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _agregarLog('App lifecycle: ${state.name}');
    });
  }

  void _agregarLog(String mensaje) {
    _logs.add(mensaje);
  }
}
