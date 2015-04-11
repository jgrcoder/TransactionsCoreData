# TransactionsCoreData

Programa creado en un tiempo de 3 horas, con acceso a documentación y material personal.
Fue realizado con motivo de una prueba de código durante un proceso selectivo en una empresa.

Se han eliminado toda referencia a la empresa, el ejercicio y las urls originales usadas durante el mismo.

El ejercicio consiste en la descarga asíncrona de un json con transancciones bancarias simuladas. 
Las transacciones se deben mostrar en un TableViewController, sin bloqueo de la UI. 
Un botón de refresco permite una nueva descarga de datos.
Al pulsar en una transacción la vista detalle muestra las distintas monedas en las que la transacción
ha sido realizada y los totales de las mismas.

Todo el ejercicio tiene integrado CoreData y se usa NSFetchedResultController para ordenación y mostrado
de cabeceras.
