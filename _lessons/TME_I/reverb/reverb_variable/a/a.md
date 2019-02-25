---
layout: lessonTxt
---


# <center>Reverb con Valores Variables</center>

<br>

{% assign urlPage = {{page.url}} | split: 'index' %}

## Click para ver <a href="#" onclick="document.getElementById('loadDiv').style.display='block';">Diagrama de Bloques</a>

<br>

| Campo-p  | Descripción                                                                               | Ejemplo |
| :------: | :---------------------------------------------------------------------------------------- | ------- |
|   -p4    | Tabla con valores para el control del tamaño de la sala en el rango [0 - 1].              |    -2   |
|   -p5    | Tabla con las frecuencias de corte para el control del RT de las frecuencias más agudas.  |    -3   |

<br>


## Notas

* Este es el mismo instrumento usado para demostrar la reverb con valores fijos.

* En este ejemplo usaremos como fuente sonora una sinusoide de amplitud variable (ver tabla 1) creada con el instrumento "Aditiva". El envío a la reverb variará según la tabla 2.
  
* Usando valores negativos para p4 y/o p5 podemos pasar tablas con valores que varían para cada uno de los dos campos-p mencionados.

  * El tamaño de la sala (ver tabla 3) comenzará y terminará en 0, pero en su punto máximo alcanzará el equivalente al valor dado para un hall grande.
  
  * La frecuencia de corte de los filtros de control del registro agudo variará según la tabla 4.

  * No es necesario usar tablas en ambos simultáneamente. Se podría, por ejemplo, aplicar sólo una envolvente al control del tamaño de la sala y dejar el control de atenuación de las frecuencias agudas con un valor fijo.


<br>

## Tablas

Las tablas usadas en el ejemplo serán leídas una sóla vez (freq=1/p3) y por tanto debemos darle un tamaño del tipo 2<sup>n</sup> + 1.
 * <b>f1</b>:
<img src="{{site.baseurl}}{{urlPage}}/../f1.png">
 * <b>f2</b>:
<img src="{{site.baseurl}}{{urlPage}}/../f2.png">
 * <b>f3</b>:
<img src="{{site.baseurl}}{{urlPage}}/../f3.png">
 * <b>f4</b>:
<img src="{{site.baseurl}}{{urlPage}}/../f4.png">
 
<br>

<script>
function hideDiv() {
    document.getElementById('loadDiv').style.display='none';
}
document.getElementById('loadDiv').innerHTML = "";
document.getElementById('loadDiv').style.background = 'black url({{site.baseurl}}{{urlPage}}/../reverb_variable.svg) no-repeat center center fixed';
document.getElementById('loadDiv').style.webkitBackgroundSize = '100% 100vh';

document.getElementById('loadDiv').onclick = hideDiv;
</script>




