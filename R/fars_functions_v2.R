utils::globalVariables(c("MONTH", "STATE", "year"))
#' Read .csv data file
#'
#' This function check for the existance of a given \code{filename}, and if the .csv file exist,
#' it read it and convert it into dataframe.
#'
#' If the \code{filename} you provide does not existe, the function stops and return an error message
#'
#' @note read_csv is evaluated in a context that ignores all ‘simple’ diagnostic messages. See: \code{\link{message}}
#'
#' @param filename A character string giving the name or path of the csv file to be read. Accepts compressed csv file.
#'
#' @return This function returns a dataframe with data read from a .csv file.
#'
#' @importFrom readr read_csv
#' @importFrom dplyr tbl_df
#'
#' @examples
#' \dontrun{
#' fars_read("filename.csv")
#' fars_read("pathname/filename.csv")
#' }
#'
#' @export
fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::tbl_df(data)
}


#' Print filename for a given year
#'
#' This function print a character vector with the filename combining the default
#' file name and the \code{year} passed as argument to the function
#'
#' @param year An integer. The function coherce the passed value to an integer
#'
#' @return This function returns a character vector containing a formatted combination of text and year number.
#'
#' @examples
#' \dontrun{
#' make_filename(2017)
#' make_filename(4034/2)
#' }
#'
#' @export
make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}


#' Read multiple .csv data file for a series a provided years
#'
#' This function take as input a vector of integers (\code{years}) representig years, make the
#' defalut filename for each year, and read the data in and convert it into data frame.
#'
#' For each year with no data file, the function returns an error message.
#'
#' @param years A vector of integers representing a series of years
#'
#' @return This function returns a dataframe with 2 columns for each year, representing
#' month number and year of each recorded data
#'
#' @importFrom dplyr mutate select %>%
#'
#' @examples
#' \dontrun{
#' fars_read_years(2013)
#' fars_read_years(2013:2015)
#' }
#'
#' @export
fars_read_years <- function(years) {
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select(MONTH, year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}


#' Summarize records per month for a series a provided years
#'
#' This function takes a series of years (\code{years}) as input and returns a tibble with
#' the number of records per month, by year.
#'
#' @param years A vector of integers representing a series of years
#'
#' @import dplyr
#' @importFrom tidyr spread
#'
#' @examples
#' \dontrun{
#' fars_summarize_years(2013)
#' fars_summarize_years(2013:2015)
#' }
#'
#' @export
fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(year, MONTH) %>%
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}


#' Plot a map with all accidents in a given State in a given year
#'
#' This function takes a State number (\code{state.num}) indicator and a year (\code{year}),
#' and plots a map with all the accident recorded in the given State/year.
#'
#' If the State number does not exhist in the data for the given year,
#' returns a message with "invalid STATE number".
#'
#' If there are no accidents in the given State for the given year, it returns a message
#' saying "no accidents to plot"
#'
#' @param state.num an integer representing a State code number. It is coherced into an integer.
#' @param year an integer representing a year.
#'
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#' @examples
#' \dontrun{
#' fars_map_state(23, 2013)
#' }
#'
#' @export
fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)

  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}
