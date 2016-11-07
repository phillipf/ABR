#' getABR
#'
#' This extracts the ABR business location table from SQL
#' @param URL the URL string used to query GoogleMaps
#' @keywords GoogleMapS, Place API, GoogleMaps API
#' @export
#' @examples
#' getABR()
#'


getABR <- function(date) {

  if(!require(RODBC)) {
    message("installing the 'RODBC' package")
    install.packages("RODBC")
  }

query <- "WITH LOCATION AS
  ((SELECT DISTINCT
[PID]
,[Latitude]
,[Longitude]
,[Meshblock]
,[GNAFPID]
,[AddressLine1]
,[AddressLine2]
,[Suburb]
,[State]
,[Postcode]
,CASE
WHEN [AddressLine2] != [Suburb] AND [AddressLine1] LIKE '%[0-9]%'
THEN
UPPER([AddressLine1]) + ' ' + UPPER([AddressLine2]) + ' ' + UPPER([Suburb]) + ' ' + UPPER([Postcode])
WHEN [AddressLine2] != [Suburb] AND [AddressLine1] NOT LIKE '%[0-9]%'
THEN
UPPER([AddressLine2]) + ' ' + UPPER([Suburb]) + ' ' + UPPER([Postcode])
ELSE
UPPER([AddressLine1]) + ' ' + UPPER([Suburb]) + ' ' + UPPER([Postcode])
END
AS FullAddress
,[LocationIndustryClass]
,[LocationIndustryClassDescription]

FROM [CWW_DW].[dbo].[ABR_Businesslocation_%s]
WHERE [Latitude] IS NOT NULL
AND [Latitude] != '0.000000'
AND [State] = 'VIC'
AND [LocationIndustryClass] != '0000'
AND [LocationIndustryClass] != '9999'
AND [LocationIndustryClass] != '6240'
AND [LocationIndustryClass] != '6330'
AND [LocationIndustryClass] != '6310'
AND [LocationIndustryClass] != '6321'
AND [LocationIndustryClass] != '6411'
AND [LocationIndustryClass] != '6419'
AND [LocationIndustryClass] != '6932'
AND [LocationIndustryClass] != '6640'
AND [LocationIndustryClass] != '6962'
AND [LocationIndustryClass] != '6223'
AND [LocationIndustryClass] != '6230'
AND [LocationIndustryClass] != '9800'
AND [LocationIndustryClass] != '7291'
AND [LocationIndustryClass] != '6940'
AND [LocationIndustryClass] != '6931'
AND [LocationIndustryClass] != '6921'
AND [LocationIndustryClass] != '6420'
AND [LocationIndustryClass] != '7000'
AND [LocationIndustryClass] != '9559'
AND [LocationIndustryClass] != '5299'
AND [LocationIndustryClass] != '6923'
AND [LocationIndustryClass] != '7211'
AND [LocationIndustryClass] != '7292'
AND [LocationIndustryClass] != '7293'
AND [LocationIndustryClass] != '7294'
AND [LocationIndustryClass] != '7299'
AND [LocationIndustryClass] != '6322'
AND [LocationIndustryClass] != '9539'
AND [LocationIndustryClass] != '6229'
AND [LocationIndustryClass] != '6922'
AND [LocationIndustryClass] != '5700'
AND [LocationIndustryClass] != '7212'
AND [LocationIndustryClass] != '9552'
AND [LocationIndustryClass] != '9551'
AND [LocationIndustryClass] != '6950'
AND [LocationIndustryClass] != '6924'
AND [LocationIndustryClass] != ''
AND [LocationIndustryClass] != '9602'
AND [LocationIndustryClass] != '9603'
AND [LocationIndustryClass] != '9901'
AND [LocationIndustryClass] != '9904'
AND [LocationIndustryClass] != '9976'
AND [LocationIndustryClass] != '9978'
AND [LocationIndustryClass] != '9979'
AND [AddressLine2] is not null) union
(SELECT DISTINCT
[PID]
,[Latitude]
,[Longitude]
,[Meshblock]
,[GNAFPID]
,[AddressLine1]
,[AddressLine2]
,[Suburb]
,[State]
,[Postcode]
,UPPER([AddressLine1]) + ' ' + UPPER([Suburb]) + ' ' + UPPER([Postcode]) AS FullAddress
,[LocationIndustryClass]
,[LocationIndustryClassDescription]

FROM [CWW_DW].[dbo].[ABR_Businesslocation_%s]
WHERE [Latitude] IS NOT NULL
AND [Latitude] != '0.000000'
AND [State] = 'VIC'
AND [LocationIndustryClass] != '0000'
AND [LocationIndustryClass] != '9999'
AND [LocationIndustryClass] != '6240'
AND [LocationIndustryClass] != '6330'
AND [LocationIndustryClass] != '6310'
AND [LocationIndustryClass] != '6321'
AND [LocationIndustryClass] != '6411'
AND [LocationIndustryClass] != '6419'
AND [LocationIndustryClass] != '6932'
AND [LocationIndustryClass] != '6640'
AND [LocationIndustryClass] != '6962'
AND [LocationIndustryClass] != '6223'
AND [LocationIndustryClass] != '6230'
AND [LocationIndustryClass] != '9800'
AND [LocationIndustryClass] != '7291'
AND [LocationIndustryClass] != '6940'
AND [LocationIndustryClass] != '6931'
AND [LocationIndustryClass] != '6921'
AND [LocationIndustryClass] != '6420'
AND [LocationIndustryClass] != '7000'
AND [LocationIndustryClass] != '9559'
AND [LocationIndustryClass] != '5299'
AND [LocationIndustryClass] != '6923'
AND [LocationIndustryClass] != '7211'
AND [LocationIndustryClass] != '7292'
AND [LocationIndustryClass] != '7293'
AND [LocationIndustryClass] != '7294'
AND [LocationIndustryClass] != '7299'
AND [LocationIndustryClass] != '6322'
AND [LocationIndustryClass] != '9539'
AND [LocationIndustryClass] != '6229'
AND [LocationIndustryClass] != '6922'
AND [LocationIndustryClass] != '5700'
AND [LocationIndustryClass] != '7212'
AND [LocationIndustryClass] != '9552'
AND [LocationIndustryClass] != '9551'
AND [LocationIndustryClass] != '6950'
AND [LocationIndustryClass] != '6924'
AND [LocationIndustryClass] != ''
AND [LocationIndustryClass] != '9602'
AND [LocationIndustryClass] != '9603'
AND [LocationIndustryClass] != '9901'
AND [LocationIndustryClass] != '9904'
AND [LocationIndustryClass] != '9976'
AND [LocationIndustryClass] != '9978'
AND [LocationIndustryClass] != '9979'
AND [AddressLine2] is null))
SELECT DISTINCT
[PID]
,[Latitude]
,[Longitude]
,[Meshblock]
,[GNAFPID]
,[AddressLine1]
,[AddressLine2]
,[Suburb]
,[State]
,[Postcode]
,FullAddress
,CASE
WHEN (FullAddress LIKE '%UNIT%'
OR left(FullAddress,2) LIKE 'U '
OR FullAddress LIKE '%/%'
OR FullAddress LIKE '%LEVEL%'
OR FullAddress LIKE '%SUITE%'
OR FullAddress LIKE '%FLOOR%'
OR FullAddress LIKE '%FACTORY%'
OR FullAddress LIKE '%SHOP%'
OR FullAddress LIKE '%APARTMENT%'
OR FullAddress LIKE '%FLAT%'
OR left(FullAddress,2) LIKE 'L '
OR left(FullAddress,2) LIKE 'S ')
THEN
'A'
ELSE
'B'
END
AS TYPE
,[LocationIndustryClass]
,[LocationIndustryClassDescription]

FROM LOCATION"

query <- gsub("%s", date, query)

ABR <- sqlQuery(CWW_DW,
                query,
                stringsAsFactors=FALSE)

}
