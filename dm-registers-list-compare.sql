CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;

alter table dm_list
drop column IF EXISTS "normalize_name";

alter table dm_list
add column "normalize_name" text;

UPDATE dm_list SET normalize_name = ___potential_organisation_name;

UPDATE dm_list
   set "normalize_name" = regexp_replace(replace(replace(replace(replace(replace(replace(replace(LOWER("normalize_name"), 'district council', ''), 'city council', ''), 'metropolitan borough council', ''), 'and', ''), 'council', ''), 'borough', ''), 'county', ''), '[^\w]+','', 'g');

SELECT id, ___potential_organisation_name, gov_orgs.name as "registers_name", "EMAIL_DOMAIN"
	FROM public.dm_list
    left outer JOIN gov_orgs ON LEVENSHTEIN((dm_list.normalize_name), gov_orgs.normalize_name) <= 1
    order by gov_orgs.name
