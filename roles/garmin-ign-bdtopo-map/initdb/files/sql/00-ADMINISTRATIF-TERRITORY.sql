DROP TABLE IF EXISTS france_sud.administratif_territory;
CREATE TABLE france_sud.administratif_territory AS
SELECT ST_Force2D(ST_UNION(geometrie))::geometry(MULTIPOLYGON, 4326) AS the_geom,
	'FRANCE-SUD'::VARCHAR AS territory,
	'v2024.09'::VARCHAR AS version
  FROM bdtopo.region
  WHERE code_insee IN ('75','76','84','93','94');
  
CREATE INDEX administratif_territory_geom_idx ON france_sud.administratif_territory USING gist (the_geom);


-- SELECT ST_Subdivide(the_geom) AS the_geom,
-- 	territory,
-- 	version
--   FROM france_sud.administratif_territory;

-- SELECT ST_Subdivide(the_geom,256,-1) AS the_geom,
-- 	territory,
-- 	version
-- FROM france_sud.administratif_territory;