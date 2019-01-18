library(ggplot2)
library(dplyr)
library(tidyr)

outlier_info <- read.csv("../../Outputs/Descriptives/outlier_info.csv", 
                         row.names = 1, sep = ",")

outlier_info$features <-c( "Btwn Session Dur",
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

colnames(outlier_info) <- c("Num Outliers", "% Outliers", 
                            "Low","Avg of Low Outliers",
                            "High","Avg of High Outliers",
                            "Features")

outlier_info$`Feature Type` <- c("Response Time",
                       "Proportion",
                       "Response Time","Response Time","Response Time","Response Time",
                       "Proportion","Proportion","Proportion",
                       "Response Time","Response Time","Response Time" , "Response Time","Response Time" ,  "Response Time",
                       "Proportion","Proportion","Proportion", "Proportion","Proportion","Proportion","Proportion","Proportion","Proportion","Proportion","Proportion","Proportion","Proportion","Proportion","Proportion")

outlier_formatted <- outlier_info %>% arrange(-`Num Outliers`) %>% 
  gather("Outlier Type", value,Low, High)


ggplot(outlier_formatted, aes(x = reorder(Features, `Num Outliers`), y = value, fill = `Outlier Type`))+
  geom_bar(stat = 'identity',  position = "stack" ) +
  coord_flip()+
  labs(title = "Outliers per Feature: High vs Low Valued",
       y="Number of Outliers",fill="Outlier Type",x="Features")+
  theme_bw()+
  theme(axis.text = element_text(size=10),  
        axis.title = element_text(size=12),
        legend.text = element_text(size = 10),
        legend.title = element_text( size = 10),
        strip.text.x = element_text(size = 10))+
  theme(plot.title = element_text(hjust = 0.5), legend.position="bottom")+
  facet_wrap(~`Feature Type`, nrow = 2, drop = T, scales = "free_y",
             strip.position = "left")
