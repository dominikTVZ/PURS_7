SELECT id, datum, vrijednost FROM korisnikove_temperature 
LEFT JOIN temperatura ON korisnikove_temperature.id_temperature = temperatura.id
WHERE id_korisnika = '{{id_korisnika}}'