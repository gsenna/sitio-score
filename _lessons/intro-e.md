---
layout: lessonTxt
---
<div class="paginationDiv">
<div class="pagination">
  <a onclick="loadOnClick('{{site.baseurl}}/lessons/', 'intro-d.html','', false)" href="javascript:void(0);">&laquo;</a>
  <a onclick="loadOnClick('{{site.baseurl}}/lessons/', 'intro-a.html','', false)" href="javascript:void(0);">1</a>
  <a onclick="loadOnClick('{{site.baseurl}}/lessons/', 'intro-b.html','', false)" href="javascript:void(0);">2</a>
  <a onclick="loadOnClick('{{site.baseurl}}/lessons/', 'intro-c.html','', false)" href="javascript:void(0);">3</a>
  <a onclick="loadOnClick('{{site.baseurl}}/lessons/', 'intro-d.html','', false)" href="javascript:void(0);">4</a>
  <a class="active" href="#">5</a>
  <a href="#">&raquo;</a>
</div>
</div>
<hr>
<br>
# <center>Instrucciones</center>
<br>
## Instrucciones-f

* Comienzan con la letra '<b>f</b>'.

* Los campos <b>p1</b>, <b>p2</b>, <b>p3</b> y <b>p4</b> representan en este tipo de instrucción: 


| campo-p |                     referencia                               |   ejemplo  |
|  :---:  |                       :---:                                  |    :---:   |
|    p1   |  Número de la tabla a crear.                                 |      1     |
|    p2   |  Tiempo de acción de la función en beats.                    |      0     |
|    p3   |  Tamaño de la tabla   →   2<sup>n</sup> ó 2<sup>n</sup> + 1. |    4097    |
|    p4   |  Número de la <b>Rutina GEN</b>. Puede ser negativo.         |      7     |

 
* Cada tabla debe tener un número único (<b>p1</b>) que la identifique y no se repita en otras tablas.

* El tiempo de acción (<b>p2</b>) suele ser siempre 0 ya que existan pocas circunstancias en las que demorar la generación puede servirnos.

* Cuanto mayor sea el tamaño de la tabla (<b>p3</b>), mayor precisión tendrán nuestros segmentos.

  * Los opcodes que realizan una lectura ciclica de la tabla (por ejemplo, osciladores) requieren de una tabla con tamaño 2<sup>n</sup>.

  * Los opcodes que hacen una única pasada por la tabla (por ejemplo, aquellos que usamos para generar una envolvente de amplitud) requieren de una tabla con tamaño 2<sup>n</sup> + 1.
  
  * ¡Ambos casos serán debidamente considerados en el texto que acompaña a los instrumentos del menú!
  
* El "dibujo" de una tabla depende de funciones llamadas <i>Rutinas GEN</i> (<b>p4</b>). Por ejemplo, la rutina <b>GEN 05</b> nos permite crear segmentos exponenciales, mientras que la rutina <b>GEN 07</b> es capaz de producir segmentos lineales.

  * Si el número de la <i>Rutina GEN</i> es <b>positivo</b>, los valores que resulten de la generación serán normalizados. Dependiendo de la <b>Rutina GEN</b> podemos terminar con valores que van entre 0 y 1 (ondas unipolares), o bien -1 y +1 (ondas bipolares).

  * Si el número de la <i>Rutina GEN</i> es <b>negativo</b>, los valores serán conservados tal cual aparecen en la <b>instrucción-f</b>.

* Los <b>campos-p</b> siguientes son específicos para cada <i>Rutina GEN</i>.
  * Recomendamos usar <a target="_blank" rel="noopener noreferrer" href="https://gsenna.github.io/tablas/">esta</a> herramienta para dibujar las tablas y estudiar cómo construir la línea de cada <i>Rutina GEN</i>.

<br>

* Un ejemplo de <b>instrucción-f</b> en la partitura se vería así: 
     ```
     f 1 0 4097 -7 220 4097 440
     ```
* El mismo se leería como: creación de la tabla 1 a los 0s. El tamaño de la tabla es de 4097 puntos y se usó la <b>Rutina GEN 07</b> para crear un segmento lineal que vaya del 220 al 440 en 4097 puntos. El <b>campo-p4</b> negativo evitará la normalización de los valores.    


<br>
