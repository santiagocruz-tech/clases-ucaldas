# Mini Proyecto de Evaluación: App del Clima ☁️

## Objetivo
Evaluar todos los conocimientos adquiridos desde el inicio del curso hasta el punto 7.1 (Navigator Básico).

## Temas Evaluados
- ✅ Fundamentos de Dart (variables, funciones, clases)
- ✅ Widgets (StatelessWidget, StatefulWidget)
- ✅ Layouts (Column, Row, Container, ListView)
- ✅ Gestión de estado con setState
- ✅ Networking y APIs (HTTP)
- ✅ Navegación básica (Navigator.push/pop)

## Descripción del Proyecto
Crear una aplicación del clima que consuma la API gratuita de OpenWeatherMap y permita:
- Buscar el clima de cualquier ciudad
- Ver información detallada del clima actual
- Guardar ciudades favoritas
- Navegar entre pantallas

## API a Utilizar

### OpenWeatherMap API (Gratuita)
- **URL**: https://openweathermap.org/api
- **Plan**: Free (60 llamadas/minuto)
- **Registro**: https://home.openweathermap.org/users/sign_up

### Endpoints a usar:
```
Current Weather:
https://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric&lang=es

Ejemplo:
https://api.openweathermap.org/data/2.5/weather?q=Bogota&appid=TU_API_KEY&units=metric&lang=es
```

### Respuesta de ejemplo:
```json
{
  "name": "Bogotá",
  "main": {
    "temp": 14.5,
    "feels_like": 13.2,
    "temp_min": 12.0,
    "temp_max": 16.0,
    "humidity": 75
  },
  "weather": [
    {
      "main": "Clouds",
      "description": "nubes dispersas",
      "icon": "02d"
    }
  ],
  "wind": {
    "speed": 3.5
  },
  "sys": {
    "country": "CO"
  }
}
```

## Estructura del Proyecto

```
lib/
├── main.dart
├── models/
│   └── clima.dart
├── services/
│   └── clima_service.dart
└── screens/
    ├── home_screen.dart
    ├── buscar_screen.dart
    └── detalle_clima_screen.dart
```

## Dependencias Requeridas

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
```

## Código Base

### models/clima.dart
```dart
class Clima {
  final String ciudad;
  final String pais;
  final double temperatura;
  final double tempMax;
  final double tempMin;
  final String descripcion;
  final int humedad;
  final double velocidadViento;
  final double sensacionTermica;
  final String icono;

  Clima({
    required this.ciudad,
    required this.pais,
    required this.temperatura,
    required this.tempMax,
    required this.tempMin,
    required this.descripcion,
    required this.humedad,
    required this.velocidadViento,
    required this.sensacionTermica,
    required this.icono,
  });

  factory Clima.fromJson(Map<String, dynamic> json) {
    return Clima(
      ciudad: json['name'],
      pais: json['sys']['country'],
      temperatura: json['main']['temp'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      descripcion: json['weather'][0]['description'],
      humedad: json['main']['humidity'],
      velocidadViento: json['wind']['speed'].toDouble(),
      sensacionTermica: json['main']['feels_like'].toDouble(),
      icono: json['weather'][0]['icon'],
    );
  }

  // Método para obtener emoji según el clima
  String get emoji {
    if (icono.contains('01')) return '☀️';
    if (icono.contains('02')) return '⛅';
    if (icono.contains('03') || icono.contains('04')) return '☁️';
    if (icono.contains('09') || icono.contains('10')) return '🌧️';
    if (icono.contains('11')) return '⛈️';
    if (icono.contains('13')) return '❄️';
    if (icono.contains('50')) return '🌫️';
    return '🌤️';
  }
}
```

### services/clima_service.dart
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/clima.dart';

class ClimaService {
  static const String apiKey = 'TU_API_KEY_AQUI'; // Reemplazar con tu API key
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Clima> obtenerClima(String ciudad) async {
    final url = '$baseUrl?q=$ciudad&appid=$apiKey&units=metric&lang=es';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Clima.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Ciudad no encontrada');
      } else {
        throw Exception('Error al obtener datos del clima');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
```

## Funcionalidades Requeridas

### 1. Pantalla Principal (HomeScreen) - 1.0 punto
**StatefulWidget con:**
- Lista de ciudades favoritas (inicialmente vacía)
- Botón flotante para buscar nuevas ciudades
- Cada ciudad muestra: emoji del clima, nombre, temperatura
- Tap en ciudad navega a detalles
- Mensaje cuando no hay favoritos

### 2. Pantalla de Búsqueda (BuscarScreen) - 1.5 puntos
**StatefulWidget con:**
- TextField para ingresar nombre de ciudad
- Botón para buscar
- Manejo de estados:
  - Estado inicial (sin búsqueda)
  - Estado cargando (CircularProgressIndicator)
  - Estado éxito (mostrar resultado)
  - Estado error (mostrar mensaje)
- Botón para agregar a favoritos
- Navegación a detalles

### 3. Pantalla de Detalles (DetalleClimaScreen) - 1.0 punto
**StatelessWidget con:**
- Recibe objeto Clima
- Muestra toda la información en Cards:
  - Temperatura actual (grande)
  - Sensación térmica
  - Temperatura máxima y mínima
  - Descripción del clima
  - Humedad
  - Velocidad del viento
- Diseño atractivo con iconos

### 4. Consumo de API (ClimaService) - 1.0 punto
- Implementar método obtenerClima()
- Manejo correcto de respuestas HTTP
- Manejo de errores (ciudad no encontrada, sin internet)
- Parseo correcto de JSON a modelo Clima

### 5. Navegación - 0.5 puntos
- Navigator.push() entre las 3 pantallas
- Navigator.pop() para regresar
- Paso correcto de datos (objeto Clima)
- MaterialPageRoute configurado correctamente

## Rúbrica de Evaluación (0.0 - 5.0)

| Criterio | Excelente (100%) | Bueno (75%) | Regular (50%) | Insuficiente (25%) | No entregado (0%) |
|----------|------------------|-------------|---------------|-------------------|-------------------|
| **1. Pantalla Principal (1.0)** | Lista funcional, diseño limpio, manejo de estado vacío | Lista funcional, diseño básico | Lista con errores menores | Lista no funciona correctamente | No implementado |
| **2. Búsqueda y API (1.5)** | Búsqueda funcional, todos los estados manejados, sin errores | Búsqueda funciona, falta algún estado | Búsqueda con errores, estados incompletos | API no funciona correctamente | No implementado |
| **3. Pantalla Detalles (1.0)** | Toda la info mostrada, diseño excelente | Info completa, diseño básico | Falta información, diseño pobre | Información incorrecta | No implementado |
| **4. Gestión de Estado (0.5)** | setState correcto en todos los casos | setState funciona con errores menores | setState con problemas | No usa setState correctamente | No implementado |
| **5. Navegación (0.5)** | Navegación perfecta entre 3 pantallas | Navegación funciona con detalles menores | Navegación con errores | Navegación no funciona | No implementado |
| **6. Código Dart (0.5)** | Clases bien estructuradas, tipos correctos | Código funcional con detalles | Código con errores de sintaxis | Código muy deficiente | No compila |

**Nota Final = Suma de todos los criterios (máximo 5.0)**

## Tareas Paso a Paso

### Paso 1: Configuración (10 min)
1. Crear proyecto: `flutter create clima_app`
2. Agregar dependencia `http` en pubspec.yaml
3. Registrarse en OpenWeatherMap y obtener API key
4. Crear estructura de carpetas

### Paso 2: Modelo y Servicio (20 min)
1. Crear `models/clima.dart` con la clase Clima
2. Implementar `fromJson()` y getter `emoji`
3. Crear `services/clima_service.dart`
4. Implementar método `obtenerClima()`
5. Probar con print() que funciona

### Paso 3: Pantalla de Búsqueda (30 min)
1. Crear `screens/buscar_screen.dart`
2. Agregar TextField y botón
3. Implementar estados (inicial, cargando, éxito, error)
4. Conectar con ClimaService
5. Mostrar resultado con FutureBuilder o setState

### Paso 4: Pantalla de Detalles (20 min)
1. Crear `screens/detalle_clima_screen.dart`
2. Recibir objeto Clima en constructor
3. Diseñar layout con Cards
4. Mostrar toda la información

### Paso 5: Pantalla Principal y Navegación (30 min)
1. Crear `screens/home_screen.dart`
2. Implementar lista de favoritos
3. Agregar FloatingActionButton
4. Implementar navegación a búsqueda
5. Implementar navegación a detalles
6. Agregar/quitar favoritos

### Paso 6: Integración y Pruebas (10 min)
1. Configurar main.dart
2. Probar todas las funcionalidades
3. Corregir errores
4. Mejorar diseño

## Ejemplo de Implementación

### main.dart
```dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
```

### screens/buscar_screen.dart (Estructura básica)
```dart
import 'package:flutter/material.dart';
import '../models/clima.dart';
import '../services/clima_service.dart';
import 'detalle_clima_screen.dart';

class BuscarScreen extends StatefulWidget {
  @override
  _BuscarScreenState createState() => _BuscarScreenState();
}

class _BuscarScreenState extends State<BuscarScreen> {
  final _controller = TextEditingController();
  final _service = ClimaService();
  
  bool _cargando = false;
  Clima? _clima;
  String? _error;

  Future<void> _buscarClima() async {
    if (_controller.text.isEmpty) return;
    
    setState(() {
      _cargando = true;
      _error = null;
      _clima = null;
    });

    try {
      final clima = await _service.obtenerClima(_controller.text);
      setState(() {
        _clima = clima;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar Ciudad')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nombre de la ciudad',
                hintText: 'Ej: Bogotá',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _buscarClima,
                ),
              ),
              onSubmitted: (_) => _buscarClima(),
            ),
            SizedBox(height: 20),
            if (_cargando)
              CircularProgressIndicator()
            else if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red))
            else if (_clima != null)
              Card(
                child: ListTile(
                  leading: Text(_clima!.emoji, style: TextStyle(fontSize: 40)),
                  title: Text(_clima!.ciudad),
                  subtitle: Text('${_clima!.temperatura.toStringAsFixed(1)}°C'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalleClimaScreen(clima: _clima!),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

## Instrucciones de Entrega

1. **Crear proyecto**: `flutter create clima_app`
2. **Implementar todas las funcionalidades**
3. **Probar con al menos 3 ciudades diferentes**
4. **Asegurarse que compile sin errores**
5. **Entregar código fuente completo**

## Recursos Permitidos
- Documentación de Flutter (https://docs.flutter.dev)
- README del curso (hasta sección 7.1)
- Documentación de OpenWeatherMap API
- Ejemplos de código de proyectos anteriores

## Tiempo Estimado
**120 minutos (2 horas)**

## Checklist de Entrega

### Funcionalidades Básicas (Mínimo para aprobar 3.0)
- [ ] Proyecto compila sin errores
- [ ] API key configurada correctamente
- [ ] Búsqueda de ciudad funciona
- [ ] Muestra información del clima
- [ ] Navegación entre pantallas funciona

### Funcionalidades Completas (Para 4.0-5.0)
- [ ] Todas las funcionalidades básicas
- [ ] Manejo de errores (ciudad no encontrada, sin internet)
- [ ] Lista de favoritos funcional
- [ ] Diseño limpio y organizado
- [ ] Código bien estructurado
- [ ] Uso correcto de setState
- [ ] Todas las pantallas implementadas

## Notas Importantes

⚠️ **API Key**: Cada estudiante debe registrarse y obtener su propia API key gratuita

⚠️ **Internet**: La app requiere conexión a internet para funcionar

⚠️ **Límites**: La API gratuita permite 60 llamadas por minuto (suficiente para pruebas)

⚠️ **Idioma**: Usar `lang=es` en la URL para obtener descripciones en español

⚠️ **Unidades**: Usar `units=metric` para obtener temperatura en Celsius

## Ejemplo de Ciudades para Probar
- Bogotá
- Medellín
- Cali
- Cartagena
- Madrid
- Londres
- Tokyo
- New York

---

**¡Éxito en tu evaluación! 🚀**
