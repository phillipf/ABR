#' Generate PostgreSQL script
#'
#' This creates a SQL upload script based on table parameters
#' @param path path to the location of the SQL create table scripts
#' dbname name of the database to connect to, default to ABRdb
#' type connection type, 1 = local database not requiring username/password, 2 = local database requiring username/password, 3 = remote database requiring username/password
#' user username for user account for database, defaults to NULL
#' host host for for database, defaults to NULL
#' @keywords PostgreSQL, ABRdb
#' @export
#' @examples
#' PostgreSQLcreatescript()
#'
#'

PostgreSQLcreatescript <- function(path, type, tblname = NULL, delim = ",", con. = conn) {

  if(!require(rgdal)) {
    message("installing the 'readr' package")
    install.packages("readr")
  }

  if(!require(rgeos)) {
    message("installing the 'rgeos' package")
    install.packages("rgeos")
  }

  SQLscript <- function(...) {

    arg <- list(...)

    idx <- which(arg[[1]]=="character")

    arg[[1]][which(arg[[1]]=="numeric")] <- "integer"

    arg[[1]][idx] <- paste(arg[[1]][idx], paste("varying(", arg[[2]][idx], ")", sep = ""))

    arg[[1]]

  }

  if(type == "spatial") {

    file <- readOGR(path, layer= gsub(".*/(.+)\\..+$","\\1", path), stringsAsFactors = FALSE)

    a <- lapply(file@data, class)
    b <- lapply(file@data, function(x) max(nchar(x)))

    tblname = gsub(".*/(.+)\\..+$","\\1", path)

    query <- paste("CREATE TABLE", tblname, "(", paste(names(a), SQLscript(a,b), collapse = ','), ", geom geometry", ")")

    dbSendQuery(con., query)
  }

  else if(type == "table") {

    file <- read.delim(path, sep = delim, stringsAsFactors = FALSE)

    a <- lapply(file, class)
    b <- lapply(file, function(x) max(nchar(x)))

    if(!missing(tblname)) {
      query <- paste("CREATE TABLE", tblname, "(", paste(names(a), SQLscript(a,b), collapse = ','), ")")
    }

    else {
    tblname = gsub(".*/(.+)\\..+$","\\1", path)

    query <- paste("CREATE TABLE", tblname, "(", paste(names(a), SQLscript(a,b), collapse = ','), ")")

    }

    dbSendQuery(con., query)

  }

}
