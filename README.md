# SParking
האקתון

This project intends to create the infrastructure for "smart parking spaces". In those spaces, people can park only if they reserve the parking lot, and are dirceted by the system into the parking spot.
This allowes people to get rid of the need to travel around the city, looking for an empty spot. Instead, they simply declare thier need in a parking spot, and the system will guide them to an empty spot.


database:
the database is in form of SQL, and containes the different parking areas across the country. each parking area containes address, num of parking locations, num of taken parking locations

server:
the server communicates with the clients (the drivers) and takes data from them in order to find them a good parking location (close to their destination).
it takes in consideration the distances between the cars and the destinations, the posibility of cars to join the app when they are close to the destination (and not as early as it could), the car current location (when searching a parking location looks also on the current location and not only on the destination).

client:
the client (driver) communicates with the server in order to find a good parking location (close to their destination), by asking the server to activate its functions.



Statistics:
In this part we built tools, using R programming languages, for collecting data of average occupation rates for different parking spots.
This subsystem relies on 3 R functions:
- ADD_PARKING_LOCATION.R:(ID,lon,lat,n)
    Is runned through Rscript, with input arguments: ID of parking spot, longitudinal axis location, and latitudinal axis location. and last - the number of parking spots in the location.
    The new parking location is then marked in the datasets in the "statistics" subFolder.
- UPDATE(): 
    Is runned through Rscript.exe as well. Input Arguments: id,num_locs_empty,time. Every time there is a change in the occupation in a reserved parking lot, an "UPDATE" command is sent, and the datasets are updated.
- get_Data(n,lon,lat,time)
    *n = the number of pepole who want to get parking in some place to get the radius
    *lon = long cordinate of detination place
    *lat = latitude cordinate of destination place
    *time = arrive time
    the function output the best radius of starting of saving parking, the ids of the parking in this radius.

