#' PostgreSQL upload data
#'
#' This uploads data from the Global Environment and inputs it into a table in PostgreSQL
#' @param path path to the location of the SQL create table scripts
#' @param dbname name of the database to connect to, default to ABRdb
#' @param type connection type, 1 = local database not requiring username/password, 2 = local database requiring username/password, 3 = remote database requiring username/password
#' @param user username for user account for database, defaults to NULL
#' @param host host for for database, defaults to NULL
#' @keywords PostgreSQL, ABRdb
#' @export
#' @examples
#' PostgreSQLupload()
#'

PostgreSQLupload <- function(pathtodata = NULL, pathtoSQL= NULL, tblname = NULL, pathtobat = NULL, type, con= con) {

  if(!require(readr)) {
    message("installing the 'readr' package")
    install.packages("readr")
  }

  if(!require(dplyr)) {
    message("installing the 'dplyr' package")
    install.packages("dplyr")
  }

  if(type == "data") {

  SQL <- gsub("(.*)(\\.sql)","\\1",list.files(path = pathtoSQL, pattern = ".*\\.sql", full.names = FALSE))


  datadir <- list.files(path = pathtodata, full.names = TRUE)

  datadir <- datadir[unlist(lapply(SQL, function(x) which(grepl(x, datadir) == TRUE)))]

  data <- lapply(datadir, read_tsv, col_names = FALSE)

  #ABR_Agency_Data <- read_tsv("C:/ABRdata/VIC_ABR Extract/VIC161024_ABR_Agency_Data.txt",
                              #col_names = FALSE)

  clean <- function(x) {
    if(nrow(problems(x)) != 0){

      as.data.frame(x[-unique(problems(x)$row),])}

    else {
      as.data.frame(x)}
  }

  data2 <- lapply(data, clean)

  #ABR_Agency_Data2 <- as.data.frame(ABR_Agency_Data[-unique(problems(ABR_Agency_Data)$row),])
  convert <- function(x) {
            if(is.character(x)) {
              ifelse(Encoding(x) == "UTF-8",
              gsub("<.+>","", enc2native(x)),
              x)}
            else {x}
  }

  data2 <- lapply(seq_along(data2), function(i) data.frame(lapply(data2[[i]], convert), stringsAsFactors=FALSE))

  #ABR_Agency_Data2[] <- lapply(ABR_Agency_Data2, function(x) if(is.character(x)) {ifelse(Encoding(x) == "UTF-8",
                                                                                         #gsub("<.+>","", enc2native(x)),
                                                                                         #x)}
                               #else {x})

  upload <- function(df, name, con. = con) {
    dbWriteTable(conn=con.,
                 name=name,
                 value=df,
                 row.names=FALSE,
                 append=TRUE)
  } #"con." fixes the con = con error

  names(data2) <- tolower(SQL)


  lapply(seq_along(data2), function(i) upload(df=data2[[i]], name=names(data2)[i]))
  #dbWriteTable(conn=con,
              #name=c("abr_agency_data"),
               #value=ABR_Agency_Data2,
               #row.names=FALSE,
               #append=TRUE)
  }

  else if(type == "spatial") {

    batdir <- list.files(path = pathtobat, pattern = ".*\\.bat", full.names = TRUE)

    lapply(batdir, system)
  }

 }
