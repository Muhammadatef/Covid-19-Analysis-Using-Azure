source(output(
		country as string,
		indicator as string,
		date as date,
		year_week as string,
		value as double,
		source as string,
		url as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	ignoreNoFilesFound: false) ~> HospitalAdmissionSource
source(output(
		country as string,
		country_code_2_digit as string,
		country_code_3_digit as string,
		continent as string,
		population as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	ignoreNoFilesFound: false) ~> CountryLookup
source(output(
		date_key as string,
		date as string,
		year as string,
		month as string,
		day as string,
		day_name as string,
		day_of_year as string,
		week_of_month as string,
		week_of_year as string,
		month_name as string,
		year_month as string,
		year_week as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	ignoreNoFilesFound: false) ~> DimDateSource
HospitalAdmissionSource select(mapColumn(
		country,
		indicator,
		reported_date = date,
		reported_year_week = year_week,
		value,
		source
	),
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true) ~> SelectReqFields
SelectReqFields, CountryLookup lookup(SelectReqFields@country == CountryLookup@country,
	multiple: false,
	pickup: 'any',
	broadcast: 'auto')~> lookup1
lookup1 select(mapColumn(
		country = SelectReqFields@country,
		indicator,
		reported_date,
		reported_year_week,
		value,
		source,
		country_code_2_digit,
		country_code_3_digit,
		population
	),
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true) ~> SelectReqFields2
SelectReqFields2 split(indicator == 'Weekly new hospital admissions per 100k' || indicator == 'Weekly new ICU admissions per 100k',
	disjoint: false) ~> SplitDailyFromWeekly@(Weekly, Daily)
DimDateSource derive(ecdc_year_weak = year + '-W' + lpad(week_of_year,2,'0')) ~> DerivedECDCYearWeek
DerivedECDCYearWeek aggregate(groupBy(ecdc_year_weak),
	week_start_date = min(date),
		week_end_date = max(date)) ~> AggDimDate
SplitDailyFromWeekly@Weekly, AggDimDate join(reported_year_week == ecdc_year_weak,
	joinType:'inner',
	matchType:'exact',
	ignoreSpaces: false,
	broadcast: 'auto')~> JoinwithDate
JoinwithDate pivot(groupBy(country,
		country_code_2_digit,
		country_code_3_digit,
		population,
		reported_year_week,
		source,
		week_start_date,
		week_end_date),
	pivotBy(indicator, ['Weekly new hospital admissions per 100k', 'Weekly new ICU admissions per 100k']),
	count = sum(value),
	columnNaming: '$N_$V',
	lateral: true) ~> PivotWeekly
SplitDailyFromWeekly@Daily pivot(groupBy(country,
		country_code_2_digit,
		country_code_3_digit,
		source,
		population,
		reported_date),
	pivotBy(indicator, ['Daily hospital occupancy', 'Daily ICU occupancy']),
	count = sum(value),
	columnNaming: '$N+$V',
	lateral: true) ~> PivotDaily
PivotWeekly sort(desc(reported_year_week, true),
	asc(country, true),
	partitionBy('hash', 1)) ~> WeeklySort
PivotDaily sort(desc(reported_date, true),
	asc(country, true),
	partitionBy('hash', 1)) ~> DailySort
WeeklySort select(mapColumn(
		country,
		country_code_2_digit,
		country_code_3_digit,
		population,
		reported_year_week,
		reported_week_start_date = week_start_date,
		reported_week_end_date = week_end_date,
		new_hospital_occupancy_count = {count_Weekly new hospital admissions per 100k},
		new_icu_occupancy_count = {count_Weekly new ICU admissions per 100k},
		source
	),
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true) ~> SelectWeekly3
DailySort select(mapColumn(
		country,
		country_code_2_digit,
		country_code_3_digit,
		population,
		reported_date,
		hospital_occupancy_count = {count+Daily hospital occupancy},
		icu_occupancy_count = {count+Daily ICU occupancy},
		source
	),
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true) ~> SelectDaily3
SelectWeekly3 sink(allowSchemaDrift: true,
	validateSchema: false,
	partitionFileNames:['weekly_hospital_admissions.csv'],
	truncate: true,
	umask: 0022,
	preCommands: [],
	postCommands: [],
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true,
	partitionBy('hash', 1)) ~> WeeklySink
SelectDaily3 sink(allowSchemaDrift: true,
	validateSchema: false,
	partitionFileNames:['daily_hospital_admissions.csv'],
	truncate: true,
	umask: 0022,
	preCommands: [],
	postCommands: [],
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true,
	partitionBy('hash', 1)) ~> DailySink