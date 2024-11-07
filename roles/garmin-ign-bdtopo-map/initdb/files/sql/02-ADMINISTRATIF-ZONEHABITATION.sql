DROP TABLE IF EXISTS france_sud.administratif_zone_d_habitation;
CREATE TABLE france_sud.administratif_zone_d_habitation AS
SELECT ST_ChaikinSmoothing(ST_Force2D(ST_TRANSFORM(geometrie, 4326)), 3, false) AS the_geom,
	toponyme AS "NAME",
	'0x03' AS "MP_TYPE",
	'4' AS "EndLevel",
	'20' AS "MPBITLEVEL"
  FROM bdtopo.zone_d_habitation
  WHERE importance IN ('1','2','3')
  AND nature = 'Lieu-dit habité'
  AND methode_d_acquisition_planimetrique != 'Calculé'
  AND NOT toponyme LIKE 'Commune d%';

CREATE INDEX administratif_zone_d_habitation_geom_idx ON france_sud.administratif_zone_d_habitation USING gist (the_geom);