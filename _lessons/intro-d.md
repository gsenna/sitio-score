---
layout: lessonTxt
---
<div class="paginationDiv">
<div class="pagination">
  <a onclick="loadOnClick('{{site.baseurl}}/lessons/', 'intro-c.html','', false)" href="javascript:void(0);">&laquo;</a>
  <a onclick="loadOnClick('{{site.baseurl}}/lessons/', 'intro-a.html','', false)" href="javascript:void(0);">1</a>
  <a onclick="loadOnClick('{{site.baseurl}}/lessons/', 'intro-b.html','', false)" href="javascript:void(0);">2</a>
  <a onclick="loadOnClick('{{site.baseurl}}/lessons/', 'intro-c.html','', false)" href="javascript:void(0);">3</a>
  <a class="active" href="#">4</a>
  <a onclick="loadOnClick('{{site.baseurl}}/lessons/', 'intro-e.html','', false)" href="javascript:void(0);">5</a>
  <a onclick="loadOnClick('{{site.baseurl}}/lessons/', 'intro-e.html','', false)" href="javascript:void(0);">&raquo;</a>
</div>
</div>
<hr>
<br>
# <center>Instrucciones</center>
<br>
## Instrucciones-i

* Comienzan con la letra <b>i</b>.

* Los campos <b>p1</b>, <b>p2</b> y <b>p3</b> representan en este tipo de instrucción: 


| campo-p |                   referencia                       |   ejemplo  |
|  :---:  |                     :---:                          |    :---:   |
|    p1   |  Número o "Nombre_del_instrumento"                 |  "Aditiva" |
|    p2   |  Tiempo de ataque en beats                         |      0     |
|    p3   |  Duración de la nota en beats                      |      2     |


*  Por defecto trabajaremos con un tempo de 60 BPMs. Por lo tanto, 1 beat = 1 segundo.

* Tomando como referencia el ejemplo anterior nuestra <b>instrucción-i</b> se leería como: una nota que invoca al instrumento llamado "Aditiva", comienza en tiempo = 0s y se mantiene activa durante 2s. En la partitura se vería así:
     ```
     i "Aditiva" 0 2
     ```

* En lugar de un nombre entre comillas los instrumentos también pueden tener un identificador númerico. Por ejemplo, una nota que active al instrumento 10 se vería así:
     ```
     i 10 0 2
     ```

* Los campos-p siguientes son específicos para cada instrumento y serán tratados en el texto que acompaña a los mismos.

* En los campos-p de cada nota también pueden aparecer los siguientes símbolos:

  * El punto (<b>.</b>) invoca al llamado <i>carry</i>. Esto hace que se repita el último valor del mismo campo-p. En verdad, el <i>carry</i> es automático para todas las instrucciones-i consecutivas de un mismo instrumento. Luego, estas tres líneas obtendrán los mismos valores-p:
     ```
     i 1   0     4   0.5    440
     i 1   0     4     .      .
     i
     ```
  * El signo de la suma (<b>+</b>) puede usarse en el campo-p2, que obtendrá un valor igual a la suma p2+p3 de la nota anterior. El <i>carry</i>, implícito o explícito, también repite al signo <b>+</b>.
     ```
     i 1   0    .5   100             ; p2 =   0
     i .   +                         ; p2 = 0.5
     i .                             ; p2 =   1
     ```
  * El signo menor que (<b>&lt;</b>) genera una interpolación lineal basada en el tiempo entre la nota anterior y la posterior. Válido para campos-p mayores a 3. Ejemplo:
     ```
     i 1   0    1    100             ; p4 = 100
     i 1   1    1    <               ; p4 = 200
     i 1   2    1    <               ; p4 = 300
     i 1   3    1    400             ; p4 = 400
     i 1   4    1    <               ; p4 = 200
     i 1   5    1    0               ; p4 =   0
     ```

<br>
