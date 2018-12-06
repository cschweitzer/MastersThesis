

##all functions and file names are the same
## all have params, input file name, output file name, with defaults set
## ALL files read in RDS file and write out RDS and CSV.
## DO NOT append .csv to file name, functions do that for you



###########################Features


source("trains_topoverall_freq_features.R")

trains_topoverall_feat <- trains_topoverall_freq_features("../../Outputs/PreProcessing/sessions_trains",
                                    "../../Outputs/Features/trains_topoverall_freq_features")


source("trains_topperuser_freq_features.R")

trains_topperuser_freq_features <- trains_topperuser_freq_features(input="../../Outputs/PreProcessing/sessions_trains",
                                            output_feat="../../Outputs/Features/trains_topperuser_freq_features",
                                            output_desc="../../Outputs/Descriptives/trains_topperuser")
  
  
source("multi_app_sessions.R")

multi_feat <- multi_app_sessions(input="../../Outputs/PreProcessing/sessions_trains",
                                 output="../../Outputs/Features/multi_app_sessions")

source("single_app_sessions.R")

single_feat <- single_app_sessions(input="../../Outputs/PreProcessing/sessions_trains",
                                 output="../../Outputs/Features/single_app_sessions")


source("repeat_app_sessions.R")

repeat_feat <- repeat_app_sessions(input="../../Outputs/PreProcessing/sessions_trains",
                    output="../../Outputs/Features/repeat_app_sessions")


source("repeat_app_whatsapp.R") 
repeat_whatsapp <- repeat_app_whatsapp(input="../../Outputs/PreProcessing/apps_position",
                    output="../../Outputs/Features/repeat_app_whatsapp")


source("between_sessions_duration.R")
between_sess <- between_sessions_duration(input="../../Outputs/PreProcessing/sessions",
                          output="../../Outputs/Features/between_sessions_duration")

