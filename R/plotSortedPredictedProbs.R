#' Plot sorted prediction probabilities
#'
#' @param probs.predicted A numeric vector of prediction probabilities.
#' @param logicals.expected A character vector of response labels. If provided, dots will be coloured by these labels.
#' @param cutoff If provided, a horizontal line will be drawn at the specified value to indicate the chosen cutoff.
#' @param show.confusion Show confusion matrix?
#' @param annotations A vector containining the desired legend names for the responses, e.g. c('BRCA proficient','BRCA deficient')
#' @param title User specified plot title. 
#'
#' @return A ggplot2 bar plot
#' @export
#'

plotSortedPredictedProbs <- function(probs.predicted, logicals.expected = NULL,
                                     cutoff = NULL, show.confusion = T, annotations = NULL, title = NULL)
{
   if( is.null(logicals.expected) ){
      df <- data.frame(probs.predicted)
   } else {
      df <- data.frame(probs.predicted, logicals.expected)
   }
   
   df <- df$probs.predicted %>% order(.) %>% df[.,]
   df$index <- 1:nrow(df)
   
   plot <- ggplot(data = df, aes(x = index, y = probs.predicted) ) +
      xlim(NA, max(df$index)) + xlab('Rank') + ylab('Probability') +
      theme(plot.title = element_text(hjust = 0.5),
            panel.background = element_blank(),
            panel.grid = element_blank(),
            axis.line = element_line(colour = "black"))
   
   if( !is.null(logicals.expected) ){
      plot <- plot + geom_bar(stat = 'identity', width = 1, aes(fill = logicals.expected ) )
         
      if(!is.null(annotations)){
         plot <- plot + scale_fill_manual(name = 'Annotation', labels = annotations, values = c('red','grey'))
      } 
      
      else {
         plot <- plot + scale_fill_manual(name = 'Annotation', values = c('red','grey'))
      }
      
   } else {
      plot <- plot + geom_bar(stat = 'identity', width = 1)
   }
   
   if( !is.null(title) ){ plot <- plot + ggtitle(title) }
   if( !is.null(cutoff) ){ plot <- plot + geom_hline(yintercept = cutoff, linetype = 2) }
   
   if(show.confusion == T){
      if(is.null(cutoff)){
         stop('Please specify cutoff for the confusion matrix')
      }
      m <- confusionMatrix(probs.predicted, logicals.expected, cutoff = cutoff)
      m <- rbind(
         m[c('tp','fp')],
         m[c('fn','tn')]
      )
      
      rownames(m) <- NULL
      colnames(m) <- NULL
      
      cols <- matrix(c('red','grey50'), nrow(m), ncol(m), byrow = T)
      tt <- ttheme_minimal(core=list(fg_params = list(col = cols)))
      
      table_confusion <- tableGrob(m, theme = tt)
      table_xpos <- nrow(df) * 0.15

      plot <- plot + annotation_custom(table_confusion, xmin=table_xpos, xmax=table_xpos, ymin=cutoff, ymax=cutoff)
   }
   
   return(plot)
}