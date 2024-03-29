/****** Script for SelectTopNRows command from SSMS  ******/
SELECT distinct
     C.[Club]
	 , S.SportID
  FROM [Sport].[dbo].[Clubs] C
  join  [Sport].[dbo].Teams T
  on T.ClubId = C.ClubID
   join [Sport].[dbo].Matches M
  on T.TeamID = M.AwayParticipant or T.TeamID= M.HomeParticipant
join [Sport].[dbo].Sports S
  on S.SportID = M.SportID