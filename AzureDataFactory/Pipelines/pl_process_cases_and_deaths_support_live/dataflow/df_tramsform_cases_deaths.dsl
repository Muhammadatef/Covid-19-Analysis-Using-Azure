source(output(
		country as string,
		country_code as string,
		continent as string,
		population as integer,
		indicator as string,
		daily_count as integer,
		date as date,
		rate_14_day as double,
		source as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	ignoreNoFilesFound: false) ~> CasesAndDeaths
source(output(
		country as string,
		country_code_2_digit as string,
		country_code_3_digit as string,
		continent as string,
		population as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	ignoreNoFilesFound: false) ~> CoutnryLookup
CasesAndDeaths filter(continent == 'Europe' && not(isNull(country_code))) ~> EuropeOnlyFIlter
EuropeOnlyFIlter select(mapColumn(
		country,
		country_code,
		population,
		indicator,
		daily_count,
		source,
		each(match(name=='date'),
			'reported'+'_date' = $$)
	),
	skipDuplicateMapInputs: false,
	skipDuplicateMapOutputs: false) ~> SelectOnlyRequiredFields
SelectOnlyRequiredFields pivot(groupBy(country,
		country_code,
		population,
		source,
		reported_date),
	pivotBy(indicator, ['confirmed cases', 'deaths']),
	count = sum(daily_count),
	columnNaming: '$V_$N',
	lateral: true) ~> PivotCOunts
PivotCOunts, CoutnryLookup lookup(PivotCOunts@country == CoutnryLookup@country,
	multiple: false,
	pickup: 'any',
	broadcast: 'auto')~> LookupCountry
LookupCountry select(mapColumn(
		country = PivotCOunts@country,
		country_code_2_digit,
		country_code_3_digit,
		population = PivotCOunts@population,
		cases_count = {confirmed cases_count},
		deaths_count,
		reported_date,
		source
	),
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true) ~> SelectForSink
SelectForSink sink(allowSchemaDrift: true,
	validateSchema: false,
	partitionFileNames:['case_and_deaths.csv'],
	truncate: true,
	umask: 0022,
	preCommands: [],
	postCommands: [],
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true,
	partitionBy('hash', 1)) ~> CasesAndDeathSInk