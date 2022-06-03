options(warn=-1)
setwd("C:/Users/nadav/Desktop/SParking/SParking/statistics")

#Get available Parking id
require(geosphere,quietly = TRUE)
AVG<-read.csv("Avg.csv")
id_info<-read.csv("id_info.csv")
args<- commandArgs(trailingOnly = TRUE)

#n<-2
#lon<-33
#lat<-34
#time<-"18:20"



n<-as.numeric(args[1])
lon<-as.numeric(args[2])
lat<-as.numeric(args[3])
time<-args[4]

  time<-as.character(time)
  dist_id<-data.frame(dist=rep(0,nrow(id_info)),id=id_info[,1])#vector of dist from some place
  for (i in 1:nrow(id_info)) {
    dist_id[i,1]<-distm(c(lon, lat), c(id_info[i,2], id_info[i,3]), fun = distHaversine)
  }
  dist_id<-na.omit(dist_id)
  dist_id<-dist_id[order(dist_id[,1]),]
  x<-which(AVG[,1]==as.integer(substr(time,1,unlist(regexpr(":",time)-1)[1])))
  max_dist<-dist_id[dist_id[,1]<1500,]
  b<-0
  for (i in 1:nrow(max_dist)) {
    y<-max_dist[i,2]#take minimum ids
    park<-AVG[x,y]
    b=b+park
    d=i
    if (b > n){
      break
    }
  }
  dist_n<-dist_id[1:d,1]#vector of the minimum distances
  max_dist_wo_X<-substr(max_dist[,2],2,length(max_dist[,2]))  
  n_real<-floor(b)
  R<-dist_n[length(dist_n)]
  final<-paste("{r:",R,", parking_ids:[",do.call(paste,as.list(c(max_dist_wo_X[1:d],sep=","))),"], average_avaliable: ",n_real,"}")
  print(final)
