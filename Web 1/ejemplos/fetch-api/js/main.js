/*
    Fetch API - Ejemplos practicos
    ==============================

    Fetch es la forma moderna de hacer peticiones HTTP desde el navegador.
    Sustituye al viejo XMLHttpRequest y trabaja con Promesas, lo que
    hace el codigo mucho mas legible.

    Usamos JSONPlaceholder (https://jsonplaceholder.typicode.com) como
    API de pruebas. Es publica, gratuita, y devuelve datos fake pero
    con estructura realista (usuarios, posts, comentarios, etc).

    Contenido:
      1. GET basico (lista de usuarios)
      2. GET por ID (un usuario)
      3. POST (crear un post)
      4. Manejo de errores (404 y error de red)
      5. Async/Await (alternativa a .then)
*/

// URL base. La definimos una sola vez para no repetirla.
var API = 'https://jsonplaceholder.typicode.com';


// ---------------------------------------------------------
// Helpers para mostrar resultados en la pagina
// ---------------------------------------------------------

// Muestra texto en un contenedor con un estilo opcional
function mostrar(id, texto, tipo) {
    var el = document.getElementById(id);
    el.textContent = texto;
    el.className = 'resultado visible';
    if (tipo === 'error') el.classList.add('error');
    if (tipo === 'ok') el.classList.add('ok');
}

// Muestra el estado "Cargando..." mientras esperamos respuesta
function cargando(id) {
    var el = document.getElementById(id);
    el.textContent = '';
    el.className = 'resultado visible cargando';
}


// =========================================================
// 1. GET - Obtener una lista de usuarios
// =========================================================
//
// fetch(url) hace una peticion GET por defecto.
// Devuelve una Promesa que se resuelve con un objeto Response.
//
// El flujo es:
//   fetch(url)
//     .then(response => response.json())   <-- parsear el JSON
//     .then(datos => ...)                   <-- usar los datos
//     .catch(error => ...)                  <-- errores de RED
//
// OJO: fetch solo rechaza la promesa si hay error de RED
// (sin internet, DNS fallo, etc). Un 404 o 500 NO lanza error.
// Tenemos que revisar response.ok nosotros.

document.getElementById('btn-get').addEventListener('click', function() {
    cargando('resultado-get');

    fetch(API + '/users')
        .then(function(response) {
            // response.ok es true cuando el status esta entre 200-299
            console.log('Status:', response.status);
            console.log('OK?:', response.ok);

            if (!response.ok) {
                throw new Error('HTTP ' + response.status);
            }

            // .json() tambien devuelve una Promesa
            return response.json();
        })
        .then(function(usuarios) {
            console.log('Datos recibidos:', usuarios);

            // Armamos un texto con los datos
            var texto = 'Se encontraron ' + usuarios.length + ' usuarios:\n\n';

            usuarios.forEach(function(u) {
                texto += '  ' + u.name + '\n';
                texto += '    Email: ' + u.email + '\n';
                texto += '    Ciudad: ' + u.address.city + '\n';
                texto += '    Empresa: ' + u.company.name + '\n\n';
            });

            mostrar('resultado-get', texto, 'ok');
        })
        .catch(function(error) {
            // Llega aqui si:
            //   - No hay conexion a internet
            //   - Lanzamos un throw arriba
            console.error('Error:', error);
            mostrar('resultado-get', 'Error: ' + error.message, 'error');
        });
});


// =========================================================
// 2. GET por ID - Buscar un usuario especifico
// =========================================================
//
// Para pedir un recurso por ID, lo agregamos a la URL:
//   /users/1  ->  devuelve el usuario con id 1
//   /users/5  ->  devuelve el usuario con id 5

document.getElementById('btn-get-id').addEventListener('click', function() {
    var id = document.getElementById('input-id').value;

    if (!id || id < 1 || id > 10) {
        mostrar('resultado-get-id', 'Ingresa un ID valido (1-10)', 'error');
        return;
    }

    cargando('resultado-get-id');

    fetch(API + '/users/' + id)
        .then(function(response) {
            if (!response.ok) {
                throw new Error('No se encontro el usuario (HTTP ' + response.status + ')');
            }
            return response.json();
        })
        .then(function(u) {
            var texto = 'Usuario encontrado:\n\n'
                + '  Nombre:    ' + u.name + '\n'
                + '  Username:  ' + u.username + '\n'
                + '  Email:     ' + u.email + '\n'
                + '  Telefono:  ' + u.phone + '\n'
                + '  Web:       ' + u.website + '\n'
                + '  Empresa:   ' + u.company.name + '\n'
                + '  Ciudad:    ' + u.address.city;

            mostrar('resultado-get-id', texto, 'ok');
        })
        .catch(function(error) {
            mostrar('resultado-get-id', 'Error: ' + error.message, 'error');
        });
});


// =========================================================
// 3. POST - Crear un recurso nuevo
// =========================================================
//
// Para hacer POST necesitamos pasar un segundo argumento a fetch()
// con la configuracion:
//
//   fetch(url, {
//       method: 'POST',                          <-- metodo HTTP
//       headers: { 'Content-Type': 'application/json' },  <-- tipo de datos
//       body: JSON.stringify(datos)               <-- datos en formato JSON
//   })
//
// JSONPlaceholder simula la creacion: devuelve el objeto con un
// id asignado, pero no lo guarda realmente en el servidor.

document.getElementById('btn-post').addEventListener('click', function() {
    var titulo = document.getElementById('input-titulo').value.trim();
    var body = document.getElementById('input-body').value.trim();

    if (!titulo || !body) {
        mostrar('resultado-post', 'Rellena ambos campos', 'error');
        return;
    }

    cargando('resultado-post');

    // Objeto que vamos a enviar
    var nuevoPost = {
        title: titulo,
        body: body,
        userId: 1   // usuario ficticio
    };

    fetch(API + '/posts', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        // JSON.stringify convierte el objeto JS a texto JSON
        body: JSON.stringify(nuevoPost)
    })
    .then(function(response) {
        // Un POST exitoso normalmente devuelve 201 (Created)
        console.log('Status:', response.status);

        if (!response.ok) {
            throw new Error('No se pudo crear el post (HTTP ' + response.status + ')');
        }
        return response.json();
    })
    .then(function(postCreado) {
        // El servidor nos devuelve el objeto creado con su nuevo ID
        console.log('Post creado:', postCreado);

        var texto = 'Post creado con exito:\n\n'
            + '  ID:      ' + postCreado.id + '\n'
            + '  Titulo:  ' + postCreado.title + '\n'
            + '  Body:    ' + postCreado.body + '\n'
            + '  UserID:  ' + postCreado.userId;

        mostrar('resultado-post', texto, 'ok');
    })
    .catch(function(error) {
        mostrar('resultado-post', 'Error: ' + error.message, 'error');
    });
});


// =========================================================
// 4. Manejo de errores
// =========================================================
//
// Hay dos tipos de errores con fetch:
//
//   a) Error HTTP (404, 500, etc):
//      fetch NO lo trata como error. La promesa se resuelve
//      normalmente, pero response.ok sera false.
//      Tenemos que lanzar el error nosotros con throw.
//
//   b) Error de red (sin conexion, URL invalida):
//      fetch SI rechaza la promesa. Cae directo al .catch().

// -- Ejemplo de error 404 --
document.getElementById('btn-error-404').addEventListener('click', function() {
    cargando('resultado-errores');

    // Pedimos un recurso que no existe
    fetch(API + '/users/99999')
        .then(function(response) {
            console.log('Status:', response.status);  // 404
            console.log('OK?:', response.ok);          // false

            // Sin esta verificacion, el codigo seguiria como si nada
            if (!response.ok) {
                throw new Error(
                    'El servidor respondio con ' + response.status
                    + ' (' + response.statusText + ')'
                );
            }
            return response.json();
        })
        .then(function(datos) {
            // Esto NO se ejecuta porque lanzamos el error arriba
            mostrar('resultado-errores', JSON.stringify(datos, null, 2), 'ok');
        })
        .catch(function(error) {
            mostrar('resultado-errores', 'Error capturado: ' + error.message, 'error');
        });
});

// -- Ejemplo de error de red --
document.getElementById('btn-error-red').addEventListener('click', function() {
    cargando('resultado-errores');

    // URL que no existe -> error de red
    fetch('https://esto-no-existe-12345.com/api')
        .then(function(response) {
            // Esto nunca se ejecuta
            return response.json();
        })
        .catch(function(error) {
            // TypeError: Failed to fetch (o similar)
            console.error('Error de red:', error);
            mostrar(
                'resultado-errores',
                'Error de red: ' + error.message + '\n\n'
                + 'Esto pasa cuando:\n'
                + '  - No hay conexion a internet\n'
                + '  - La URL no existe\n'
                + '  - El servidor no responde\n'
                + '  - Hay un problema de CORS',
                'error'
            );
        });
});


// =========================================================
// 5. Async/Await - La forma moderna
// =========================================================
//
// async/await es azucar sintactico sobre Promesas.
// Hace exactamente lo mismo que .then(), pero el codigo
// se lee como si fuera sincrono (linea por linea).
//
// Reglas:
//   - La funcion debe llevar la palabra "async" antes
//   - Dentro de ella usamos "await" para esperar cada Promesa
//   - Usamos try/catch en vez de .catch()
//
// Es la forma que mas se usa hoy en dia.

document.getElementById('btn-async').addEventListener('click', async function() {
    cargando('resultado-async');

    try {
        // await "pausa" la ejecucion hasta que la promesa se resuelva
        var response = await fetch(API + '/posts?_limit=5');

        // Verificamos el status igual que antes
        if (!response.ok) {
            throw new Error('HTTP ' + response.status);
        }

        // Parseamos el JSON (tambien necesita await)
        var posts = await response.json();

        console.log('Posts recibidos:', posts);

        // Armamos el resultado
        var texto = 'Ultimos 5 posts:\n\n';

        posts.forEach(function(post, i) {
            texto += (i + 1) + '. ' + post.title + '\n';
            texto += '   ' + post.body.substring(0, 80) + '...\n\n';
        });

        mostrar('resultado-async', texto, 'ok');

    } catch (error) {
        // Captura tanto errores de red como los que lanzamos con throw
        console.error('Error:', error);
        mostrar('resultado-async', 'Error: ' + error.message, 'error');
    }
});
