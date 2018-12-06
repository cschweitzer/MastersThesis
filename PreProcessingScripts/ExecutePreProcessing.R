

##all functions and file names are the same
## all have params, input file name, output file name, with defaults set
## ALL files read in RDS file and write out RDS and CSV.
## DO NOT append .csv to file name, functions do that for you


#source("clean_appdata.R")

#appdata <- clean_appdata("../../Outputs/PreProcessing/core_appevents_stripped",
#                         "../../Outputs/PreProcessing/clean_data")

#source("apps_position.R")

#apps_position <- apps_position("../../Outputs/PreProcessing/clean_data",
#                              "../../Outputs/PreProcessing/apps_position")

source("notification_new_column.R")
data_newnotif <- notification_new_column(appdata="../../Outputs/PreProcessing/apps_position",
                                         notifications = "../../Outputs/PreProcessing/newnotifcol.csv",
                                         output="../../Outputs/PreProcessing/apps_position_newnotif")

source("sessions_data.R")

sessions <- sessions_data("../../Outputs/PreProcessing/apps_position_newnotif",
                          "../../Outputs/PreProcessing/sessions")

source("trains_agg.R")
##takes 2 input files

sessions_trains <- trains_agg(input_apps="../../Outputs/PreProcessing/apps_position_newnotif",
                              input_sessions="../../Outputs/PreProcessing/sessions",
                              output="../../Outputs/PreProcessing/sessions_trains")
