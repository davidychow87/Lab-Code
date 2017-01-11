require(ggplot2)
require(MASS)
require(scales)
setwd('X:/fast/shou_w/shougroup/lab_users/David_Chow/Experiments Notebook/KV_Growth_rate/')

data<-read.csv('kv600.csv',header=T)

title<- expression(paste(italic("Kv "), "Growth" ))

ylabel <- expression(paste("Gen 5 OD"[600]))

temp<-data[which((data$hr < 31) & (data$hr > 1)),]

set <- c(
          data[which((data$hr < 11) & (data$hr > 1)),],
          data[which((data$hr < 31) & (data$hr > 1)),],
          data[which((data$hr < 31) & (data$hr > 1)),],
          data[which((data$hr < 31) & (data$hr > 1)),],
          data[which((data$hr < 31) & (data$hr > 1)),],
          data[which((data$hr < 31) & (data$hr > 1)),]
  
        )

scaleFUN <- function(x) sprintf("%.2f", x)
g<-ggplot(data, aes(x=hr, y=avg, col=sample))+geom_line(linetype=0, size=1)+geom_point(size=4.5, shape=1)+
  geom_errorbar(aes(ymin=avg-stdev, ymax=avg+stdev,col=sample), width=3, linetype=1)+
  annotation_logticks(sides = 'l')+
  scale_y_continuous(trans = log10_trans(), 
    breaks = trans_breaks('log10', function(x) 10^x),
    labels = scaleFUN #trans_format('log10', math_format(10^.x))
  ) + 
    xlab('Time (hr)') + ylab(ylabel) + ggtitle(title)+
    theme(
      axis.title = element_text(size=13, face='bold'),
      axis.line = element_line(linetype = "solid", size = 1),
      axis.text = element_text(size=13, face = 'bold', color= "#000000")
    ) + facet_wrap(~sample) #+ geom_smooth(data = temp, method='lm', se = FALSE, size=3, formula = y~x, show.legend = TRUE)

print(g)

#ggsave(g, file='kv600.pdf')

#geom_abline to do linear fit
#temp<-data[which(data$Hr <31),] will pick the data less than 31 hr