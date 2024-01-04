SELECT id, datum, vrijednost FROM korisnikove_vlage
LEFT JOIN vlaga ON korisnikove_vlage.id_vlage = vlaga.id
WHERE id_korisnika = '{{id_korisnika}}'