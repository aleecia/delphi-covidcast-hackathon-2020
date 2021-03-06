% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/binary.R
\name{summarize_binary}
\alias{summarize_binary}
\title{Summarize binary variables at a geographic level}
\usage{
summarize_binary(
  df,
  crosswalk_data,
  var_yes,
  var_weight,
  params,
  smooth_days = 0L
)
}
\arguments{
\item{df}{a data frame of survey responses}

\item{crosswalk_data}{a named list containing geometry crosswalk files from zip5 values}

\item{var_yes}{name of the column in `df` containing the number of "yes" responses}

\item{var_weight}{name of the column in `df` containing the survey weights}

\item{params}{a named list with entries "start_time", and "end_time"}

\item{smooth_days}{integer; how many days in the past to smooth?}
}
\description{
Summarize binary variables at a geographic level
}
