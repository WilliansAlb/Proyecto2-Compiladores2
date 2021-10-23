<br />
<p align="center">
  <a href="https://github.com/WilliansAlb/Proyecto2-Compiladores2/blob/master/Frontend/GeneradorCodigoIntermedio/src/assets/img/program.png">
    <img src="https://github.com/WilliansAlb/Proyecto2-Compiladores2/blob/master/Frontend/GeneradorCodigoIntermedio/src/assets/img/program.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Generador de codigo intermedio</h3>
</p>

# DESCRIPCION DE LA APLICACION
Aplicación web que simula ser un IDE que genera codigo de tres direcciones mediante el ingreso de codigo python, codigo java y codigo c.

# FRONTEND Y BACKEND
La aplicación en su totalidad se encuentra dividida en dos partes, la parte del frontend y la parte del backend.
La parte del frontend es la encargada de realizar todos los análisis pertinentes para la generación de codigo de tres direcciones; así la parte del backend es la encargada de guardar los proyectos y crear los ejecutables C y Assembler cuando se le solicite.

# HERRAMIENTAS UTILIZADAS
- Apache Netbeans 12.0: para editar todo el código del backend
- Apache Tomcat 9.0.44: para servir el backend
- Visual Studio Code: para editar todo el código del frontend
- Angular 12: para servir el frontend
- Jison: para realizar el analisis léxico, sintactico y semantico

# INSTALACION Y USO
Se debe de clonar el repositorio para empezar a usarlo, en los apartados siguientes se aclaran las formas de instalación de cada parte del proyecto
## FRONTEND
Nos posicionamos en la carpeta Frontend/GeneradorCodigoIntermedio y abrimos una consola donde deberemos de cargar los modulos de node con 
```
npm install
```
Esto nos descargara todos los modulos de node que el proyecto necesita, luego de que se descarguen correctamente servimos el frontend con
```
npm run iniciar
```
Para visualizar el proyecto entraremos a la ruta http://localhost:4200/
## BACKEND
Para el correcto funcionamiento del frontend es de vital importancia el iniciar el servidor que proporcionará el backend, abrimos el proyecto en Netbeans. Y corremos el proyecto.
