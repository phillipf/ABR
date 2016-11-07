#' ABR CWW
#'
#' This extracts the ABR business location table from SQL and clips it to CWWs service area
#' @param URL the URL string used to query GoogleMaps
#' @keywords GoogleMapS, Place API, GoogleMaps API
#' @export
#' @examples
#' ABRCWW()
#'

ABRCWW <- function(date, CWW_DW = CWW_DW) {

  if(!require(RODBC)) {
    message("installing the 'RODBC' package")
    install.packages("RODBC")
  }

  if(!require(dplyr)) {
    message("installing the 'RODBC' package")
    install.packages("dplyr")
  }

  if(!require(sp)) {
    message("installing the 'sp' package")
    install.packages("sp")
  }

  if(!require(rgdal)) {
    message("installing the 'rgdal' package")
    install.packages("rgdal")
  }


  CWW_DW <- SQLconnect()

  ABRdf <- ABR::getABR(date = "20161024")

  ABR_CWW <-  ABR::CWWClip(ABRdf)



  }
