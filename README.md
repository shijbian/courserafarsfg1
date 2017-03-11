---
title: "README"
author: "FG"
date: "3/11/2017"
output: html_document
---


## FARS FUNCTIONS

This package include 5 functions:

* fars_read
* make_filename
* fars_read_years
* fars_summarize_years
* fars_map_state



### fars_read()

Read .csv data file

This function check for the existance of a given `filename`, and if the .csv file exist,
it read it and convert it into dataframe.

If the `filename` you provide does not existe, the function stops and return an error message

`read_csv` is evaluated in a context that ignores all ‘simple’ diagnostic messages.

Parameters:

 * `filename` A character string giving the name or path of the csv file to be read. Accepts compressed csv file.


This function returns a dataframe with data read from a .csv file.

Dependencies:

* `readr::read_csv`
* `dplyr::tbl_df`

Examples:

```r
fars_read("filename.csv")
fars_read("pathname/filename.csv")
```


### make_filename()

Print filename for a given year.

This function print a character vector with the filename combining the default file name and the `year` passed as argument to the function

Parameters: 

* `year` An integer. The function coherce the passed value to an integer


This function returns a character vector containing a formatted combination of text and year number.

Examples:

```r
make_filename(2017)
make_filename(4034/2)
```


### fars_read_years()

Read multiple .csv data file for a series a provided years

This function take as input a vector of integers (`years`) representig years, make the
defalut filename for each year, and read the data in and convert it into data frame.

For each year with no data file, the function returns an error message.

Parameters:

* `years` A vector of integers representing a series of years

This function returns a dataframe with 2 columns for each year, representing
month number and year of each recorded data.

Dependencies:

* `dplyr::mutate`
* `dplyr::select`

Examples:

```r
fars_read_years(2013)
fars_read_years(2013:2015)
```


### fars_summarize_years()

Summarize records per month for a series a provided years

This function takes a series of years (`years`) as input and returns a tibble with
the number of records per month, by year.

Parameters:

* `years` A vector of integers representing a series of years

Dependencies:

* `dplyr`
* `tidy::spread`

Examples:

```r
fars_summarize_years(2013)
fars_summarize_years(2013:2015)
```



### fars_map_state()

Plot a map with all accidents in a given State in a given year.

This function takes a State number (`state.num`) indicator and a year (`syear`), and plots a map with all the accident recorded in the given State/year.

If the State number does not exhist in the data for the given year returns a message with "invalid STATE number".
If there are no accidents in the given State for the given year, it returns a messagesaying "no accidents to plot".

Parameters:

* `state.num` an integer representing a State code number. It is coherced into an integer.
* `year` an integer representing a year.


Dependencies:

* `dplyr::filter`
* `maps::map`
* `graphics::points`

Examples:

```r
fars_map_state(23, 2013)
```




> This Vignette was created as part of the final assignment to the cours **"Building R Packages"** from JHU through Coursera.


