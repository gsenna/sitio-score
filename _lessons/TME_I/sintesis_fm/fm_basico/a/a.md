---
layout: lessonTxt
---


# <center>Síntesis FM</center>

<br>

{% assign urlPage = {{page.url}} | split: 'index' %}

## Click para ver <a href="#" onclick="document.getElementById('loadDiv').style.display='block';">Diagrama de Bloques</a>

<br>

| Campo-p  | Descripción                                     | Ejemplo |
| :------: | :---------------------------------------------- | ------- |
|   p4     | Amplitud en un rango [0 - 1].                   |    0.5  |
|   p5     | Frecuencia portante.                            |    440  |
|   p6     | Desviación máxima.                              |   1200  |
|   p7     | Frecuencia modulante.                           |    440  |
|   p8     | Localización en la imágen estéreo [L:0 - R:1].  |    0.5  |
|   p9     | Envío a la reverberación expresado como factor. |    0.8  |


<br>



## Notas

* <b>Síntesis FM</b>: Alterar la frecuencia de un oscilador (onda portadora) de acuerdo a la amplitud de una señal modulante (onda moduladora).

  * Si la <i>onda moduladora</i> usa frecuencias sub-audibles &rarr; <i>Vibrato</i>.

* La frecuencia central (<b>fc</b>) va a sufrir desvíos hacia arriba y hacia abajo según la amplitud de la onda moduladora (<b>d</b>).

   * <b>d</b> representa entonces la desviación máxima.
   
   * A pesar de ser una amplitud, lo correcto es hablar de <b>d</b> en Hz.
   
   * Si <b>d</b> es 0: no hay modulación.

* La modulación de <b>fc</b> va a producir periodicidades que van a enriquecer el espectro con nuevos componentes espectrales llamados <i>bandas laterales</i>.

  * Además de <b>fc</b> vamos a tener en el espectro a <b>fc</b> &plusmn; los armónicos de <b>fm</b>.

* <b>fm</b> va a determinar el espacio que va a haber entre la portadora y los componentes espectrales.
  
* La distribución de la energía en el espectro dependerá en parte de <b>d</b>.

  * Si <b>d</b> es igual a cero: No hay modulación y toda la energía estará puesta en la portadora.
  
  * Al incrementar <b>d</b>: las bandas laterales adquieren mayor amplitud, a expensas de la amplitud de la portadora.
  
    * Cuanto mayor sea <b>d</b>, mayor será el nro. de bandas laterales con una amplitud significativa.
    
    * <b>d</b> puede actuar como control del ancho de banda del espectro de la <i>fm</i>.
    
* Usando la fórmula <b>d / fm</b> obtenemos el llamado <i>Índice de Modulación</i> (<b>I</b>).

  * La banda lateral de índice más alto con amplitud significativa tendrá una frecuencia de <b>fc &plusmn; fm * (I + 1)</b>, redondeando <b>I</b> al entero más cercano.
  
  * Por otra parte, la <i>regla de Carson</i> nos dice que aproximadamente el 98% de toda la potencia disponible en la señal <i>fm</i> se concentrará en el ancho de banda <b>2 * (d + fm)</b>.

<br>


<script>
function hideDiv() {
    document.getElementById('loadDiv').style.display='none';
}
document.getElementById('loadDiv').innerHTML = "";
document.getElementById('loadDiv').style.background = 'black url({{site.baseurl}}{{urlPage}}/../fm_basico.svg) no-repeat center center fixed';
document.getElementById('loadDiv').style.webkitBackgroundSize = '100% 100vh';

document.getElementById('loadDiv').onclick = hideDiv;
</script>




