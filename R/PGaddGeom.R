#' PostgreSQL add geom column
#'
#' This adds a geometry column to a data table
#' @param tblname name of the table in the database, defaults to ABRdb
#' @param geom the type of the geometry in the datatable E.g. MultiPloygon, MultiPoint, defaults to POINT
#' @param x name of latitude column
#' @param y name of longitude column
#' @param epsg what SRID code is the geometry column using? E.g. (EPSG:28355, EPSG:4326 etc.)
#' @param con the PostgreSQL connection string
#' @keywords PostgreSQL, geom
#' @export
#' @examples
#' PGaddGeom()
#'

PGaddGeom <- function(db = "ABRdb", tblname, epsg, x, y, geom = "POINT", con = conn) {

  sql_command <- paste("ALTER TABLE",
                       tblname,
                       "ADD COLUMN",
                       "geom",
                       paste("geometry(Geometry,",epsg, ")"))
  dbGetQuery(con, sql_command)

  sql_command <- paste("UPDATE",
                       tblname,
                       "SET geom =",
                       paste("ST_SetSRID(ST_MakePoint(", x, ",", sep = ""),
                       paste(y, "),", sep = ""),
                       paste(epsg, ")", sep = ""))


  dbGetQuery(con, sql_command)

}
