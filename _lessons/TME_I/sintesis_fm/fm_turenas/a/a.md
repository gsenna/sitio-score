---
layout: lessonTxt
---


# <center>Síntesis FM tipo Turenas</center>
<br>

{% assign urlPage = {{page.url}} | split: 'index' %}

## Click para ver <a href="#" onclick="document.getElementById('loadDiv').style.display='block';">Diagrama de Bloques</a>

<br>

| Campo-p  | Descripción                                     | Ejemplo |
| :------: | :---------------------------------------------- | ------- |
|   p4     | Amplitud en dBFS.                               |    -22  |
|   p5     | Frecuencia portante.                            |   1278  |
|   p6     | Divisor de la frecuencia portante.              |  0.896  |
|   p7     | Índice de modulación máximo.                    |    2.5  |
|   p8     | Índice de modulación mínimo.                    |      0  |
|   p9     | Función de envolvente de intensidad.            |      2  |
|   p10    | Función de envolvente de índice de modulación.  |      6  |
|   p11    | Localización en la imágen estéreo [L:0 - R:1].  |    0.5  |
|   p12    | Envío a la reverberación expresado como factor. |    0.8  |

<br>



## Tablas

Las tablas usadas en el ejemplo, tanto para la envolvente de intensidad como para la del índice de modulación, serán leídas una sóla vez (freq=1/p3) y por tanto debemos darle un tamaño del tipo 2<sup>n</sup> + 1.
 * <b>f2</b>:
<img src="{{site.baseurl}}{{urlPage}}/../f2.png">
 * <b>f3</b>:
<img src="{{site.baseurl}}{{urlPage}}/../f3.png">
 * <b>f4</b>:
<img src="{{site.baseurl}}{{urlPage}}/../f4.png">
 * <b>f5</b>:
<img src="{{site.baseurl}}{{urlPage}}/../f5.png">
 * <b>f6</b>:
<img src="{{site.baseurl}}{{urlPage}}/../f6.png">
 * <b>f7</b>:
<img src="{{site.baseurl}}{{urlPage}}/../f7.png">

<br>

<script>
function hideDiv() {
    document.getElementById('loadDiv').style.display='none';
}
document.getElementById('loadDiv').innerHTML = "";
document.getElementById('loadDiv').style.background = 'black url({{site.baseurl}}{{urlPage}}/../fm_turenas.svg) no-repeat center center fixed';
document.getElementById('loadDiv').style.webkitBackgroundSize = '100% 100vh';

document.getElementById('loadDiv').onclick = hideDiv;
</script>

