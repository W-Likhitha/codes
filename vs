
import { ApplicationConfig, provideZoneChangeDetection } from '@angular/core';
import { provideRouter } from '@angular/router';

import { routes } from './app.routes';
import { provideClientHydration, withEventReplay } from '@angular/platform-browser';

export const appConfig: ApplicationConfig = {
  providers: [provideZoneChangeDetection({ eventCoalescing: true }), provideRouter(routes), provideClientHydration(withEventReplay())]
};
import { Routes } from '@angular/router';

export const routes: Routes = [];
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>HealthcareAppointmentProject</title>
  <base href="/">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="icon" type="image/x-icon" href="favicon.ico">
</head>
<body>
  <app-root></app-root>
</body>
</html>
import { bootstrapApplication } from '@angular/platform-browser';
import { appConfig } from './app/app.config';
import { AppComponent } from './app/app.component';

bootstrapApplication(AppComponent, appConfig)
  .catch((err) => console.error(err));
import {
  AngularNodeAppEngine,
  createNodeRequestHandler,
  isMainModule,
  writeResponseToNodeResponse,
} from '@angular/ssr/node';
import express from 'express';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const serverDistFolder = dirname(fileURLToPath(import.meta.url));
const browserDistFolder = resolve(serverDistFolder, '../browser');

const app = express();
const angularApp = new AngularNodeAppEngine();

/**
 * Example Express Rest API endpoints can be defined here.
 * Uncomment and define endpoints as necessary.
 *
 * Example:
 * ```ts
 * app.get('/api/**', (req, res) => {
 *   // Handle API request
 * });
 * ```
 */

/**
 * Serve static files from /browser
 */
app.use(
  express.static(browserDistFolder, {
    maxAge: '1y',
    index: false,
    redirect: false,
  }),
);

/**
 * Handle all other requests by rendering the Angular application.
 */
app.use('/**', (req, res, next) => {
  angularApp
    .handle(req)
    .then((response) =>
      response ? writeResponseToNodeResponse(response, res) : next(),
    )
    .catch(next);
});

/**
 * Start the server if this module is the main entry point.
 * The server listens on the port defined by the `PORT` environment variable, or defaults to 4000.
 */
if (isMainModule(import.meta.url)) {
  const port = process.env['PORT'] || 4000;
  app.listen(port, () => {
    console.log(`Node Express server listening on http://localhost:${port}`);
  });
}

/**
 * Request handler used by the Angular CLI (for dev-server and during build) or Firebase Cloud Functions.
 */
export const reqHandler = createNodeRequestHandler(app);
C:\angular> cd healthcare-appointment-project
PS C:\angular\healthcare-appointment-project> npm version
{
  'healthcare-appointment-project': '0.0.0',
  npm: '10.9.2',
  node: '23.11.0',
  acorn: '8.14.1',
  ada: '3.2.1',
  amaro: '0.4.1',
  ares: '1.34.4',
  brotli: '1.1.0',
  cjs_module_lexer: '2.1.0',
  cldr: '46.0',
  icu: '76.1',
  llhttp: '9.2.1',
  modules: '131',
  napi: '10',
  nbytes: '0.1.1',
  ncrypto: '0.0.1',
  nghttp2: '1.64.0',
  openssl: '3.0.16',
  simdjson: '3.12.2',
  simdutf: '6.0.3',
  sqlite: '3.49.1',
  tz: '2025a',
  undici: '6.21.2',
  unicode: '16.0',
  uv: '1.50.0',
  uvwasi: '0.0.21',
  v8: '12.9.202.28-node.14',
  zlib: '1.3.0.1-motley-788cb3c',
  zstd: '1.5.6'
}
PS C:\angular\healthcare-appointment-project> 
