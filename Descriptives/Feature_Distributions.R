library(fitdistrplus)
library(ggplot2)
library(dplyr)

data <-read.csv("../../Outputs/Features/cluster_inputs/features_cont_std.csv", row.names = 1,
                    header = T)
plot(data[,1])


descdist(x = data[,1], discrete = F)


colnames(data) <- c( "Btwn Session Dur",
                     "Multi App Sessions",
                     "Notif Response Sess (med)",
                     "Notif Response Sess (std)",
                     "Notif Response App (med)",
                     "Notif Response App (std)",
                     "Repeat App Sessions",
                     "Repeat Whatsapp Sessions",
                     "Single App Sessions",
                     "Top 1 Response Time App",
                     "Top 2 Response Time App",
                     "Top 3 Response Time App" , 
                     "Top 1 Response Time Session",
                     "Top 2 Response Time Session" ,  
                     "Top 3 Response Time Session",
                     "Top Train: FB App - FB Messenger",
                     "Top Train: FB App - Instagram",
                     "Top Train: FB App - WhatsApp",
                     "Top Train: FB Messenger - FB App",
                     "Top Train: FB Messenger - Snapchat",
                     "Top Train: Instagram - FB App",
                     "Top Train: Contacts - Call",
                     "Top Train: WhatsApp - Chrome",
                     "Top Train: WhatsApp - Facebook",
                     "Top Train: WhatsApp - Instagram",
                     "Top 1 Individ Train",
                     "Top 2 Individ Train",
                     "Top 3 Individ Train",
                     "Top 4 Individ Train",
                     "Top 5 Individ Train")
                       

library(reshape2)

data.melt <- melt(data, value.name = "vals")

ggplot(data.melt, aes(x = vals)) +
  geom_histogram() +
  theme_bw()+
  facet_wrap(~variable,scales='free')+
  coord_cartesian(xlim = c(-5,50),
                  ylim=c(0,3400))



###################


data <-read.csv("../../Outputs/Features/cluster_inputs/features_cont.csv", row.names = 1,
                header = T)

colnames(data) <- c( "Btwn Session Dur",
                     "Multi App Sessions",
                     "Notif Response Sess (med)",
                     "Notif Response Sess (std)",
                     "Notif Response App (med)",
                     "Notif Response App (std)",
                     "Repeat App Sessions",
                     "Repeat Whatsapp Sessions",
                     "Single App Sessions",
                     "Top 1 Response Time App",
                     "Top 2 Response Time App",
                     "Top 3 Response Time App" , 
                     "Top 1 Response Time Session",
                     "Top 2 Response Time Session" ,  
                     "Top 3 Response Time Session",
                     "Top Train FB App - FB Messenger",
                     "Top Train FB App - Instagram",
                     "Top Train FB App - WhatsApp",
                     "Top Train FB Messenger - FB App",
                     "Top Train FB Messenger - Snapchat",
                     "Top Train Instagram - FB App",
                     "Top Train Contacts - Call",
                     "Top Train WhatsApp - Chrome",
                     "Top Train WhatsApp - Facebook",
                     "Top Train WhatsApp - Instagram",
                     "Top 1 Individ Train",
                     "Top 2 Individ Train",
                     "Top 3 Individ Train",
                     "Top 4 Individ Train",
                     "Top 5 Individ Train")

feature_type <- c("Duration (in secs)", "% of Sessions",
                       "Response Time (in secs)","Standard Deviation of Response Time (in secs)",
                       "Response Time (in secs)","Standard Deviation of Response Time (in secs)",
                       "% of Sessions","% of Sessions", "% of Sessions",
                       "Response Time (in secs)","Response Time (in secs)","Response Time (in secs)",
                       "Response Time (in secs)","Response Time (in secs)","Response Time (in secs)",
                       "% of Sessions","% of Sessions", "% of Sessions","% of Sessions","% of Sessions", 
                       "% of Sessions","% of Sessions", "% of Sessions","% of Sessions","% of Sessions",
                       "% of Sessions","% of Sessions", "% of Sessions","% of Sessions","% of Sessions",
                       "% of Sessions")
#binwidth = function(x) ((max(x)-min(x))/1000)  
#limits = quantile(, c(0,.985))

for (i in 1:ncol(data)){
  #i <- 8
  feature <- names(data[i])
  outlier <- boxplot.stats(data[,i])$stats[5]
  data2 <- filter(data, !!as.name(feature) < outlier)
  ggplot(data2, aes(x = data2[,i])) +
    geom_histogram(binwidth = function(x) ((max(x)-min(x))/1000), color = "blue") +
    labs(y="Number of Users",x=feature_type[i], title = paste0("Distribution of ",feature))+
    #scale_x_continuous(limits = c(-.0001,outlier))+
    #ylim(0,25)+
    theme_bw()+
    theme(plot.title = element_text(hjust = 0.5), legend.position="none")
    
  
  ggsave(paste0("../../Outputs/Plots/Features/",feature,"_outlier2.png"))
}