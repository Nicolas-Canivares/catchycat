# catchycat 🐈‍⬛
Juego Jam 2025 CatchyCat

## Descripción

Juego 2D de un solo jugador, top-down pixelart de aventura y recolección en donde el jugador toma control de un pequeño gatito morado cuyo objetivo es huir de sus dueños, que pretenden llevarlo al veterinario, encontrando objetos que le ayudarán a escapar mientras se enfrenta a distintos enemigos y superando dificultades cada vez más complicadas.

### Género
Aventura
### Plataforma
PC
### Publico objetivo
Jóvenes y adultos entre 13 a 27 años, amantes de los animalitos, específicamente gatos.
### Motor usado
Godot

### Cámara
Dinámica, sigue al jugador

### Mecánicas
    - Movimiento del jugador con WASD
    - Recoger al interactuar con objetos claves para el progreso de niveles con la tecla E.
    - Esconderse al interactuar con arbustos, cajas o basureros con la tecla E.
    - Esquivar al presionar tecla Ctrl en el momento preciso del ataque del enemigo.
    - Escapar/soltarse al presionar repetidas veces en un corto periodo de tiempo la tecla Space.

### Enemigos

#### Dueño
Único enemigo que sigue constantemente al jugador, tiene su propia estamina por lo que eventualmente se cansará dándole unos segundos al jugador de poder alejarse. Cuando el jugador se esconde, el dueño deja de perseguirlo y recorre el mapa con un patrón determinado hasta que el jugador sale del escondite. En caso de ser atrapado por el dueño, el jugador deberá apretar repetidas veces el espacio para escapar del agarre.

#### Niños
Campo de visión. Los niños aparecen en los mapas del exterior de la casa (plaza, ciudad, etc) normalmente recurridos por infantes. Una vez perciben al jugador lo siguen hasta atraparlo, para escapar del agarre deberá apretar repetidas veces el espacio.

#### Godzilla Juguete
Un Godzilla pequeño robot que pertenece a un niño, tira agua (no le gusta a los gatos) si detecta a alguien pasando por su zona.

#### Cuidado Animal
Campo de visión. Aparecen mayormente en la ciudad (propuesta: dos en la ciudad, uno en la plaza). Si ven al jugador, lo persiguen hasta atacar con el bastón de captura que debe ser esquivado para sobrevivir. Para esquivarlos se debe apretar la tecla Ctrl en el momento preciso del ataque.

#### Perros
Campo de visión. Son los enemigos más rápidos cuando el jugador entra en el campo de visión, si se los esquiva correctamente tardan más tiempo en recuperarse. Para esquivarlos se debe apretar la tecla Ctrl en el momento preciso del ataque.

#### Ratas
En un nivel de alcantarillas.

#### Palomas
Quieren venganza por todas las veces que el gato se los quería comer, en la plaza porque son muchas.