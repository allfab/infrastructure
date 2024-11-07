DROP TABLE IF EXISTS france_sud.administratif_commune;
CREATE TABLE france_sud.administratif_commune AS
SELECT ST_Force2D(ST_TRANSFORM(geometrie, 4326))::geometry(multipolygon, 4326) AS the_geom,
	nom_officiel AS "NAME",
	'0x54' AS "MP_TYPE",
	'France~[0x1d]FRA' AS "Country",
	'France' AS "RegionName",
	nom_officiel AS "CityName",
	code_postal AS "Zip",
	'7' AS "EndLevel",
	'17' AS "MPBITLEVEL"
  FROM bdtopo.commune
  WHERE code_insee_de_la_region IN ('75','76','84','93','94');

CREATE INDEX administratif_commune_geom_idx ON france_sud.administratif_commune USING gist (the_geom);