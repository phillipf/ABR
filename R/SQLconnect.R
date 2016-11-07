#' SQLconnect
#'
#' This connects to WVDb1DEVSQL CWW_DW
#' @keywords SQL, WVDb1DEVSQL, CWW_DW
#' @export
#' @examples
#' SQLconnect()
#'
#'
SQLconnect <- function() {

  if(!require(RODBC)) {
    message("installing the 'RODBC' package")
    install.packages("RODBC")
  }

odbcDriverConnect(connection="Driver={SQL Server Native Client 11.0};
                              server= WVdb1devsql;
                            database=CWW_DW;
                            uid=report;
                            pwd=report")}
