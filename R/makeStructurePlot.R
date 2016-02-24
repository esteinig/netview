
#### Structure Plot ####

# DUPLICATED FACTOR LEVELS FIX

# Adaptation for NetView R, with source code written by:
# Ramasamy RK, Ramasamy S, Bindroo BB, Naik VG. 
# STRUCTURE PLOT: a program for drawing elegant STRUCTURE bar plots in user friendly interface. 
# Springerplus. 2014 Aug 13;3:431. doi: 10.1186/2193-1801-3-431. eCollection 2014.
# http://btismysore.in/strplot/index.php

makeStructurePlot <- function(qDF, metaData, colours, options) {
  
  qDF <- cbind("id" = metaData[[options[["nodeID"]]]], qDF)
  qDF <- cbind("group" = metaData[[options[["nodeGroup"]]]], qDF)
  dat1 <- qDF
  
  #################Roundoff#########
  K=ncol(dat1)-2
  dat1$sum<-rowSums(dat1[, -c(1:2)])
  dif<-1-dat1$sum
  dif<-as.data.frame(dif)
  dat1$sum<-NULL
  d<-apply(dat1[-c(1:2)] , 1 , which.max)
  d1<-as.data.frame(d)
  n=1
  for(i in 1:nrow(dat1)){
    dat1[n, (d1[n,]+2)]<-dat1[n, (d1[n,]+2)]+dif[n,]
    n=n+1
  }
  ### sorting data######
  dat_Sor<-dat1
  final<-NULL
  y=ncol(dat_Sor)
  n=3  
  repeat{	
    dat_Sor<-dat_Sor[order(-dat_Sor[,n]), ]				
    if(dat_Sor[1, n]<0.5) break 					
    dat6 <- subset(dat_Sor, dat_Sor[n]>=0.5)			
    dat_Sor<-dat_Sor[!dat_Sor[n]>=0.5, ]				
    final<-rbind(final,dat6)					
    if(n==y)break
    n=n+1
  }
  final<-rbind(final,dat_Sor)
  dat_Sor<-NULL 
  dat_Sor<-final
  row.names(dat_Sor)<-NULL
  
  ##### Melting data ##########
  dat1<-melt(dat1)
  colnames(dat1)<-c("GROUP", "id", "variable", "value")
  suppressWarnings(dat1$id <- factor(dat1$id, levels=dat1$id))
  suppressWarnings(dat1<-dat1[with(dat1, order(value)), ])
  dat_Sor<-melt(dat_Sor)
  #######
  colnames(dat_Sor) <- c("GROUP", "id", "variable", "value")
  suppressWarnings(dat_Sor$id <- factor(dat_Sor$id, levels=dat_Sor$id))
  suppressWarnings(dat_Sor<-dat_Sor[with(dat_Sor, order(value)), ])
  ########
  panel<-theme(panel.background = element_rect(fill = "transparent",colour = NA), panel.grid.minor = element_blank(), panel.grid.major = element_blank(),
               plot.background = element_rect(fill = "transparent",colour = NA))
  yaxis<-theme(axis.text.y = element_text(colour="black",size=0.5))
  xaxis<-theme(axis.ticks.x=element_blank(), axis.title.x=element_blank(), axis.text.x=element_blank(), legend.position="none")
  xxaxis<-theme(axis.ticks.x=element_blank(),axis.text.x = element_text(colour="black", angle=0, hjust=0), legend.position="none")
  
  pal <- colours
  bar_colour <- 'black'
  
  gb<-tapply(as.numeric(dat1$id), dat1$GROUP, 
             function(x) levels(dat1$id[])[floor(median(x))])
  p<-ggplot(data=dat1, aes(x=id, y=value, fill=variable))+ geom_bar(stat="identity", width=1, colour=bar_colour)+  scale_y_continuous(expand = c(0,0))+ 
    scale_fill_manual(values = pal)
  q<-p+ panel + xlab("")+ylab("") + yaxis+ xxaxis+
    scale_x_discrete(breaks=gb, labels=names(gb)) 
  
  return(q)
}
