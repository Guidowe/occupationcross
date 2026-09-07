# occupationcross 1.1.0

We did an update to be able to work with Colombian data. One can now convert old CNO-70 occupational codes (which DANE used in the GEIH up to 2021) into the modern ISCO-08 standard. To do this one can use the new cno70_to_isco08() function, or simply set "CNO70" as origin in reclassify_to_isco08().

Since the old 2-digit codes often split into several modern categories, we added an allocation argument. The default ("uniform") picks a match at random, but the new "weighted" option assigns codes proportionally based on the actual 2022 GEIH distribution (the first year DANE used the new system).

For this purpose, we included the necessary datasets (crosswalks, weights, and sample data for 2019 and 2024) and updated our internal lists. We also fixed a little error in the isco88_to_isco08_ndigit() docs.

---

Hicimos una actualización para poder trabajar con datos de Colombia. Ahora se puede pasar de los códigos de ocupación viejos (CNO-70, que usó el DANE en la GEIH hasta 2021) al estándar actual CIUO-08. Para hacerlo se usa la nueva función cno70_to_isco08() o directamente se pone "CNO70" como origen en reclassify_to_isco08().

Como los códigos viejos de dos dígitos a veces equivalen a varias categorías nuevas, agregamos el argumento allocation. Por defecto el paquete elige una opción al azar entre las posibles ("uniform"), pero con "weighted" hace una asignación proporcional usando la distribución real de la GEIH 2022 (el primer año que el DANE usó el sistema nuevo).

Para ello, incluimos los datasets necesarios (tablas de correspondencia, ponderadores y bases de prueba de 2019 y 2024) y actualizamos las listas internas. También arreglamos un pequeño error en la documentación de isco88_to_isco08_ndigit().