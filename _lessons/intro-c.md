---
layout: lessonTxt
---
<div class="paginationDiv">
<div class="pagination">
  <a onclick="loadOnClick('{{site.baseurl}}/lessons/', 'intro-b.html','', false)" href="javascript:void(0);">&laquo;</a>
  <a onclick="loadOnClick('{{site.baseurl}}/lessons/', 'intro-a.html','', false)" href="javascript:void(0);">1</a>
  <a onclick="loadOnClick('{{site.baseurl}}/lessons/', 'intro-b.html','', false)" href="javascript:void(0);">2</a>
  <a class="active" href="#">3</a>
  <a onclick="loadOnClick('{{site.baseurl}}/lessons/', 'intro-d.html','', false)" href="javascript:void(0);">4</a>
  <a onclick="loadOnClick('{{site.baseurl}}/lessons/', 'intro-e.html','', false)" href="javascript:void(0);">5</a>
  <a onclick="loadOnClick('{{site.baseurl}}/lessons/', 'intro-d.html','', false)" href="javascript:void(0);">&raquo;</a>
</div>
</div>
<hr>
<br>
# <center>Instrucciones</center>
<br>

## La partitura de Csound


* En la partitura utilizaremos tan sólo dos instrucciones:
  * Las <b>instrucciones-i</b> nos permiten activar la ejecución de un instrumento. Son el equivalente a las notas en un pentagrama.
  * Las <b>instrucciones-f</b> sirven para invocar funciones de generación llamadas rutinas GEN. Como resultado obtendremos una <i>tabla</i> que contendrá valores que luego serán utilizados por los instrumentos.

* Cada instrucción se configura utilizando los distintos campos de parámetros, también llamados <b>campos-p</b>, separados entre sí por espacios.

* También utilizaremos <b>comentarios</b> en español:
  * Para Csound, un comentario es todo lo que esté después de un <b>;</b> y hasta el final de la línea. Por ejemplo:
     ```
     ; esto es un comentario.
     ```
  * Los comentarios solo nos sirven a nosotros, los seres humanos. Csound los ignora.

  
<br>
