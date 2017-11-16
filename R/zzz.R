.onAttach <- function(libname, pkgname) {
    packageStartupMessage("\nghibliapi version ", utils::packageVersion("ghibliapi"), ", ?ghibliapi to start.")
    options("REST.URL"="https://ghibliapi.herokuapp.com")
}
