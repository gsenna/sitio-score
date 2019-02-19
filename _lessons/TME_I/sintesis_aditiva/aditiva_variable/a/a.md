---
layout: lessonTxt
---


# <center>Síntesis Aditiva con Valores Variables</center>

<br>

{% assign urlPage = {{page.url}} | split: 'index' %}

## Click para ver <a href="#" onclick="document.getElementById('loadDiv').style.display='block';">Diagrama de Bloques</a>

<br>

| Campo-p  | Descripción                                       | Ejemplo |
| :------: | :------------------------------------------------ | ------- |
|  -p4     | Número de tabla con valores de amplitud.          |     -4  |
|  -p5     | Número de tabla con valores de frecuencia.        |     -5  |
|   p6     | Factor multiplicador de la amplitud.              |      1  |
|   p7     | Factor multiplicador de la frecuencia.            |      1  |
|  -p8     | Número de tabla con valores de paneo.             |     -6  |
|  -p9     | Número de tabla con factores de envío a la reverb.|     -7  |
|   p10    | Número de la tabla que contiene la forma de onda. |     -1  |
|   p11    | Fase inicial.                                     |      0  |


<br>


## Notas

* Este es el mismo instrumento usado para realizar la síntesis aditiva con valores fijos.
  
* Usando valores negativos para p4, p5, p8 y/o p9 podemos pasar tablas con valores que varían para cada uno de los cuatro campos-p mencionados.

  * No es necesario usar tablas en todos ellos. Se podría, por ejemplo, aplicar sólo una envolvente de amplitud y dejar el resto de los campos-p con valores fijos.
  

<br>

## Tablas

Las tablas usadas en el ejemplo serán leídas una sóla vez (freq=1/p3) y por tanto debemos darle un tamaño del tipo 2<sup>n</sup> + 1.
 * <b>f1</b>:
<img src="{{site.baseurl}}{{urlPage}}/../f1.png">
 * <b>f2</b>:
<img src="{{site.baseurl}}{{urlPage}}/../f2.png">
 * <b>f5</b>:
<img src="{{site.baseurl}}{{urlPage}}/../f5.png">
 * <b>f20</b>:
<img src="{{site.baseurl}}{{urlPage}}/../f20.png">
 
<br>

<script>
function hideDiv() {
    document.getElementById('loadDiv').style.display='none';
}
document.getElementById('loadDiv').innerHTML = "";
document.getElementById('loadDiv').style.background = 'black url({{site.baseurl}}{{urlPage}}/../aditiva_variable.svg) no-repeat center center fixed';
document.getElementById('loadDiv').style.webkitBackgroundSize = '100% 100vh';

document.getElementById('loadDiv').onclick = hideDiv;
</script>




