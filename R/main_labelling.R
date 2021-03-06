#' Main function of the package
#' 
#' It computes the estimated X abundances of each sample, 
#' returning an object of the class \code{labelling}.
#' 
#' @param peak_table A data.frame containing the integrated signals for the samples 
#' @param compound The chemical formula of the compound of interest
#' @param charge Natural number, denoting the charge state of the target adduct (1,2,3,...). If not provided, it is 1 by default 
#' @param labelling Character, either "H" or "C", specifying which is the labelling element
#' @param mass_shift Maximum shift allowed in the mass range
#' @param RT Expected retention time of the compund of interest
#' @param RT_shift Maximum shift allowed in the retention time range
#' @param chrom_width Chromatographic width of the peaks
#' @param initial_abundance Initial estimate for the abundance of the heaviest X isotope (the label)
#' 
#' @details 
#' \itemize{
#'  \item{peak_table:}{ The first two columns of \code{peak_table} represent the mass and the retention time of the peaks; 
#'  the other columns represent peak intensities for each sample. 
#'  The table can be obtained using the function \code{table_xcms}}
#'  \item{compound:}{ Character vector, where X has to represent the element with isotopic distribution to be fitted}
#'  \item{initial_abundance:}{ Numeric vector of the same length as the number of samples, with the initial estimate 
#'   for the abundance of the heaviest X isotope (either ^2H or ^13C). If provided, number between 0 and 100. Otherwise, NA}
#' }
#' 
#' @return An object of the class \code{labelling}, which is a list containing the results from the fitting procedure:
#'  \item{compound}{ Character vector specifying the chemical formula of the compound of interest, 
#'   with X being the element with unknown isotopic distribution (to be fitted)}
#'  \item{Best_estimate}{ Numeric vector representing the best estimated abundance 
#'  of the heaviest X isotope (either ^2H or ^13C). Number between 0 and 100}
#'  \item{std_error}{ Numeric vector containing the standard errors of the estimates}
#'  \item{dev_percent}{ The percentage deviations of the fitted theoretical patterns to the provided experimental patterns}
#'  \item{x_scale}{ Vector containing the \emph{m/z} signals of the isotopic patterns}
#'  \item{y_exp}{ Matrix containing normalised experimental patterns, 
#'  where for each sample the most intense signal is set to 100}
#'  \item{y_theor}{ Matrix of normalised fitted theoretical pattern (most intense signal set to 100 for each sample)}
#'  \item{warnings}{ Character vector containing possible warnings coming from the fitting procedure}
#'  
#'  
#' @examples
#' 
#' data(xcms_obj)
#' peak_table <- table_xcms(xcms_obj)
#' fitted_abundances <- main_labelling(peak_table, 
#'                                     compound="X40H77NO8P", 
#'                                     charge=1,
#'                                     labelling="C", 
#'                                     mass_shift=0.05, 
#'                                     RT=285, 
#'                                     RT_shift=20, 
#'                                     chrom_width=7, 
#'                                     initial_abundance=NA)
#' summary(object=fitted_abundances)
#' plot(x=fitted_abundances, type="patterns", saveplots=FALSE)
#' plot(x=fitted_abundances, type="residuals", saveplots=FALSE)
#' plot(x=fitted_abundances, type="summary", saveplots=FALSE)
#' save_labelling(fitted_abundances)
#' grouped_estimates <- group_labelling(fitted_abundances, 
#'                                      groups=factor(c(rep("C12",4), 
#'                                                      rep("C13",4))))
#' # Other possible lipid compounds include:
#' # [PC34:1 + H]+. compound="X42H83NO8P", RT=475, chrom_width=10
#' # [TAG47:3 + NH4]+(a minor species). compound="X50H94NO6", 
#' #                                    RT=891, chrom_width=7
#' @author Ruggero Ferrazza
#' @keywords manip
#' @export



main_labelling <- function(peak_table, 
                           compound, 
                           charge=1,
                           labelling, 
                           mass_shift, 
                           RT, 
                           RT_shift, 
                           chrom_width, 
                           initial_abundance=NA){


  # Get some useful isotopic information, to be used in the coming functions
  info <- isotopic_information(compound, charge, labelling)
  
  # Extract one pattern for each sample (each column of the peak_table data frame)
  experimental_patterns <- isotopic_pattern(peak_table, info, mass_shift, RT, RT_shift, chrom_width)
  
  # For each extracted pattern, find the X isotopic distribution that better fits the experimental data 
  fitted_abundances <- find_abundance(patterns=experimental_patterns, info, initial_abundance, charge)
  
  return(fitted_abundances)
  
}
