% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/find_abundance.R
\name{find_abundance}
\alias{find_abundance}
\title{Fit experimental isotopic patterns}
\usage{
find_abundance(patterns, info, initial_abundance = NA, charge = 1)
}
\arguments{
\item{patterns}{A matrix of experimental isotopic patterns (one column for each sample), 
with the first two columns representing \emph{m/z} and retention time of the corresponding peaks}

\item{info}{Named list containing isotopic information, output of the \code{\link{isotopic_information}} function}

\item{initial_abundance}{Either NA, or a numeric vector of length equal to the number of samples, 
with the initial guesses on the percentage isotopic abundance of the labelling isotope 
(denoted as X, it can be either ^2H or ^13C). If provided, numbers between 0 and 100}

\item{charge}{Natural number, denoting the charge state of the target adduct (1,2,3,...). If not provided, it is 1 by default}
}
\value{
An object of class \code{labelling}, 
which is a list containing the results of the fitting procedure:
\item{compound}{Character vector specifying the chemical formula of the compound of interest, 
with X being the element with unknown isotopic distribution (to be fitted)}
\item{best_estimate}{Numeric vector of length equal to the number of samples, 
containing the estimated percentage abundances of the labelling isotope X 
(either ^2H or ^13C). Numbers between 0 and 100}
\item{std_error}{Numeric vector with the standard errors of the estimates, 
output of the \code{nls} fitting procedure}
\item{dev_percent}{Numeric vector with the percentage deviations between best fitted and related experimental patterns}
\item{x_scale}{Numeric vector containing the \emph{m/z} values relative to the signals of the experimental patterns}
\item{y_exp}{Matrix of normalised experimental isotopic patterns (one column for each sample). 
The most intense signal of each pattern is set to 100}
\item{y_theor}{Matrix of normalised fitted theoretical isotopic patterns (one column for each sample). 
The most intense signal of each pattern is set to 100}
\item{residuals}{Matrix of residuals: each column is the difference between experimental and best fitted theoretical patterns}
\item{warnings}{Character vector with possible warnings from the \code{nls} fitting procedure}
}
\description{
Function that takes each of the provided experimental MS isotopic patterns, 
and fits the best theoretical pattern that reproduces it through a weighted non-linear least squares 
procedure.
}
\examples{
\dontrun{
fitted_abundances <- find_abundance(patterns, info, initial_abundance=NA, charge=1)
}

}
\author{
Ruggero Ferrazza
}
\seealso{
\code{\link{isotopic_information}}
}

