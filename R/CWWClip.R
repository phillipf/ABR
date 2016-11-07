#' CWWClip
#'
#' This clips an ABR dataframe to CWWs service area
#' @param df a dataframe from the getABR function
#' @keywords ABR, CWW, spatial clip
#' @export
#' @examples
#' CWWClip()
#'

CWWClip <- function(df = ABRdf) {

  if(!require(sp)) {
    message("installing the 'sp' package")
    install.packages("sp")
  }

  if(!require(rgdal)) {
    message("installing the 'rgdal' package")
    install.packages("rgdal")
  }


  CWWBoundary <- readOGR("N:/ABR/CWW Boundary_2014_region.shp", layer="CWW Boundary_2014_region")

  df <- df %>%
        filter(!is.na(Longitude) & !is.na(Latitude))

  ABRLongLat <- SpatialPointsDataFrame(coords = data.frame(x = df$Longitude,
                                                           y = df$Latitude,
                                                           stringsAsFactors = FALSE),
                                       data=data.frame(PID = df$PID),
                                       proj4string= CRS("+proj=longlat +datum=WGS84")) %>%
    spTransform(CRS(proj4string(CWWBoundary)))

  ABRWithin <- ABRLongLat@data[which(gContains(CWWBoundary, ABRLongLat, byid = TRUE)), ]

  ABRCWW <- data.frame(PID = ABRWithin) %>%
    left_join(df)

}
