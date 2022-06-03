#Rscript_directory <- dirname(rstudioapi::getSourceEditorContext()$path)
#setwd(Rscript_directory)

#ADD_PARKING_LOCATION
setwd("C:\Users\nadav\Desktop\SParking\SParking\statistics")
#inputs
args = commandArgs(trailingOnly=TRUE)
id<-args[1]
long<-args[2]
lat<-args[3]
number_of_spots<-args[4]

#reading the dataframes
db_info<-read.csv("id_info.csv",header=TRUE)
db_last_value<-read.csv("last_update_value.csv",header=TRUE)
db_last_time<-read.csv("Last_Time_Update.csv",header = TRUE)
db_Avg<-read.csv("Avg.csv",header=TRUE)
db_total_time<-read.csv("total_time_in_Avg.csv",header = TRUE)

#checking if parking lot is marked
if(paste("X",id,sep="")%in%(db_info[,1])) stop("id already listed")

#adding into db_info
db_info[nrow(db_info)+1,]<-c(paste("X",id,sep=""),long,lat)

#adding into last_update_value 
db_last_value[nrow(db_last_value)+1,]<-c(id,NA)

#adding into last_time_update
db_last_time[nrow(db_last_time)+1,]<-c(id,NA)

#adding into Avg
db_Avg[,ncol(db_Avg)+1]<-rep(number_of_spots,nrow(db_Avg))
colnames(db_Avg)[ncol(db_Avg)]<-paste("X",id,sep="")

#adding into total time in Avg
db_total_time[,ncol(db_total_time)+1]<-rep(0,nrow(db_total_time))
colnames(db_total_time)[ncol(db_total_time)]<-paste("X",id,sep="")


write.csv(db_info,"id_info.csv",row.names = FALSE)
write.csv(db_Avg,"Avg.csv",row.names = FALSE)
write.csv(db_last_time,"Last_Time_Update.csv",row.names = FALSE)
write.csv(db_last_value,"last_update_value.csv",row.names = FALSE)
write.csv(db_total_time,"total_time_in_Avg.csv",row.names = FALSE)
