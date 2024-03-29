use SportDBWH
go
-----------------------------------------------------
IF OBJECT_ID ( 'dbo.InsertClubs', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.InsertClubs;  
GO

create procedure dbo.InsertClubs 
as
	if object_id('tempdb..#Clubs') is not null
		drop table #Clubs

	create table #Clubs (
		[ClubID] [int] NOT NULL,
		--[ClubID][int] not null,
		[Club] [nvarchar](450) NULL,
		[CouchFullName] [nvarchar](150) NULL,
	--	[SportID] [int] NOT NULL,
		[DateOfLoading] datetime  not null
	)

	insert into #Clubs ([ClubID], [Club], [CouchFullName], [DateOfLoading])
	select C.ClubID, C.Club, C.CouchFullName, C.ModifiedDate from SportDB.sport.Clubs C
		where C.ModifiedDate > (
									select ISNULL(MAX( CONVERT(datetime, DC.[DateOfLoading])),'2000-01-01 00:00:00.000') 
									from SportDBWH.dbo.DimClubs DC
								)

		MERGE SportDBWH.dbo.DimClubs emp
		USING #Clubs ute
		ON [emp].[ClubID] = [ute].[ClubID]
		WHEN NOT MATCHED THEN
		INSERT (ClubID, [Club], [CouchFullName], [DateOfLoading])
		VALUES ([ute].[ClubID], [ute].[Club], [ute].[CouchFullName], getdate())
		WHEN MATCHED THEN
		  UPDATE
		  SET [emp].[DateOfLoading] = getdate(),
			[emp].[ClubID] = ute.[ClubID],
			[emp].[Club]= ute.[Club] ,
			[emp].[CouchFullName] = ute.[CouchFullName];
go
-----------------------------------------------------
/*
exec dbo.InsertClubs
go
select * from SportDBWH.dbo.DimClubs
go
*/
-----------------------------------------------------

IF OBJECT_ID ( 'dbo.InsertSports', 'P' ) IS NOT NULL  
    DROP PROCEDURE dbo.InsertSports;  
GO
create procedure dbo.InsertSports
as
	if object_id('tempdb..#Sports') is not null
		drop table #Sports

	create table #Sports (
		[SportID] [int],
		[Sport] [nvarchar](max),
		[SportInformation][nvarchar](max),
		[SportType] [nvarchar](max),
		[ModifiedDate] [datetime],
	)

	insert into #Sports ([SportID], [Sport],[SportType], [ModifiedDate])
	select S.SportID, S.Sport, S.SportType, S.ModifiedDate from SportDB.sport.Sports S
		where S.ModifiedDate > (
									select ISNULL(MAX( CONVERT(datetime, DC.DateOfLoading)),'2000-01-01 00:00:00.000') 
									from SportDBWH.dbo.DimSports DC
								)
        
		MERGE SportDBWH.dbo.DimSports emp
		USING #Sports ute
		ON [emp].[SportID] = [ute].[SportID]
		WHEN NOT MATCHED THEN
		INSERT ([SportID], [Sport],[SportType], [DateOfLoading])
		VALUES ([ute].[SportID], [ute].[Sport], [ute].[SportType],  getdate())
		WHEN MATCHED THEN
		  UPDATE
		  SET [emp].[DateOfLoading] = getdate(), 
			 [emp].[SportID] = ute.[SportID] ,
			 [emp].[Sport] = ute.[Sport],
			 [emp].[SportType] = ute.[SportType];
go 
-----------------------------------------------------
/*
exec dbo.InsertSports
go
select * from SportDBWH.dbo.DimSports
go
*/
-----------------------------------------------------
IF OBJECT_ID ( 'dbo.InsertTeams', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.InsertTeams;  
GO

create procedure dbo.InsertTeams
as
	if object_id('tempdb..#Teams') is not null
		drop table #Teams

	create table #Teams (
		[TeamID] [int],
		[Team] [nvarchar](450) ,
		[ParentTeamID] [int] ,
		[ModifiedDate] [datetime],
	)

	insert into #Teams ([TeamID], [Team],[ParentTeamID], [ModifiedDate])
	select S.TeamID, S.Team, S.ParentTeamID, S.ModifiedDate from SportDB.Sport.Teams S
		where S.ModifiedDate > (
									select ISNULL(MAX( CONVERT(datetime, DC.DateOfLoading)),'2000-01-01 00:00:00.000') 
									from SportDBWH.dbo.DimTeams DC
								)

	MERGE SportDBWH.dbo.DimTeams emp
	USING #Teams ute
	ON [emp].[TeamID] = [ute].[TeamID]
	WHEN NOT MATCHED THEN
	INSERT ([TeamID], [Team],[ParentTeamID], [DateOfLoading])
	VALUES ([ute].[TeamID], [ute].[Team], [ute].[ParentTeamID],  getdate())
	WHEN MATCHED THEN
	  UPDATE
	  SET [emp].[DateOfLoading] = getdate(),
		[emp].[TeamID] = ute.[TeamID],
		[emp].[Team] = ute.[Team],
		[emp].[ParentTeamID] = ute.[ParentTeamID] ;
go
-----------------------------------------------------
/*
exec dbo.InsertTeams
go
select * from SportDBWH.dbo.DimTeams
go
*/
-----------------------------------------------------

IF OBJECT_ID ( 'dbo.InsertTournaments', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.InsertTournaments;  
GO
create procedure dbo.InsertTournaments
as
	if object_id('tempdb..#Tournaments') is not null
		drop table #Tournaments

	create table #Tournaments (
		[TournamentID] [int],
		[TournamentName] [nvarchar](max) ,
		[ModifiedDate] [datetime],
	)

	insert into #Tournaments ([TournamentID], [TournamentName], [ModifiedDate])
	select S.TournamentID, S.TournamentName, S.ModifiedDate from SportDB.Sport.Tournaments S
		where S.ModifiedDate > (
									select ISNULL(MAX( CONVERT(datetime, DC.DateOfLoading)),'2000-01-01 00:00:00.000') 
									from SportDBWH.dbo.DimTournaments DC
								)
		MERGE SportDBWH.dbo.DimTournaments emp
		USING #Tournaments ute
		ON [emp].[TournamentID] = [ute].[TournamentID]
		WHEN NOT MATCHED THEN
		INSERT ([TournamentID], [TournamentName], [DateOfLoading])
		VALUES ([ute].[TournamentID], [ute].[TournamentName],  getdate())
		WHEN MATCHED   THEN
		  UPDATE
		  SET [emp].[DateOfLoading] = getdate(),
			[emp].[TournamentID] = ute.[TournamentID] ,
			[emp].[TournamentName] = ute.[TournamentName];
go
-----------------------------------------------------
/*
exec dbo.InsertTournaments
go
select * from SportDBWH.dbo.DimTournaments
go
*/
-----------------------------------------------------

IF OBJECT_ID ( 'dbo.InsertEvents', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.InsertEvents;  
GO
create procedure dbo.InsertEvents
as
	if object_id('tempdb..#Events') is not null
		drop table #Events

	create table #Events (
		[EventID] [int] ,
		[Event] [nvarchar](15),
		[SportID] [int] ,
		[EventGroup] [int] ,
		[ModifiedDate] [datetime] ,
	)

	insert into #Events ([EventID], [Event], [SportID], [EventGroup],  [ModifiedDate])
	select S.EventID, S.[Event], S.[SportID], S.[EventGroup], S.ModifiedDate from SportDB.finance.Events S
		where S.ModifiedDate > (
									select ISNULL(MAX( CONVERT(datetime, DC.DateOfLoading)),'2000-01-01 00:00:00.000') 
									from SportDBWH.dbo.DimEvents DC
								)

		MERGE SportDBWH.dbo.DimEvents emp
		USING #Events ute
		ON [emp].[EventID] = [ute].[EventID]
		WHEN NOT MATCHED THEN
		INSERT ([EventID], [Event], [SportID], [EventGroup],  [DateOfLoading])
		VALUES ([ute].[EventID], [ute].[Event], [ute].[SportID], [ute].[EventGroup],  getdate())
		WHEN MATCHED   THEN
		  UPDATE
		  SET [emp].[DateOfLoading] = getdate(),
			[emp].[EventID] = ute.[EventID]  ,
			[emp].[Event] = ute.[Event]  ,
			[emp].[SportID] = ute.[SportID]  ,
			[emp].[EventGroup] = ute.[EventGroup] ;
go
-----------------------------------------------------
/*
exec dbo.InsertEvents
go
select * from SportDBWH.dbo.DimEvents
go
*/
-----------------------------------------------------

IF OBJECT_ID ( 'dbo.InsertLocations', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.InsertLocations;  
GO
create procedure dbo.InsertLocations
as
	if object_id('tempdb..#Locations') is not null
		drop table #Locations

	create table #Locations (
		[LocationID] [int] ,
		[CountryCode] [nchar](3) ,
		[City] [nvarchar](max) ,
		[Country][nvarchar](max) ,
		[ModifiedDate] [datetime] 
	)

	insert into #Locations ([LocationID], [CountryCode], [City], [Country],  [ModifiedDate])
	select S.CityID, S.CountryCode, S.CityName, C.CountryEnglishName, S.ModifiedDate 
	from SportDB.location.Cities S 
		join SportDB.location.Countries C on  C.CountryCode = S.CountryCode
	where S.ModifiedDate > (
								select ISNULL(MAX( CONVERT(datetime, DC.DateOfLoading)),'2000-01-01 00:00:00.000') 
								from SportDBWH.dbo.DimLocations DC
							)
		or C.ModifiedDate > (
								select ISNULL(MAX( CONVERT(datetime, DC.DateOfLoading)),'2000-01-01 00:00:00.000') 
								from SportDBWH.dbo.DimLocations DC
							)

		MERGE SportDBWH.dbo.DimLocations emp
		USING #Locations ute
		ON [emp].[LocationID] = [ute].[LocationID]
		WHEN NOT MATCHED THEN
		INSERT ([LocationID], [CountryCode], [City], [Country], [DateOfLoading])
		VALUES ([ute].[LocationID], [ute].[CountryCode], [ute].[City], [ute].[Country],  getdate())
		WHEN MATCHED   THEN
		  UPDATE
		  SET [emp].[DateOfLoading] = getdate(),
			[emp].[LocationID] = ute.[LocationID]  ,
			[emp].[CountryCode] =ute.[CountryCode]  ,
			[emp].[City] =ute.[City] ,
			[emp].[Country] =ute.[Country]  ;
go
-----------------------------------------------------
/*
exec dbo.InsertLocations
go
select * from SportDBWH.dbo.DimLocations
go
*/
-----------------------------------------------------

IF OBJECT_ID ( 'dbo.InsertCountries', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.InsertCountries  
GO

create procedure dbo.InsertCountries
as
	if object_id('tempdb..#Countries') is not null
		drop table #Countries

	create table #Countries (
		[CountryID] [int] ,
		[CountryCode] [nchar](3) ,
		[CountryEnglishName] [nvarchar](max) ,
		[ModifiedDate] datetime
	)

	insert into #Countries ( [CountryCode], [CountryEnglishName], [ModifiedDate])
	select  S.[CountryCode], S.[CountryEnglishName], S.ModifiedDate from SportDB.location.Countries S
		where S.ModifiedDate > (
									select ISNULL(MAX( CONVERT(datetime, DC.DateOfLoading)),'2000-01-01 00:00:00.000') 
									from SportDBWH.dbo.DimCountries DC
								)

		MERGE SportDBWH.dbo.DimCountries emp
		USING #Countries ute
		ON [emp].[CountryCode] = [ute].[CountryCode]
		WHEN NOT MATCHED THEN
		INSERT ( [CountryCode], [CountryEnglishName], [DateOfLoading])
		VALUES ( [ute].[CountryCode], [ute].[CountryEnglishName],  getdate())
		WHEN MATCHED   THEN
		  UPDATE
		  SET [emp].[DateOfLoading] = getdate(),
			[emp].[CountryCode] = ute.[CountryCode] ,
			[emp].[CountryEnglishName] = ute.[CountryEnglishName] ; 
go
-----------------------------------------------------
/*
exec dbo.InsertCountries
go
select * from SportDBWH.dbo.DimCountries
go
*/
-----------------------------------------------------

IF OBJECT_ID ( 'dbo.InsertTaxes', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.InsertTaxes;  
GO
create procedure dbo.InsertTaxes
as
	if object_id('tempdb..#Taxes') is not null
		drop table #Taxes

	create table #Taxes (
		[TaxID] [int],
		[Tax] nvarchar(50) ,
		[TaxRate] [float] ,
		[CountryCode] nchar(3) ,
		[ModifiedDate] [datetime] 
	)

	insert into #Taxes ( [TaxID], [Tax], [TaxRate], [CountryCode],  [ModifiedDate])
	select  S.[TaxID], S.[Tax], S.[TaxRate], S.CountryCode, S.ModifiedDate  from SportDB.finance.Taxes S
		where S.ModifiedDate > (
									select ISNULL(MAX( CONVERT(datetime, DC.DateOfLoading)),'2000-01-01 00:00:00.000') 
									from SportDBWH.dbo.DimTaxes DC
								)

		MERGE SportDBWH.dbo.DimTaxes emp
		USING #Taxes ute
		ON [emp].[TaxID] = [ute].[TaxID]
		WHEN NOT MATCHED THEN
		INSERT ( [TaxID], [Tax], [TaxRate], [CountryCode],  [DateOfLoading])
		VALUES ( [ute].[TaxID], [ute].[Tax], [ute].[TaxRate], [ute].[CountryCode],  getdate())
		WHEN MATCHED   THEN
		  UPDATE
		  SET [emp].[DateOfLoading] = getdate(),
			[emp].[TaxID] = ute.[TaxID] ,
			[emp].[TaxRate] = ute.[TaxRate]  ,
			[emp].[CountryCode] = ute.[CountryCode]  ,
			[emp].[Tax] = ute.[Tax]  ;
go
-----------------------------------------------------
/*
exec dbo.InsertTaxes
go
select * from SportDBWH.dbo.DimTaxes
go
*/
-----------------------------------------------------

IF OBJECT_ID ( 'dbo.InsertArens', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.InsertArens;  
GO
create procedure dbo.InsertArens
as
	if object_id('tempdb..#Arens') is not null
		drop table #Arens

	create table #Arens (
		[SportArenaID] [int] ,
		[AmountOfSits] [int] ,
		[LocationID] [int] ,
		[ArenaName] [nvarchar](max) ,
		[ModifiedDate] [datetime] ,
	)

	insert into #Arens ( [SportArenaID], [AmountOfSits], [LocationID], [ArenaName],  [ModifiedDate])
	select  S.SportArenaID, S.AmountOfSits, S.CityID, S.ArenaName, S.ModifiedDate  from SportDB.location.SportArens S
		where S.ModifiedDate > (
									select ISNULL(MAX( CONVERT(datetime, DC.DateOfLoading)),'2000-01-01 00:00:00.000') 
									from SportDBWH.dbo.DimArens DC
								)

		MERGE SportDBWH.dbo.DimArens emp
		USING #Arens ute
		ON [emp].[ArenaID] = [ute].[SportArenaID]
		WHEN NOT MATCHED THEN
		INSERT ( [ArenaID], [AmountOfSits], [LocationID], [ArenaName],   [DateOfLoading])
		VALUES ( [ute].[SportArenaID], [ute].[AmountOfSits], [ute].[LocationID], [ute].[ArenaName],  getdate())
		WHEN MATCHED   THEN
		  UPDATE
		  SET [emp].[DateOfLoading] = getdate(),
			[emp].[ArenaID] = ute.[SportArenaID]  ,
			[emp].[AmountOfSits] = ute.[AmountOfSits]  ,
			[emp].[LocationID] = ute.[LocationID] ,
			[emp].[ArenaName] = ute.[ArenaName]  ;
go
-----------------------------------------------------
/*
exec dbo.InsertArens
go
select * from SportDBWH.dbo.DimClubs
go
*/
-----------------------------------------------------

IF OBJECT_ID ( 'dbo.InsertMatches', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.InsertMatches;  
GO

create procedure dbo.InsertMatches
as
	if object_id('tempdb..#Matches') is not null
		drop table #Matches

	create table #Matches (
		[MatchID] [int] ,
		[DateMatch] [datetime] ,
		[HomeParticipant] [int] ,
		[AwayParticipant] [int],
		[TeamID] [int] ,
		[ArenaID] [int] ,
		[SportID] [int] ,
		[TournamentID] [int] ,
		[ModifiedDate] [datetime] ,

	)

	insert into #Matches ( [MatchID], [DateMatch], [HomeParticipant], [AwayParticipant], [TeamID], [ArenaID],  [SportID], [TournamentID], [ModifiedDate])
	select  S.MatchID, S.[DateMatch], S.[HomeParticipant], S.[AwayParticipant], S.[TeamID], S.[SportArenaID], TT.[SportID], TT.[TournamentID], S.[ModifiedDate]  
	from SportDB.sport.Matches S 
		left join SportDB.sport.Teams T on S.TeamID = T.TeamID 
		left join SportDB.sport.Tournaments TT on T.TournamentID = TT.TournamentID
	where S.ModifiedDate > (
								select ISNULL(MAX( CONVERT(datetime, DC.DateOfLoading)),'2000-01-01 00:00:00.000') 
								from SportDBWH.dbo.FactMatches DC
							)

		MERGE SportDBWH.dbo.FactMatches emp
		USING #Matches ute
		ON [emp].[MatchID] = [ute].[MatchID]
		WHEN NOT MATCHED THEN
		INSERT ( [MatchID], [DateMatch], [HomeParticipant], [AwayParticipant], [TeamID], [ArenaID],  [SportID], [TournamentID], [DateOfLoading])
		VALUES ( [ute].[MatchID], [ute].[DateMatch], [ute].[HomeParticipant], [ute].[AwayParticipant], [ute].[TeamID], [ute].[ArenaID], [ute].[SportID], [ute].[TournamentID],  getdate())
		WHEN MATCHED   THEN
		  UPDATE
		  SET [emp].[DateOfLoading] = getdate(),
			[emp].[MatchID] = ute.[MatchID] ,
			[emp].[DateMatch] = ute.[DateMatch]  ,
			[emp].[HomeParticipant] = ute.[HomeParticipant]  ,
			[emp].[AwayParticipant] = ute.[AwayParticipant] ,
			[emp].[TeamID] = ute.[TeamID] ,
			[emp].[ArenaID] = ute.[ArenaID] ,
			[emp].[SportID] = ute.[SportID]  ,
			[emp].[TournamentID] = ute.[TournamentID]; 
go
-----------------------------------------------------
/*
exec dbo.InsertMatches
go
select * from SportDBWH.dbo.FactMatches
go
*/
-----------------------------------------------------

IF OBJECT_ID ( 'dbo.InsertCustomersGroups', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.InsertCustomersGroups;  
GO
create procedure dbo.InsertCustomersGroups
as
	if object_id('tempdb..#CustomersGroups') is not null
		drop table #CustomersGroups

	create table #CustomersGroups (
		[CustomerGroupID] [int] ,
		[CustomerGroup] [nvarchar](450) ,
		[CustomerGroupCommissionAddStake] [float] ,
		[CustomerGroupCommissionEditStake] [float] ,
		[CustomerGroupCommissionDeleteStake] [float] ,
		[ModifiedDate] [datetime]
		)

	insert into #CustomersGroups ( [CustomerGroupID], [CustomerGroup], [CustomerGroupCommissionAddStake], [CustomerGroupCommissionEditStake], [CustomerGroupCommissionDeleteStake],  [ModifiedDate])
	select  S.CustomerGroupID, S.CustomerGroup, S.CustomerGroupCommissionAddStake, S.CustomerGroupCommissionEditStake, S.CustomerGroupCommissionDeleteStake,  S.ModifiedDate  from SportDB.finance.CustomersGroups S
		where S.ModifiedDate > (
									select ISNULL(MAX( CONVERT(datetime, DC.DateOfLoading)),'2000-01-01 00:00:00.000') 
									from SportDBWH.dbo.DimCustomersGroups DC
								)

		MERGE SportDBWH.dbo.DimCustomersGroups emp
		USING #CustomersGroups ute
		ON [emp].[CustomerGroupID] = [ute].[CustomerGroupID]
		WHEN NOT MATCHED THEN
		INSERT ( [CustomerGroupID], [CustomerGroup], [CustomerGroupCommissionAddStake], [CustomerGroupCommissionEditStake], CustomerGroupCommissionDeleteStake,  [DateOfLoading])
		VALUES ( [ute].[CustomerGroupID], [ute].[CustomerGroup], [ute].[CustomerGroupCommissionAddStake], [ute].[CustomerGroupCommissionEditStake], [ute].CustomerGroupCommissionDeleteStake,  getdate())
		WHEN MATCHED   THEN
		  UPDATE
		  SET [emp].[DateOfLoading] = getdate(),
			[emp].[CustomerGroupID] = ute.[CustomerGroupID]  ,
			[emp].[CustomerGroup] = ute.[CustomerGroup] ,
			[emp].[CustomerGroupCommissionAddStake] = ute.[CustomerGroupCommissionAddStake]  ,
			[emp].[CustomerGroupCommissionEditStake] = ute.[CustomerGroupCommissionEditStake] ,
			[emp].CustomerGroupCommissionDeleteStake = ute.CustomerGroupCommissionDeleteStake; 
go
--------------------------------------------
/*
exec dbo.InsertCustomersGroups
go
select * from SportDBWH.dbo.DimCustomersGroups
go
*/
----------------------------------------------------------------

IF OBJECT_ID ( 'dbo.InsertConditions', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.InsertConditions;  
GO

create procedure dbo.InsertConditions
as
	insert into SportDBWH.dbo.DimConditions ( [ConditionID], [SportEventID], [EventID], [Chance], [IsTrue], [DateOfLoading])
	select  S.ConditionID, S.[SportEventID], S.[EventID], S.[Chance], S.[IsTrue], S.[DateOfCreating] from SportDB.finance.Conditions S
		where S.[DateOfCreating] > (
									select ISNULL(MAX( CONVERT(datetime, DC.[DateOfLoading])),'2000-01-01 00:00:00.000') 
									from SportDBWH.dbo.DimConditions DC
								)
			and S.[IsTrue] is not null
go
-----------------------------------------------------
/*
exec dbo.InsertConditions
go
select * from SportDBWH.dbo.DimConditions
go
*/
-----------------------------------------------------

IF OBJECT_ID ( 'dbo.InsertCustomers', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.InsertCustomers;  
GO

create procedure dbo.InsertCustomers
as
	if object_id('tempdb..#Customers') is not null
		drop table #Customers

	create table #Customers (
		[CustomerID] [int] ,
		[CustomerLogin] [nvarchar](50) ,
		[CustomerEmail] [nvarchar](50) ,
		[SendMails] [bit] NULL ,
		[CustomerGroupID] [int] ,
		[CountryCode] [nchar](3) ,
		[ModifiedDate] [datetime] ,
	)

	insert into #Customers ( [CustomerID], [CustomerLogin], [CustomerEmail], [SendMails], [CustomerGroupID], [CountryCode],  [ModifiedDate])
	select  S.CustomerID, S.[CustomerLogin], S.[CustomerEmail], S.[SendMails], S.[CustomerGroupID], S.CountryCode, S.ModifiedDate  from SportDB.finance.Customers S
		where S.ModifiedDate > (
									select ISNULL(MAX( CONVERT(datetime, DC.DateOfLoading)),'2000-01-01 00:00:00.000') 
									from SportDBWH.dbo.DimCustomers DC
								)

		MERGE SportDBWH.dbo.DimCustomers emp
		USING #Customers ute
		ON [emp].[CustomerID] = [ute].[CustomerID]
		WHEN NOT MATCHED THEN
		INSERT ( [CustomerID], [CustomerLogin], [CustomerEmail], [SendMails], [CustomerGroupID], [CountryCode],  [DateOfLoading])
		VALUES ( [ute].[CustomerID], [ute].[CustomerLogin], [ute].[CustomerEmail], [ute].[SendMails], [ute].[CustomerGroupID], [ute].[CountryCode],  getdate())
		WHEN MATCHED   THEN
		  UPDATE
		  SET [emp].[DateOfLoading] = getdate(),
			[emp].[CustomerID] = ute.[CustomerID]  ,
			[emp].[CustomerLogin] = ute.[CustomerLogin]  ,
			[emp].[CustomerEmail] = ute.[CustomerEmail]  ,
			[emp].[SendMails] = ute.[SendMails]  ,
			[emp].[CustomerGroupID] = ute.[CustomerGroupID]  ,
			[emp].[CountryCode] = ute.[CountryCode] ;
go
-----------------------------------------------------
/*
exec dbo.InsertCustomers
go
select * from SportDBWH.dbo.DimCustomers
go
*/
-----------------------------------------------------

IF OBJECT_ID ( 'dbo.InsertFactCustomersFinanceOperations', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.InsertFactCustomersFinanceOperations;  
GO

create procedure dbo.InsertFactCustomersFinanceOperations
as
	insert into SportDBWH.dbo.FactCustomersFinanceOperations ( [FinanceOperationID], [CustomerID], [FinanceOperationTyp], [Amount], [AmountCommission], [AmountTax],  [FinalAmount], [CurrencyCode], [OperationDate])
	select  S.FinanceOperationID, S.[CustomerID], S.[FinanceOperationTyp], S.[Amount], S.[AmountCommission], S.[AmountTax], S.[FinalAmount], S.[CurrencyCode], S.OperationDate  from SportDB.finance.CustomersFinanceOperations S
		where S.OperationDate > (
									select ISNULL(MAX( CONVERT(datetime, DC.OperationDate)),'2000-01-01 00:00:00.000') 
									from SportDBWH.dbo.FactCustomersFinanceOperations DC
								)
go
-----------------------------------------------------
/*
exec dbo.InsertFactCustomersFinanceOperations
go
select * from SportDBWH.dbo.FactCustomersFinanceOperations
go
*/
-----------------------------------------------------

IF OBJECT_ID ( 'dbo.InsertStakes', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.InsertStakes;  
GO

create procedure dbo.InsertStakes
as

if object_id('tempdb..#Stakes') is not null
    drop table #Stakes

	create table #Stakes (
		[StakeID] [int] ,
		[Stake] [money],
		[CurrencyCode] nchar(3),
		[CustomerID] [int] ,
		[ConditionID] [int] ,
		[Chance] [float] ,
		[Status] [int] ,
		[Date] [datetime] 

	)

	insert into SportDBWH.dbo.FactStakes( [StakeID], [Stake], [CurrencyCode], [CustomerID], [ConditionID], [Chance],  [Status], [Date])
	select  S.[StakeID], S.[Stake], S.[CurrencyCode], S.[CustomerID], S.[ConditionID], S.[Chance], S.[Status], S.[Date]  
	from SportDB.finance.Stakes S 
	where S.[Date] > (
						select ISNULL(MAX( CONVERT(datetime, DC.Date)),'2000-01-01 00:00:00.000') 
						from SportDBWH.dbo.FactStakes DC
					)
go
/*
 exec dbo.InsertStakes
go
select * from SportDBWH.dbo.FactStakes
go
*/