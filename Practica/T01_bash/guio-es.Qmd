---
title: "Práctica 1. Nociones de Bash y alineamientos básicos"
lang: es
date: today
execute: 
  output: true
  error: true
engine: knitr
bibliography: ../../references.bib
language:
   title-block-published: "Última actualización:"
   section-title-references: "Bibliografía"
format:
   html:
      embed-resources: true
---

# Preparación
Hacen falta los programas `needle` y `water` de [EMBOS](http://emboss.open-bio.org/),
el programa [`exonerate`](https://www.animalgenome.org/bioinfo/resources/manuals/exonerate/index.html)
[@Slater2005], y el programa [`muscle`](https://www.drive5.com/muscle5/)[@Edgar2022].
Para la descarga automática de secuencias usaremos el programa `wget`. En sistemas
operativos basados en Debian, seguramente se pueden instalar los cinco programas
así (con privilegios administrativos):

```
apt install emboss exonerate wget muscle
```

# Objetivos
1. Practicar los comandos básicos de Bash.
2. Generar la estructura del cuaderno de prácticas.
3. Realizar algunos alineamientos básicos.

# Comandos básicos

| Comando   | Función   |
| --------- |:--------- |
| pwd       | Conocer la dirección absoluta del directorio actual |
| cd ..     | Cambiar al directorio superior |
| cd a      | Entrar en el directorio "a"    |
| cp a b    | Crear una copia "b" del archivo "a" |
| mv a b    | Renombrar el archivo "a" como "b"   |
| mkdir a   | Crear el directorio "a" |
| rm a      | Eliminar el *archivo* "a" |
| rm -r a   | Eliminar el *directorio* "a" y su contenido |
| touch a   | Crear el archivo vacío "a" o actualizar su fecha de consulta si ya existía |

::: {.callout-tip title="Consejo"}
Amplía la tabla modificando el documento fuente.
:::

:::{.callout-note icon=false}
## Ejercicio 1
Escoge un lugar adecuado en el árbol de directorios de tu ordenador para crear
la carpeta que contendrá tu cuaderno de prácticas, en el cual incluirás tu propia
versión de este primer guión. El *cuaderno* será una **carpeta** entera. Dale un
nombre adecuado y genera esta estructura en su interior usando los comandos de
Bash que has aprendido:

```
├── data
├── doc
└── results
    ├── 2026-01-29
    │   └── README.Qmd
    ├── 2026-02-03
    ├── 2026-02-10
    ├── 2026-02-17
    ├── 2026-02-24
    ├── 2026-03-03
    ├── 2026-03-10
    ├── 2026-03-24
    ├── 2026-03-31
    ├── 2026-04-15
    ├── 2026-04-21
    ├── 2026-04-28
    └── 2026-05-05

```
:::

# Alineamiento de pares de secuencia
En los enlaces siguientes encontrarás las secuencias descritas a continuación:

- [HumanChr17](https://rest.ensembl.org/sequence/region/human/17:63832000..63843000:1) 
  Un fragmento del cromosoma 17 humano.
- [ChimpChr17](https://rest.ensembl.org/sequence/region/chimpanzee/17:63309800..63321000:1)
  Un fragmento del cromosoma 17 de chimpancé, homólogo al anterior.
- [HumanSMARCD2](https://www.ebi.ac.uk/ena/browser/api/fasta/AAI36323.1) Tránscrito
  del gen SMARCD2 humano.
- [ChimpSMARCD2](https://www.ebi.ac.uk/ena/browser/api/fasta/PNJ01291.1) Tránscrito
  del gen SMARCD2 de chimpancé.

El objetivo es alinear los tránscritos a sus respectivos fragmentos genómicos
y comprobar que el alineamiento predice correctamente la estructura de intrones
y exones del gen. Si las herramientas de [EMBOSS](http://emboss.open-bio.org/)
están instaladas, podemos usar los programas
  [`needle`](http://emboss.open-bio.org/rel/rel6/apps/needle.html)
  o [`water`](http://emboss.open-bio.org/rel/rel6/apps/water.html)
para realizar el alineamiento desde la linea de órdenes mediante los algoritmos
de Needleman-Wunsch o de Smith-Waterman, respectivamente. Puedes consultar la
ayuda completa de estas herramientas ejecutando `needle -help -verbose` o
`water -help -verbose`. Las órdenes siguientes descargan dos de las secuencias
y las alinean con `needle`, a modo de ejemplo. El resultado del alineamiento
debería guardarse en un archivo en formato de texto.

```{bash}
#| eval: false
# Sólo queremos ejecutar el código si los resultados no
# están ya disponibles, es decir, si el archivo de salida no existe.
if [ ! -e aln1.txt ]; then
   # Sólo descargaremos las secuencias, si no están ya descargadas.
   if [ ! -e HumanSMARCD2.fa ]; then
      # Con la opción "-O" (letra mayúscula, no número cero) indicamos
      # el nombre del archivo donde queremos guardar la secuencia.
      wget -O HumanSMARCD2.fa https://www.ebi.ac.uk/ena/browser/api/fasta/AAI36323.1
   fi
   if [ ! -e HumanChr17.fa ]; then
      wget -O HumanChr17.fa \
         https://rest.ensembl.org/sequence/region/human/17:63832000..63843000:1?content-type=text/x-fasta
   fi
   # Utilizamos el carácter "\" para que Bash ignore el salto de línea
   # y poder distribuir los argumentos y opciones en más de una línea.
   needle -asequence HumanChr17.fa \
          -bsequence HumanaSMARCD2.fa \
          -gapopen 15.0 \
          -gapextend 0.5 \
          -auto \
          -outfile aln1.txt
fi
```

:::{.callout-note icon=false}
## Desafíos
0. Lee detenidamente las órdenes y los comentarios y asegúrate de entenderlos.
1. Si al ejecutarlas aparece algún mensaje de error, léelo y corrige el error.
2. Lee la ayuda del programa `needle` e intenta ajustar los parámetros
   para obtener un alineamiento más convincente.
3. Prueba el programa `water`, para que el alineamiento sea local.
4. Intenta guardar el alineamiento en formato FASTA.
5. Alinea también el tránscrito de SMARCD2 de chimpancé a su cromosoma.
6. Alinea también los dos fragmentos cromosómicos.
:::

Para alinear tránscritos o incluso proteínas a un genoma de referencia, es mejor
usar el programa `exonerate` [@Slater2005], que puede aplicar los parámetros más
adecuados para este tipo de tarea. Puedes leer la documentación de `exonerate`
mediante las órdenes `man exonerate` o `exonerate --help`. También existe
[documentación online sobre este programa](https://www.animalgenome.org/bioinfo/resources/manuals/exonerate/index.html).
En el bloque siguiente repetimos el mismo alineamiento que antes, con `exonerate`.

```{bash}
#| eval: true
#| output: true
#| error: true

if [ ! -e HumanSMARCD2.fa ]; then
   wget -O HumanSMARCD2.fa https://www.ebi.ac.uk/ena/browser/api/fasta/AAI36323.1
fi
if [ ! -e HumanChr17.fa ]; then
   wget -O HumanChr17.fa \
      https://rest.ensembl.org/sequence/region/human/17:63832000..63843000:1?content-type=text/x-fasta
fi
exonerate --model est2genome HumanSMARCD2.fa HumanChr17.fa
```

En este caso, el alineamiento resultante no se ha enviado a un archivo, sino al
*standard output*, que Quarto recoge y presenta en este mismo documento. Por eso,
no hemos condicionado la ejecución.

:::{.callout-note icon=false}
## Desafío
¿Cómo puedes enviar el resultado de `exonerate` a un archivo?
:::

# Apéndice. Alineamientos múltiples
Un programa muy popular para alineamiento de múltiples secuencias es
[`muscle`](https://drive5.com/muscle/) [@Edgar2022]. Suponiendo que está
instalado, vamos a probarlo con una colección de secuencias que pertenecen
a la familia [PF00009](https://www.ebi.ac.uk/interpro/entry/pfam/PF00009/):

```{bash}
if [ ! -e PF00009.fa ]; then
   wget -O PF00009.fa https://raw.githubusercontent.com/rcedgar/balifam/refs/heads/main/balifam100/in/PF00009.100
fi

if [ ! -e PF00009.afa ]; then
   muscle -align PF00009.fa -output PF00009.afa
fi
```

Para visualizar el alineamiento, podemos usar la función `BrowseSeqs()`,
del paquete `DECIPHER` en el entorno de R. Esta función nos permite enviar el
alineamiento a un archivo HTML, que puede abrirse en una ventana nueva. Si estamos
compilando un documento HTML, podemos incorporar el alineamiento en el mismo documento
mediante la función `includeHTML()` del paquete `htmltools`, al precio de
aumentar considerablemente su tamaño.

```{r}
#| messages: false
#| warning: false

library('htmltools')
library('DECIPHER')
PF00009 <- readAAStringSet('PF00009.afa')
BrowseSeqs(PF00009, htmlFile = 'PF00009.html', openURL = FALSE)
includeHTML('./PF00009.html')
```

# Bibliografía