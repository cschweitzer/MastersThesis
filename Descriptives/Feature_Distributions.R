library(fitdistrplus)
library(ggplot2)

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
  facet_wrap(~variable,scales='free')+
  coord_cartesian(xlim = c(-5,50),
                  ylim=c(0,3400))