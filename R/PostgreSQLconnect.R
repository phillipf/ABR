#' PostgreSQL connect
#'
#' This connects to PostgreSQL server
#' @param dbname name of the database to connect to, default to ABRdb
#' type connection type, 1 = local database not requiring username/password, 2 = local database requiring username/password, 3 = remote database requiring username/password
#' user username for user account for database, defaults to NULL
#' host host for for database, defaults to NULL
#' @keywords PostgreSQL, ABRdb
#' @export
#' @examples
#' PostgreSQLconnect()
#'
#'
PostgreSQLconnect <- function(dbname = "ABRdb", type = 1, user = NULL, host = NULL) {

  if(!require(RPostgreSQL)) {
    message("installing the 'RPostgreSQL' package")
    install.packages("RPostgreSQL")
  }

  system("C:/bin/pgsql/run.bat")

  Sys.sleep(3)

  # Case 1: local database not requiring username/password
  if(type == 1) {

    con <- dbConnect(dbDriver("PostgreSQL"), dbname=dbname)
  }

  # Case 2: local database requiring username/password
  else if(type == 2) {

    con <- dbConnect(dbDriver("PostgreSQL"), user=user,
                     password=scan(what=character(),nmax=1,quiet=TRUE), dbname=dbname)
  }


  # Case 3: remote database requiring username/password
  else {
    con <- dbConnect(dbDriver("PostgreSQL"), user=user,
                     password=scan(what=character(),nmax=1,quiet=TRUE), dbname=dbname, host=host)
  }

  return(con)

}


