#' Function to plot based on value type
#' 
#' @export
#' @param df list of df's 
#' @return list of ggplot objects 
geom_likelihood = function(df) {
  
  #check type of value column
  value_type = class(df[,1])
  
  cnames = colnames(df)
  
  if (value_type == "numeric") {
    p = ggplot2::ggplot(data = df, aes(x = .data[[cnames[1]]], y = .data[[cnames[2]]])) +
      geom_path() +
      lims(y = c(0, 1)) +
      theme_classic()
  } else if (value_type %in% c("character", "factor")) {
    df[[1]] = factor(df[[1]], levels = sprintf("%0.i", seq_len(length(unique(df[[1]])))))
    p = ggplot2::ggplot(data = df, aes(x = .data[[cnames[1]]], y = .data[[cnames[2]]])) +
      geom_col() +
      lims(y = c(0, 1)) +
      theme_classic()
  }

}

#' Function to gather and patchwork the plots
#' 
#' @export
#' @param df list of dataframes to apply the geom_response to
#' @return a patchworked list of ggplots
gather_plots = function(df) {
  z = lapply(df, geom_likelihood)
  patch = patchwork::wrap_plots(z)
  print(patch)
}
