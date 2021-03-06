#' Create a data.frame table (dft)
#'
#' Create a descriptive frequencies table with descriptive statistics by group.
#'
#' @param data1 a vector or data.frame column
#' @param prop logical, if \code{TRUE} returns an additional proportion column
#' @param perc logical, if \code{TRUE} returns an additional percentage column
#' @param by numeric variable to return descriptive statistics for
#' @param neat logical, if \code{TRUE} returns a tailored dataset
#' @param digits integer, number of digits to round to
#'
#' @return a data.frame table with optional proportion, percentage, and
#'   descriptive statistics columns
#' @import psych
#' @export
#'
#' @examples
#' dft(iris2$Species)
#' dft(iris2$Species, by = iris2$Sepal.Length)
#'
dft <- function(data1, prop = TRUE, perc = TRUE, by = NULL, neat = TRUE, digits = 2){
  t    <- table(data1)
  dft  <- data.frame(t)

  var1 = deparse(substitute(data1))
  var1 = strsplit(var1, "\\$")[[1]][2]

  if(ncol(dft) == 2) {
    names(dft) <- c(var1, "n")
  } else if(ncol(dft) > 2){
    names(dft)[length(dft)] <- "n"
  }

  if(prop) {
    prop <- table_prop(t)
    dft  <- data.frame(dft, prop)
  }
  if(perc) {
    perc <- table_perc(t)
    dft <- data.frame(dft, perc)
  }
  if(!is.null(by)) {
    descr <- describeBy(by, data1, mat = T)
    dft <- cbind(dft, descr[, (which(names(descr) == "n")+1):length(descr)])
    if(neat) {
      dft <- cbind(dft[, 1:which(names(dft) == "n")],
                   round(dft[, c("prop", "mean", "sd", "se")],
                         digits = digits))
    }
  }

  return(dft)
}

# dft helper function - proportions
# test - print(table_prop(table(iris2$Species)))
table_prop <- function(table){
  table.prop <- as.vector(table)/sum(table)
}

# dft helper function - percentages
# test - print(table_perc(table(iris2$Species)))
table_perc <- function(table){
  table.prop <- table_prop(table)
  table.perc <- format(round(table.prop*100, 1), nsmall = 1)
  table.perc <- gsub("$", "%", table.perc)
}

