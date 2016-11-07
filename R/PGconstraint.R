#' PostgreSQL add primary key constraint
#'
#' This adds a constrant to a table in PostgreSQL
#' @param tblname name of the table in the database
#' @param id name of the column to set as the primary key for the table
#' @param con. is the PostgreSQLConnection, defaults to conn in global environment
#' @param drop do you want to remove an existing contraint and drop the column?
#' @keywords PostgreSQL, constraint
#' @export
#' @examples
#' PGConstraint()
#'

PGconstraint <- function(tblname, id, con.=conn, drop = FALSE) {

  sql_command = c()

  if(drop == FALSE) {

    sql_command <- c(sql_command, paste("ALTER TABLE", tblname, "ADD CONSTRAINT", paste(tblname, "_", id, sep = ""), "PRIMARY KEY (", id, ")"))

  }

  else {

    column = paste(tblname, "_pkey", sep="")

    sql_command <- c(sql_command, paste("ALTER TABLE", tblname, "DROP CONSTRAINT", column))

    sql_command <- c(sql_command, paste("ALTER TABLE", tblname, "ADD CONSTRAINT", paste(tblname, "_", id, sep = ""), "PRIMARY KEY (", id, ")"))

    sql_command <- c( sql_command, paste("ALTER TABLE", tblname, "DROP COLUMN", "ogc_fid"))

  }

  lapply(sql_command, dbGetQuery, con=con.)

}
