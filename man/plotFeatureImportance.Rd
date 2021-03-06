% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotFeatureImportance.R
\name{plotFeatureImportance}
\alias{plotFeatureImportance}
\title{Plot feature importance}
\usage{
plotFeatureImportance(
  df,
  final.model.imp = NULL,
  title = NULL,
  mid.function = "mean",
  sort = T,
  export.features = F
)
}
\arguments{
\item{final.model.imp}{If a vector is provided, red dashes will be added to the plot according to vector values. Used
for overlaying the feature importance of the final model over feature importance as determined by cross-validation}

\item{title}{User specified plot title. If unspecified, title defaults to 'Feature importance'}

\item{sort}{Whether to sort the features by decreasing importance}

\item{export.features}{If TRUE, only returns a vector containing the feature names}

\item{df.importance}{A data.frame containing a column of feature names and a column of MeanDecreaseAccuracy values}
}
\value{
Returns a ggplot2 scatter plot
}
\description{
Plot feature importance
}
