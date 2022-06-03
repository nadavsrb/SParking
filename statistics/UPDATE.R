#Rscript_directory <- dirname(rstudioapi::getSourceEditorContext()$path)
#setwd(Rscript_directory)
#UPDATE

#inputs
args = commandArgs(trailingOnly=TRUE)
id<-as.numeric(args[1])
num_locs_empty<-as.numeric(args[2])
time<-args[3]

#reading the dataframes
db_info<-read.csv("id_info.csv",header=TRUE)
db_last_value<-read.csv("last_update_value.csv",header=TRUE)
db_last_time<-read.csv("Last_Time_Update.csv",header = TRUE)
db_Avg<-read.csv("Avg.csv",header=TRUE)
db_total_time<-read.csv("total_time_in_Avg.csv",header = TRUE)



id_correct<-paste("X",as.character(id),sep="")

#calculating times
original_time<-db_last_time[db_last_time$id==id,"time"]
original_hour<-as.integer(substr(original_time,1,unlist(gregexpr(':', original_time))[1]-1))
original_minute<-as.integer(substr(original_time,unlist(gregexpr(':', original_time))[1]+1,nchar(original_time)))

current_time<-time
current_hour<-as.integer(substr(current_time,1,unlist(gregexpr(':', current_time))[1]-1))
current_minute<-as.integer(substr(current_time,unlist(gregexpr(':', current_time))[1]+1,nchar(current_time)))

#handeling NA
if(is.na(original_time)) {
  db_last_time[db_last_time$id==id,"time"]<-current_time
  db_last_value[db_last_value$id==id,"last_value"]<-num_locs_empty
  write.csv(db_last_time,"Last_Time_Update.csv",row.names = FALSE)
  write.csv(db_last_value,"last_update_value.csv",row.names = FALSE)
  stop("first_update_in_location")
}



#needed?
time_in_Avg<-db_total_time[db_total_time$id==id,"time"]
#?

#updating Avg, with last value included into the average


if(current_hour!=original_hour) {
  #first hour
  db_Avg[db_Avg$time==original_hour,id_correct]<-
    weighted.mean(c(db_Avg[db_Avg$time==original_hour,id_correct],db_last_value[db_last_value$id==id,"last_value"]),
                  c(db_total_time[db_total_time$time==original_hour,id_correct],(60-original_minute)/60))
    #adding time
  db_total_time[db_total_time$time==original_hour,id_correct]<-
    db_total_time[db_total_time$time==original_hour,id_correct]+(60-original_minute)/60
  #hours between
  if(current_hour-original_hour>2) {
  for (i in (original_hour+1):(current_hour-1)) {
#    db_Avg[db_Avg$time==i,id_correct]<-
#      (db_Avg[db_Avg$time==i,id_correct]*db_total_time[db_total_time$time==i,id_correct]+
#         db_last_value[db_last_value$id==id,"last_value"]*1)/(
#           db_total_time[db_total_time$time==i,id_correct]+(current_minute-original_minute)/60)
    db_Avg[db_Avg$time==i,id_correct]<-
      weighted.mean(c(db_Avg[db_Avg$time==i,id_correct],db_last_value[db_last_value$id==id,"last_value"]),
                    c(db_total_time[db_total_time$time==i,id_correct],1))
    
    #adding time
    db_total_time[db_total_time$time==i,id_correct]<-
      db_total_time[db_total_time$time==i,id_correct]+1
    
  }}
  db_Avg[db_Avg$time==current_hour,id_correct]<-
    weighted.mean(c(db_Avg[db_Avg$time==current_hour,id_correct],db_last_value[db_last_value$id==id,"last_value"]),
                  c(db_total_time[db_total_time$time==current_hour,id_correct],current_minute/60))
  
  #adding time
  db_total_time[db_total_time$time==current_hour,id_correct]<-
    db_total_time[db_total_time$time==current_hour,id_correct]+current_minute/60
  
  
}


  
#handling minutes differences
if(current_hour==original_hour) {
  db_Avg[db_Avg$time==current_hour,id_correct]<-
    weighted.mean(c(db_Avg[db_Avg$time==current_hour,id_correct],db_last_value[db_last_value$id==id,"last_value"]),
                  c(db_total_time[db_total_time$time==current_hour,id_correct],(current_minute-original_minute)/60))
  #adding time
  db_total_time[db_total_time$time==current_hour,id_correct]<-
    db_total_time[db_total_time$time==current_hour,id_correct]+(current_minute-original_minute)/60
  
}



#updating: last value to current value, last time to current time
db_last_value[db_last_value$id==id,"last_value"]<-num_locs_empty
db_last_time[db_last_time$id==id,"time"]<-time


write.csv(db_info,"id_info.csv",row.names = FALSE)
write.csv(db_Avg,"Avg.csv",row.names = FALSE)
write.csv(db_last_time,"Last_Time_Update.csv",row.names = FALSE)
write.csv(db_last_value,"last_update_value.csv",row.names = FALSE)
write.csv(db_total_time,"total_time_in_Avg.csv",row.names = FALSE)

