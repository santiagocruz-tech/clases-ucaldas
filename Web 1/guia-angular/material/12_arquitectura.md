# 12. Arquitectura y buenas prácticas

## Organización de carpetas

Una buena estructura de carpetas hace que el proyecto sea mantenible a medida que crece.

### Estructura recomendada

```
src/app/
├── core/                    ← Servicios globales, interceptores, modelos
│   ├── services/
│   │   ├── tmdb.service.ts
│   │   ├── favorites.service.ts
│   │   ├── theme.service.ts
│   │   └── storage.service.ts
│   ├── interceptors/
│   │   └── auth.interceptor.ts
│   └── models/
│       ├── movie.ts
│       ├── genre.ts
│       └── credits.ts
├── shared/                  ← Componentes y pipes reutilizables
│   ├── components/
│   │   ├── movie-card/
│   │   ├── spinner/
│   │   └── pagination/
│   └── pipes/
│       ├── truncate.pipe.ts
│       └── tmdb-image.pipe.ts
├── features/                ← Una carpeta por página/funcionalidad
│   ├── home/
│   │   ├── home.component.ts
│   │   ├── home.component.html
│   │   └── home.component.scss
│   ├── movie-detail/
│   ├── search-results/
│   ├── favorites/
│   └── genre-filter/
├── app.component.ts
├── app.component.html
├── app.routes.ts
└── app.config.ts
```

### ¿Qué va en cada carpeta?

| Carpeta | Contenido | Regla |
|---|---|---|
| `core/` | Servicios, interceptores, modelos, guards | Se usan en toda la app. Una sola instancia. |
| `shared/` | Componentes, pipes, directivas reutilizables | Se importan en múltiples features. |
| `features/` | Páginas y sus componentes específicos | Cada feature es independiente. |

---

## Componentes standalone vs. módulos (NgModule)

### Standalone (Angular 14+ — recomendado)

Cada componente declara sus propias dependencias:

```typescript
@Component({
    selector: 'app-home',
    standalone: true,
    imports: [
        MovieCardComponent,
        SpinnerComponent,
        AsyncPipe,
        RouterLink
    ],
    templateUrl: './home.component.html'
})
export class HomeComponent {}
```

### NgModule (forma antigua)

Los componentes se agrupan en módulos:

```typescript
@NgModule({
    declarations: [HomeComponent, MovieCardComponent],
    imports: [CommonModule, RouterModule],
    exports: [HomeComponent]
})
export class HomeModule {}
```

**Usar standalone.** Es más simple, tiene mejor tree-shaking y es la dirección que toma Angular.

---

## Barrel exports (index.ts)

Un barrel export agrupa las exportaciones de una carpeta en un solo archivo. Simplifica los imports.

```typescript
// shared/pipes/index.ts
export { TruncatePipe } from './truncate.pipe';
export { TmdbImagePipe } from './tmdb-image.pipe';
export { TimeAgoPipe } from './time-ago.pipe';
```

```typescript
// En vez de:
import { TruncatePipe } from '../../shared/pipes/truncate.pipe';
import { TmdbImagePipe } from '../../shared/pipes/tmdb-image.pipe';

// Podés hacer:
import { TruncatePipe, TmdbImagePipe } from '../../shared/pipes';
```

```typescript
// core/models/index.ts
export { Movie, MovieDetail, MovieResponse } from './movie';
export { Genre } from './genre';
export { Credits, CastMember } from './credits';
```

---

## Ambientes (environment.ts)

Los ambientes permiten tener configuraciones diferentes para desarrollo y producción.

```typescript
// src/environments/environment.ts (desarrollo)
export const environment = {
    production: false,
    tmdbApiKey: 'TU_API_KEY_DESARROLLO',
    tmdbBaseUrl: 'https://api.themoviedb.org/3'
};
```

```typescript
// src/environments/environment.prod.ts (producción)
export const environment = {
    production: true,
    tmdbApiKey: 'TU_API_KEY_PRODUCCION',
    tmdbBaseUrl: 'https://api.themoviedb.org/3'
};
```

### Usar en servicios

```typescript
import { environment } from '../../environments/environment';

@Injectable({ providedIn: 'root' })
export class TmdbService {
    private apiUrl = environment.tmdbBaseUrl;
    private apiKey = environment.tmdbApiKey;
}
```

### Configurar en angular.json

```json
{
    "configurations": {
        "production": {
            "fileReplacements": [
                {
                    "replace": "src/environments/environment.ts",
                    "with": "src/environments/environment.prod.ts"
                }
            ]
        }
    }
}
```

Al hacer `ng build`, Angular reemplaza automáticamente el archivo de ambiente.

---

## Build de producción y despliegue

### Build

```bash
# Build de producción (optimizado, minificado)
ng build

# Los archivos se generan en dist/nombre-proyecto/
```

El build de producción:
- Minifica el código.
- Elimina código no usado (tree-shaking).
- Compila los templates AOT (Ahead of Time).
- Genera hashes en los nombres de archivo (cache busting).

### Despliegue en GitHub Pages

```bash
# Instalar herramienta de despliegue
ng add angular-cli-ghpages

# Desplegar
ng deploy --base-href=/nombre-repositorio/
```

### Despliegue en Netlify/Vercel

1. Conectar el repositorio de GitHub.
2. Configurar:
   - Build command: `ng build`
   - Publish directory: `dist/nombre-proyecto/browser`
3. Agregar archivo `_redirects` en `src/assets/`:
   ```
   /*    /index.html   200
   ```
   Esto es necesario para que el routing de Angular funcione.

---

## Checklist de calidad de un proyecto Angular

### Código
- [ ] Sin errores ni warnings en consola.
- [ ] `ng build` compila sin errores.
- [ ] TypeScript estricto: sin `any` innecesarios.
- [ ] Interfaces para todos los datos de API.
- [ ] Servicios separados de componentes.
- [ ] Componentes de presentación reutilizables.

### Arquitectura
- [ ] Carpetas organizadas (core/shared/features).
- [ ] Barrel exports donde tenga sentido.
- [ ] Variables de entorno para API keys.
- [ ] Interceptor para autenticación.
- [ ] Manejo de errores en peticiones HTTP.

### Estilos
- [ ] Variables CSS para colores, sombras, espaciado.
- [ ] Tema claro/oscuro funcional.
- [ ] Responsive (mobile first).
- [ ] `prefers-reduced-motion` incluido.
- [ ] Sin colores hardcodeados fuera de variables.

### UX
- [ ] Estados de carga (spinners).
- [ ] Mensajes de error visibles.
- [ ] Estados vacíos ("No hay resultados").
- [ ] Navegación funcional sin recargas.

### Git
- [ ] Commits descriptivos (no "fix", "update").
- [ ] Mínimo 10 commits con progreso real.
- [ ] README con instrucciones y capturas.

---

## Ejercicios

### Ejercicio 1: Reorganizar proyecto
Tomar un proyecto existente y reorganizar los archivos en la estructura core/shared/features. Crear barrel exports para models y pipes.

### Ejercicio 2: Ambientes
Configurar `environment.ts` y `environment.prod.ts` con la API key de TMDB. Verificar que el servicio usa la variable de entorno.

### Ejercicio 3: Build y despliegue
Hacer `ng build` y verificar que no hay errores. Desplegar en GitHub Pages o Netlify.
