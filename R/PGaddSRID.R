#' PostgreSQL add SRID
#'
#' This adds a spatial reference system to a table
#' @param tblname name of the table in the database
#' @param geom the type of the geometry in the datatable E.g. MultiPloygon, MultiPoint
#' @param geomcol is the name of the column containing the geometry
#' @param epsg what SRID code is the geometry column using? E.g. (EPSG:28355, EPSG:4326 etc.)
#' @param con the PostgreSQL connection string
#' @keywords PostgreSQL, SRID, epsg
#' @export
#' @examples
#' PGaddSRID()
#'
PGaddSRID <- function(tblname, geom, geomcol, epsg, con = conn) {

  sql_command <- paste("ALTER TABLE",
                       tblname,
                       paste(paste("ALTER COLUMN", geomcol, "TYPE geometry"), "(", geom, ",", sep = ""),
                       paste(0, ")", sep = ""),
                       paste("USING ST_SetSRID(", geomcol, ",", sep = ""),
                       paste(epsg, ")", ";", sep = "")
  )

  dbGetQuery(con, sql_command)
}
