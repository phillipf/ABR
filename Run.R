
detach("package:ABR", unload=TRUE)

library(devtools)
library(roxygen2)
remove.packages("ABR")
#setwd("C:/")
#create("GoogleAPI")
setwd("C:/ABR")
document()
setwd("C:/")
install("ABR")
library(ABR)
setwd("C:/ABR")

conn <- ABR::PostgreSQLconnect()

ABR::PostgreSQLcreatescript(path = "file:///N:/ABR/Output 1 Dynamic Model/Realtime/22092016_ABR_ANZSIC_bar.csv", type = "table", tblname = "abr_anzsic_bar")

##upload the barred ANZSIC table

Anzsic_bar <- read.csv("file:///N:/ABR/Output 1 Dynamic Model/Realtime/22092016_ABR_ANZSIC_bar.csv")

dbWriteTable(con=conn,
             name="abr_anzsic_bar",
             value=Anzsic_bar,
             row.names=FALSE,
             append=TRUE)

#bulk upload the ABR tables
ABR::PostgreSQLcreatetable(path = "C:/ABRdata/postgresql/CreateTable")

ABR::PostgreSQLupload(pathtodata = "C:/ABRdata/VIC_ABR Extract/", pathtoSQL = "C:/ABRdata/postgresql/CreateTable", type = "data", con = con)

#upload parcels and CSS_boundary
ABR::PostgreSQLupload(pathtobat = "C:/ABR", type = "spatial", con = conn)

#process the Parcels layer
##get rid of duplicate row
###why are there duplicate rows?
ABR::PGdropduplicates("parcels", id = "ogc_fid", con. = conn)

##Add a constraint for GID
ABR::PGconstraint("parcels", "gid", drop = TRUE)

#Process the cww_boundary later
##add SRID
ABR::PGaddSRID(tblname = "cww_boundary_2014_region", geom = "Polygon", geomcol = "wkb_geometry" , epsg = 28355)

#process the business location table
##add a geometry column
ABR::PGaddGeom(tblname = "abr_businesslocation", epsg = 4326, x = "longitude", y = "latitude")



##add a constraint
PGconstraint <- function(tblname, id, con.=conn, drop = FALSE) {

    sql_command <- paste("ALTER TABLE", tblname, "ADD CONSTRAINT", paste(tblname, "_", id, sep = ""), "PRIMARY KEY (", id, ")")

  sql_command}

ABR::PGconstraint("abr_businesslocation", "pid", drop = FALSE)

PGdropcolumn <- function(tblname, column, con.=conn) {

  sql_command <- paste("ALTER TABLE", tblname, "DROP COLUMN", column)

  dbGetQuery(con., sql_command)

}

PGdropcolumn(tblname ="abr_businesslocation", column = "geom")

PGtransform <- function(tblname, geom, geomcol, from_epsg, to_epsg, con = conn) {

  sql_command <- paste("ALTER TABLE", tblname, paste(paste("ALTER COLUMN",
                                                           geomcol, "TYPE geometry"), "(", geom, ",", sep = ""),
                       paste(from_epsg, ")", sep = ""), paste("USING ST_Transform(", geomcol,
                                                      ",", sep = ""), paste(to_epsg, ")", ";", sep = ""))

  sql_command
  dbGetQuery(con, sql_command)
}

PGtransform(tblname = "abr_businesslocation", from_epsg = 28355, to_epsg = 28355, geomcol = "geom", geom = "Point")





