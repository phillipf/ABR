#' PostgreSQL remove duplicate rows
#'
#' This removes duplicate rows in a PostgreSQL table
#' @param tblname name of the table in the database
#' @param id name of the column to set as the primary key for the table
#' @param con. is the PostgreSQLConnection, defaults to conn in global environment
#' @param drop do you want to remove an existing contraint and drop the column?
#' @keywords PostgreSQL, constraint
#' @export
#' @examples
#' PGdropduplicates()
#'

PGdropduplicates <- function(tblname, id, con. = conn) {

  sql_command =  paste("DELETE FROM",
                        tblname,
                        "WHERE", id, "IN (SELECT", id, "FROM (SELECT", paste(id, ",", sep=""), "ROW_NUMBER() OVER (partition BY",
                        paste(tblname, ".*", sep=""),
                        "ORDER BY", paste(id,")", sep = ""), "AS rnum FROM",
                        paste(tblname, ")", sep = ""),
                        "t WHERE t.rnum > 1);")

  dbGetQuery(sql_command, con = con.)

}
