#' PostgreSQL create table
#'
#' This creates the ABR tables in the ABRdb database
#' @param path path to the location of the SQL create table scripts
#' dbname name of the database to connect to, default to ABRdb
#' type connection type, 1 = local database not requiring username/password, 2 = local database requiring username/password, 3 = remote database requiring username/password
#' user username for user account for database, defaults to NULL
#' host host for for database, defaults to NULL
#' @keywords PostgreSQL, ABRdb
#' @export
#' @examples
#' PostgreSQLcreatetable()
#'

PostgreSQLcreatetable <- function(path, dbname = "ABRdb", type = 1, user = NULL, host = NULL) {

  if(!require(RPostgreSQL)) {
    message("installing the 'RPostgreSQL' package")
    install.packages("RPostgreSQL")
  }

  con <- PostgreSQLconnect(type = 1)

  SQL <- list.files(path = path, pattern = ".*\\.sql", full.names = TRUE)

  lines <- lapply(SQL, function(x) paste(readLines(x), collapse=""))

  lapply(lines, function(x) dbGetQuery(con, x))

}
