# Capítulo 12: Arquitectura y buenas prácticas

## Objetivo

Reorganizar CineExplorer con una arquitectura profesional: carpetas por capa, barrel exports, variables de entorno y build de producción.

---

## 12.1 Organización de carpetas

```
src/app/
├── core/                    ← Servicios globales, interceptores, modelos
│   ├── services/
│   │   ├── tmdb.service.ts
│   │   ├── favorites.service.ts
│   │   ├── theme.service.ts
│   │   └── storage.service.ts
│   ├── interceptors/
│   │   └── api-key.interceptor.ts
│   └── models/
│       └── movie.ts         ← Todas las interfaces
├── shared/                  ← Componentes y pipes reutilizables
│   ├── components/
│   │   ├── movie-card/
│   │   ├── spinner/
│   │   └── navbar/
│   └── pipes/
│       ├── truncate.pipe.ts
│       ├── tmdb-image.pipe.ts
│       └── stars.pipe.ts
├── features/                ← Una carpeta por página
│   ├── home/
│   ├── movie-detail/
│   ├── search-results/
│   └── favorites/
├── app.component.ts
├── app.routes.ts
└── app.config.ts
```

| Carpeta | Contenido | Regla |
|---|---|---|
| `core/` | Servicios, interceptores, modelos | Se usan en toda la app. Una sola instancia. |
| `shared/` | Componentes, pipes reutilizables | Se importan en múltiples features. |
| `features/` | Páginas y sus componentes específicos | Cada feature es independiente. |

---

## 12.2 Barrel exports (index.ts)

Un barrel export agrupa las exportaciones de una carpeta en un solo archivo:

```typescript
// shared/pipes/index.ts
// Exportar todos los pipes desde un solo punto
export { TruncatePipe } from './truncate.pipe';
export { TmdbImagePipe } from './tmdb-image.pipe';
export { StarsPipe } from './stars.pipe';
```

```typescript
// En vez de 3 imports separados:
import { TruncatePipe } from '../../shared/pipes/truncate.pipe';
import { TmdbImagePipe } from '../../shared/pipes/tmdb-image.pipe';
import { StarsPipe } from '../../shared/pipes/stars.pipe';

// Un solo import limpio:
import { TruncatePipe, TmdbImagePipe, StarsPipe } from '../../shared/pipes';
```

```typescript
// core/models/index.ts
export { Movie, MovieDetail, MovieResponse, Genre, Credits, CastMember, CrewMember } from './movie';
```

---

## 12.3 Variables de entorno

Las variables de entorno permiten tener configuraciones diferentes para desarrollo y producción.

📁 Crear `src/environments/environment.ts`:

```typescript
// environment.ts (desarrollo)
// Estos valores se usan cuando ejecutamos ng serve
export const environment = {
  production: false,                              // modo desarrollo
  tmdbApiKey: 'TU_API_KEY_DESARROLLO',           // API key para desarrollo
  tmdbBaseUrl: 'https://api.themoviedb.org/3'    // URL base de TMDB
};
```

📁 Crear `src/environments/environment.prod.ts`:

```typescript
// environment.prod.ts (producción)
// Estos valores se usan cuando ejecutamos ng build
export const environment = {
  production: true,
  tmdbApiKey: 'TU_API_KEY_PRODUCCION',
  tmdbBaseUrl: 'https://api.themoviedb.org/3'
};
```

✏️ Usar en los servicios:

```typescript
// tmdb.service.ts
// Importar environment (Angular usa el archivo correcto según el modo)
import { environment } from '../../environments/environment';

@Injectable({ providedIn: 'root' })
export class TmdbService {
  // Usar las variables de entorno en lugar de hardcodear
  private apiUrl = environment.tmdbBaseUrl;
  private apiKey = environment.tmdbApiKey;
}
```

✏️ Configurar en `angular.json` para que el build de producción use el archivo correcto:

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

---

## 12.4 Componentes standalone vs. NgModule

### Standalone (Angular 14+ — recomendado)

Cada componente declara sus propias dependencias:

```typescript
@Component({
  selector: 'app-home',
  standalone: true,
  // Cada componente importa lo que necesita
  imports: [MovieCardComponent, SpinnerComponent, AsyncPipe, RouterLink],
  templateUrl: './home.component.html'
})
export class HomeComponent {}
```

### NgModule (forma antigua)

```typescript
// No usar en proyectos nuevos
@NgModule({
  declarations: [HomeComponent, MovieCardComponent],
  imports: [CommonModule, RouterModule],
  exports: [HomeComponent]
})
export class HomeModule {}
```

💡 **Usar standalone.** Es más simple, tiene mejor tree-shaking y es la dirección que toma Angular.

---

## 12.5 Build de producción y despliegue

### Build

```bash
# Build de producción (optimizado, minificado)
ng build
# Los archivos se generan en dist/cine-explorer/
```

El build de producción: minifica el código, elimina código no usado (tree-shaking), compila templates AOT (Ahead of Time), genera hashes para cache busting.

### Despliegue en Netlify/Vercel

1. Conectar el repositorio de GitHub
2. Configurar:
   - Build command: `ng build`
   - Publish directory: `dist/cine-explorer/browser`
3. Agregar archivo `src/assets/_redirects`:
   ```
   /*    /index.html   200
   ```
   Esto es necesario para que el routing de Angular funcione (SPA).

### Despliegue en GitHub Pages

```bash
# Instalar herramienta de despliegue
ng add angular-cli-ghpages

# Desplegar
ng deploy --base-href=/nombre-repositorio/
```

---

## 12.6 Checklist de calidad

### Código
- [ ] Sin errores ni warnings en consola
- [ ] `ng build` compila sin errores
- [ ] TypeScript estricto: sin `any` innecesarios
- [ ] Interfaces para todos los datos de API
- [ ] Servicios separados de componentes

### Arquitectura
- [ ] Carpetas organizadas (core/shared/features)
- [ ] Variables de entorno para API keys
- [ ] Interceptor para autenticación
- [ ] Manejo de errores en peticiones HTTP

### Estilos
- [ ] Variables CSS para colores, sombras, espaciado
- [ ] Tema claro/oscuro funcional
- [ ] Responsive (mobile first)
- [ ] `prefers-reduced-motion` incluido

### UX
- [ ] Estados de carga (spinners)
- [ ] Mensajes de error visibles
- [ ] Estados vacíos ("No hay resultados")
- [ ] Navegación funcional sin recargas

---

## Resumen de conceptos

| Concepto | Para qué |
|----------|----------|
| core/shared/features | Organización de carpetas por responsabilidad |
| Barrel exports (index.ts) | Simplificar imports |
| `environment.ts` | Variables de entorno (API keys, URLs) |
| Standalone components | Componentes independientes (sin módulos) |
| `ng build` | Build optimizado para producción |
| `_redirects` | Soporte de SPA en hosting estático |

---

**Anterior:** [← Capítulo 11 — Estilos y Bootstrap](11_estilos_bootstrap.md) | **Siguiente:** [Capítulo 13 — Proyecto final →](13_proyecto_final.md)
