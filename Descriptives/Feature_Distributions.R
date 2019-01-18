library(fitdistrplus)
library(ggplot2)
library(dplyr)
library(tidyr)


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
                     "Notification Response Sess (med)",
                     "Notification Response Sess (std)",
                     "Notification Response App (med)",
                     "Notification Response App (std)",
                     "Repeat App Sessions",
                     "Repeat WhatsApp Sessions",
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
                     "Top Train WhatsApp - FB App",
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
####################################

#binwidth = function(x) ((max(x)-min(x))/1000)  
#limits = quantile(, c(0,.985))

for (i in 1:ncol(data)){
  i <- 8
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

############# Multi, Single, Repeat

subset <- data[,c(2,7,8,9)]
subset$userid <- rownames(subset)

subgather <- gather(subset, key = feature, value = value, -userid, factor_key = T)
subout <- data.frame()

for (i in levels(subgather$feature)){
  #i <- "Repeat WhatsApp Sessions"
  temp1 <- subgather[subgather$feature == i,]
  outlier <- boxplot.stats(temp1$value)$stats[5]
  temp2 <- filter(subgather, feature == i & value <= outlier)
  subout <- rbind(subout, temp2)
}

set1 <- filter(subout, feature %in% c("Multi App Sessions","Single App Sessions"))
set2 <- filter(subout, feature %in% c("Repeat App Sessions","Repeat WhatsApp Sessions"))
set2$feature <- factor(set2$feature,levels=c("Single App Sessions","Repeat WhatsApp Sessions"))
subout$feature <- factor(subout$feature,
                         levels=c("Multi App Sessions","Single App Sessions",
                                  "Repeat App Sessions","Repeat WhatsApp Sessions"))


ggplot(subout, aes(x = value )) +
  geom_histogram(binwidth = .002, position = "identity", fill = "blue") + # , position = "stack" "identity"
  labs(y="Number of Users",x="% of Sessions" , title = "Distribution of Features"
       )+
  theme_bw()+
  theme(axis.text = element_text(size=10),  
        axis.title = element_text(size=12))+
  theme(plot.title = element_text(hjust = 0.5), legend.position="none")+
  facet_wrap(.~feature, nrow = 2, scales = "free_y")


############# Notficatons

subsetn <- select(data, contains("Notif") )
subsetn$userid <- rownames(subsetn)

subgathern <- gather(subsetn, key = feature, value = value, -userid, factor_key = T)

suboutn <- data.frame()

for (i in levels(subgathern$feature)){
  #i <- "Repeat WhatsApp Sessions"
  temp1 <- subgathern[subgathern$feature == i,]
  outlier <- boxplot.stats(temp1$value)$stats[5]
  temp2 <- filter(subgathern, feature == i & value <= outlier)
  suboutn <- rbind(suboutn, temp2)
}

set1 <- filter(suboutn, feature %in% c("Notification Response Sess (med)","Notification Response App (med)"))
set2 <- filter(suboutn, feature %in% c("Notification Response Sess (std)","Notification Response App (std)"))

set2$feature <- factor(set2$feature,levels=c("Single App Sessions","Repeat WhatsApp Sessions"))

((max(subout$value)-min(subout$value))/1000)



ggplot(set1, aes(x = value )) +
  geom_histogram(binwidth = 20, fill = "blue") + # , position = "stack" "identity"
  labs(y="Number of Users",x="Response Time (in secs)" #, title = "Distribution of Notification Features"
  )+
  theme_bw()+
  theme(axis.text = element_text(size=10),  
        axis.title = element_text(size=12),
        strip.text.x = element_text(size = 12))+
  theme(plot.title = element_text(hjust = 0.5), legend.position="none")+
  facet_wrap(.~feature, nrow = 2, scales = "free_y")



############# Top Response Time

subset <- select(data, matches("Top [0-9] Response Time") )
subset$userid <- rownames(subset)

subgather <- gather(subset, key = feature, value = value, -userid, factor_key = T)

subout <- data.frame()

for (i in levels(subgather$feature)){
  #i <- "Repeat WhatsApp Sessions"
  temp1 <- subgather[subgather$feature == i,]
  outlier <- boxplot.stats(temp1$value)$stats[5]
  temp2 <- filter(subgather, feature == i & value <= outlier)
  subout <- rbind(subout, temp2)
}

subout$feature <- factor(subout$feature,
                         levels=c(
                           "Top 1 Response Time Session",
                           "Top 1 Response Time App",
                           "Top 2 Response Time Session" , 
                           "Top 2 Response Time App",
                           "Top 3 Response Time Session",
                           "Top 3 Response Time App"
                         ))

set1 <- filter(subout, feature %in% c())
set2 <- filter(subout, feature %in% c())

set2$feature <- factor(set2$feature,levels=c("Single App Sessions","Repeat WhatsApp Sessions"))

((max(set2$value)-min(set2$value))/1000)


ggplot(subout, aes(x = value )) +
  geom_histogram(binwidth = 1.5, fill = "blue") + # , position = "stack" "identity"
  labs(y="Number of Users",x="Response Time (in secs)" , title = "Distribution of Top Response Apps Features"
  )+
  theme_bw()+
  theme(axis.text = element_text(size=10),  
        axis.title = element_text(size=12),
        strip.text.x = element_text(size = 12))+
  theme(plot.title = element_text(hjust = 0.5), legend.position="none")+
  facet_wrap(.~feature, ncol = 2, scales = "free_y")




############# Top Trains: Specific

subset <- select(data, 
                 "Top Train WhatsApp - FB App", 
                 "Top Train FB Messenger - FB App",
                 "Top Train Contacts - Call" )

subset$userid <- rownames(subset)

subgather <- gather(subset, key = feature, value = value, -userid, factor_key = T)

subout <- data.frame()

for (i in levels(subgather$feature)){
  #i <- "Repeat WhatsApp Sessions"
  temp1 <- subgather[subgather$feature == i,]
  outlier <- boxplot.stats(temp1$value)$stats[5]
  temp2 <- filter(subgather, feature == i & value <= outlier)
  subout <- rbind(subout, temp2)
}

set_0 <- filter(subout, value > 0)
((max(set_0$value)-min(set_0$value))/1000)

ggplot(set_0, aes(x = value )) +
  geom_histogram(binwidth = .005, fill = "blue") + # , position = "stack" "identity"
  labs(y="Number of Users",x="% of Sessions" , title = "Distribution of Top Overall Trains"
  )+
  theme_bw()+
  theme(axis.text = element_text(size=10),  
        axis.title = element_text(size=12),
        strip.text.x = element_text(size = 12))+
  theme(plot.title = element_text(hjust = 0.5), legend.position="none")+
  facet_wrap(.~feature) #, nrow = 1) #, scales = "free_y")


##################### Top Individual Trains

subset <- select(data, matches("Top [0-9] Individ Train") )
subset$userid <- rownames(subset)

subgather <- gather(subset, key = feature, value = value, -userid, factor_key = T)

subout <- data.frame()

for (i in levels(subgather$feature)){
  #i <- "Repeat WhatsApp Sessions"
  temp1 <- subgather[subgather$feature == i,]
  outlier <- boxplot.stats(temp1$value)$stats[5]
  temp2 <- filter(subgather, feature == i & value <= outlier)
  subout <- rbind(subout, temp2)
}

subout$feature <- factor(subout$feature,
                         levels=c(
                           "Top 1 Response Time Session",
                           "Top 1 Response Time App",
                           "Top 2 Response Time Session" , 
                           "Top 2 Response Time App",
                           "Top 3 Response Time Session",
                           "Top 3 Response Time App"
                         ))

((max(subgather$value)-min(subout$value))/1000)


ggplot(subout, aes(x = value )) +
  geom_histogram(binwidth = .001, fill = "blue") + # , position = "stack" "identity"
  labs(y="Number of Users",x="% of Sessions" , title = "Distribution of Top Individ Trains"
  )+
  theme_bw()+
  theme(axis.text = element_text(size=10),  
        axis.title = element_text(size=12),
        strip.text.x = element_text(size = 12))+
  theme(plot.title = element_text(hjust = 0.5), legend.position="none")+
  facet_wrap(.~feature) #, ncol = 2, scales = "free_y")


