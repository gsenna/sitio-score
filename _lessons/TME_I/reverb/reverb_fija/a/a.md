---
layout: lessonTxt
---

# <center>Reverb con Valores Fijos</center>

<br>

{% assign urlPage = {{page.url}} | split: 'index' %}

## Click para ver <a href="#" onclick="document.getElementById('loadDiv').style.display='block';">Diagrama de Bloques</a>

<br>

| Campo-p  | Descripción                                                                            | Ejemplo |
| :------: | :------------------------------------------------------------------------------------- | ------- |
|   p4     | Tamaño de la sala en el rango [0 - 1].                                                 |    0.8  |
|   p5     | Frecuencia de Corte del control del tiempo de reverberación de las frecuencias agudas. |   12000 |

<br>



## Notas

* En este ejemplo usamos como fuente sonora una sinusoide de <i>amplitud=1</i> y <i>freq=440Hz</i> creada con el instrumento "Aditiva". El paneo es hacia el centro y el envío a la reverb será del 100% de la señal directa.
  
* El instrumento "Reverb" es una reverb FDN estéreo. Este tipo de reverb tiene la característica de conservar la energía que ingresa a la misma -al menos en las frecuencias bajas- a la salida.

  * El control del tamaño de la sala (<b>p4</b>) genera -aproximádamente- los siguientes resultados: 0.6 da un sonido de sala pequeña, 0.8 hall pequeño y 0.9 hall grande.
  
  * El control de la frecuencia de corte (<b>p5</b>) actúa sobre filtros pasa bajos de 1er orden. Cuanto más bajo sea este valor, más rápido será el decay de las frecuencias agudas.

* Conviene extender la duración de la nota que activa la reverb para permitir el decaimiento completo de la cola reverberante. 

<br>

<script>
function hideDiv() {
    document.getElementById('loadDiv').style.display='none';
}
document.getElementById('loadDiv').innerHTML = "";
document.getElementById('loadDiv').style.background = 'black url({{site.baseurl}}{{urlPage}}/../reverb_fija.svg) no-repeat center center fixed';
document.getElementById('loadDiv').style.webkitBackgroundSize = '100% 100vh';

document.getElementById('loadDiv').onclick = hideDiv;
</script>



