---
layout: lessonTxt
---

# <center>Síntesis Aditiva con Valores Fijos</center>

<br>

{% assign urlPage = {{page.url}} | split: 'index' %}

## Click para ver <a href="#" onclick="document.getElementById('loadDiv').style.display='block';">Diagrama de Bloques</a>

<br>

| Campo-p  | Descripción                                       | Ejemplo |
| :------: | :------------------------------------------------ | ------- |
|   p4     | Amplitud en el rango [0 - 1].                     |    0.4  |
|   p5     | Frecuencia.                                       |   1278  |
|   p6     | Factor multiplicador de la amplitud.              |    0.5  |
|   p7     | Factor multiplicador de la frecuencia.            |      2  |
|   p8     | Localización en la imágen estéreo [L:0 - R:1].    |    0.5  |
|   p9     | Envío a la reverberación expresado como factor.   |    0.8  |
|   p10    | Número de la tabla que contiene la forma de onda. |     -1  |
|   p11    | Fase inicial.                                     |      0  |

<br>
<!---

|   REF    |     =    |  Descripción                                       |
| :------: | :------: | :------------------------------------------------- |
|   DUR    |     p3   | Duración de la nota.                               |
|   AMP    |     p4   | Amplitud en el rango [0 - 1].                      |
|   FREQ   |     p5   | Frecuencia fija.                                   |
|   PHASE  |     p11  | Fase inicial.                                      |
|    WF    |     p10  | Forma de onda.                                     |
|    X     |     p6   | Factor multiplicador de la amplitud.               |
|    Y     |     p7   | Factor multiplicador de la frecuencia.             |
|   PAN    |     p8   | Localización en la imágen estéreo [L:0  - R:1].    |
|   REV    |     p9   | Envío a la reverberación expresado como  factor.   |


<br>

|   REF    |     =    |  Descripción                                                        |
| :------: | :------: | :------------------------------------------------------------------ |
|   DUR    |     p3   | Duración de la nota.                                                |
|    F1    |    -p4   | Tabla con valores de amplitud.                                      |
|    F2    |    -p5   | Tabla con valores de frecuencia.                                    |
|   PHASE  |     p11  | Fase inicial.                                                       |
|    WF    |     p10  | Forma de onda.                                                      |
|    X     |     p6   | Factor multiplicador de la amplitud.                                |
|    Y     |     p7   | Factor multiplicador de la frecuencia.                              |
|    F3    |    -p8   | Tabla con valores de paneo.                                         |
|    F4    |    -p9   | Tabla con factores de envío a la reverb.                            |


<br>

-->

## Notas

* En el primer objeto sonoro se utilizan los factores multiplicadores en p6 y p7 para controlar la amplitud y la frecuencia de cada parcial.
  
  * En el campo p6 se utiliza la forma <b>[exp]</b> con corchetes para que Csound resuelva las expresiones antes de pasar el valor al instrumento. Entonces, por ejemplo, mientras que en la partitura vemos escrito <b>[1/2]</b>, podemos estar seguros que la instancia del instrumento correspondiente a esa nota recibirá el valor <b>0.5</b> para el campo p6.

* En el segundo objeto sonoro se utilizan los valores directos de amplitud en p4 y p5, multiplicando todo por 1 en p6 y p7.

  * Sólo se definieron los campos-p completos en el primer parcial. El resto toma los valores a través del <i>carry</i> implícito.

<br>

<script>
function hideDiv() {
    document.getElementById('loadDiv').style.display='none';
}
document.getElementById('loadDiv').innerHTML = "";
document.getElementById('loadDiv').style.background = 'black url({{site.baseurl}}{{urlPage}}/../aditiva_fija.svg) no-repeat center center fixed';
document.getElementById('loadDiv').style.webkitBackgroundSize = '100% 100vh';

document.getElementById('loadDiv').onclick = hideDiv;
</script>



