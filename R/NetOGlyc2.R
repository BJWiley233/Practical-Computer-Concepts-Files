#' Reads in output file from NetOGlyc 2.0 since gnuplot doesn't work
#' 
#' @author Brian Wiley
#' @import dplyr, argparser, ggplot2, ggtext
#' @docType script
#' @description NetOGlyc 2.0 since gnuplot doesn't work does not
#' print graph so you need to copy and paste the Thr and Ser to
#' a text file or save the html ouput 
#' @param input Input file from running NetOGlyc 2.0 with protein sequence(s)
#' @param type File type; either copy and pasted the Thr and Ser 6 columns
#' to text file or you save the html doc
#' @param output Optional output file name. Default <input>.pdf 
#' @param keyResidues Optional vector for key residues: comma separated list no spaces
#' must be in form "1,2,3,..." or 1,2,3,...
#' @param mark Optional mark for key residues: either point of vertical line; default is point
#' @example 
#' Rscript NetOglyc2.R -i vgp_ebov.txt -t txt -o vgp_ebov_glyc.pdf -k "25,90,210,328" -m point
#' Rscript NetOglyc2.R -i vgp_ebov.html -t html -o vgp_ebov_glyc.pdf -k "25,90,210,328" -m line
#' Rscript NetOglyc2.R -i CACNA1A_isoform1_A712T.html.html -t html -o Variant_A712T.pdf -k "712" -m point


library(argparser)
plot_Ogly <- arg_parser('A program to plot NetOGlyc 2.0: predicted O-glycosylation sites\
  Examples:\n\
  NetOglyc2.R -i vgp_ebov.txt -t txt -o vgp_ebov_glyc.pdf -k "25,90,210,328" -m line\n\
  NetOglyc2.R -i CACNA1A_isoform1_A712T.html.html -t html -k "712" -m point')

#' TODO add variant residue # for "No." to color different color for midterm
p <- add_argument(plot_Ogly,
                  c("--input", "--type", "--output", "--keyResidues", "--mark"),
                  help = c("input file", "type: txt (6 columns) or html from site",
                           "optional output file name: default is <input>.pdf",
                           'optional key residues to mark on graph \
                            must be in form "1,2,3,..." or 1,2,3,... without spaces',
                           "optional mark type for key residues; either line or point \
                            ignored if key residues is blank")
                  )

argv = parse_args(p)


## run parameter options
if (is.na(argv$input)) {
  stop("Requires input file")
}
if (is.na(argv$type) || (argv$type != 'txt' && argv$type != 'html')) {
  stop("Requires file type. Either 'txt' or 'html'")
}
if (is.na(argv$output)) {
  output = paste0(tools::file_path_sans_ext(argv$input), '.pdf')
} else {
  output = argv$output
}

argv$input <- "C:\\Users\\bjwil\\JHU Classes\\Protein Bioinformatics\\Code\\CACNA1A_isoform1_A712T.html"
if (argv$type == 'txt') {
  df1 <- read.csv(argv$input, sep = '', header=T, stringsAsFactors = F, strip.white=TRUE)
  df <- df1[!df1["Name"]=='Name', ]
} else if (argv$type == 'html') {
  skip = grep("^$", readLines(argv$input))[2]
  df1 <- read.csv(argv$input, sep = '', skip = skip,
                  header=T, stringsAsFactors = F, strip.white=TRUE)
  non_tag_rows <- grepl('^\\w', df1$Name)
  df <- df1[non_tag_rows, ]
  df <- df[!df["Name"]=='Name', ]
}
if (is.na(argv$keyResidues)) {
  argv$mark = NA
} else {
  tryCatch({
    argv$keyResidues = as.integer(strsplit(argv$keyResidues, ",")[[1]])
    argv$keyResidues = base::intersect(argv$keyResidues, df$No.)
    },
    error=function(cond) {
      message(paste("There was error with keyResidues input", argv$keyResidues, 
                    "Run --help for entry format"))
      message("Here's the original error message:")
      message(cond)
      argv$keyResidues=NA
    },
    warning=function(cond) {
      message("There was warning with keyResidues input. Run --help for entry format")
      message("Here's the original error message:")
      message(cond)
    }
  )        
  if (is.na(argv$mark)) {
    argv$mark <- 'point'
  } else if (argv$mark == 'line') {
    # nothing stays line
  } else {
    argv$mark <- 'point'
  }
}


library(dplyr)
df[3:5] = sapply(df[3:5], as.numeric)
final_df <- df %>% arrange(No.)


library(ggplot2)
library(ggtext)
if (max(final_df$No.) > 1000 && max(final_df$No.) <= 2000) {
  pdf(output, width = 8, height = 4)
  legendPosition <- c(0.92, 0.94)
} else if (max(final_df$No.) > 2000) {
  pdf(output, width = 10, height = 5)
  legendPosition <- c(0.95, 0.96)
} else {
  pdf(output, width = 7, height = 4)
  legendPosition <- c(0.92, 0.94)
}


g <- ggplot(data=final_df) +
  geom_bar(aes(x=No., y=Potential, colour='Potential'), stat = 'identity', width=0.5) +
  geom_line(aes(x=No., y=Threshold, colour='Threshold')) +
  ggtitle('NetOGlyc 2.0: predicted O-glycosylation sites in vgp_ebov') +
  scale_x_continuous(breaks = seq(0, max(final_df$No.), by = 100),
                     limits = c(0, max(final_df$No.)+.015*max(final_df$No.)), expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, 1.2), expand = c(0, 0), breaks = c(0.00, 0.50, 1.0)) +
  theme_bw() +
  scale_color_manual("", 
                     values = c("blue", "red"),
                     labels = paste("<span style='color:",
                                    c("blue", "red"),
                                    "'>",
                                    c("Potential", "Threshold"),
                                    "</span>")) +
  guides(color = guide_legend(order = 0, 
                              override.aes = list(fill  = c('white', 'white'),
                                                  linetype = c("solid", "solid"),
                                                  colour = c("blue", "red"),
                                                  shape = c(19, 19)))) +
  theme(legend.text=element_markdown(size=8)) +
  theme(legend.background = element_blank(),
        axis.text.x = element_text(angle = 30, hjust = 1),
        plot.title = element_text(hjust = 0.5, size = 12),
        legend.position = legendPosition,
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  labs(x='Sequence Position', y='O-glycosylation potential')

if (!is.na(argv$keyResidues) && !is.na(argv$mark)) {
  points_lines <- df[df$No. %in% argv$keyResidues, ]
  if (argv$mark == 'point') {
    g <- g + geom_point(data=points_lines, aes(x=No., y=Potential), 
                        color='black', cex=2)
  } else if (argv$mark == 'line') {
    g <- g + geom_bar(data=points_lines,
                      aes(x=No., y=Potential), color='black',
                      stat='identity', width = 3)
  }
}
g
dev.off()


