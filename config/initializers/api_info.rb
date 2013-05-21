# constants to evaluate time in seconds
SECONDS_PER_MINUTE = 60
SECONDS_PER_DAY = 60*60*24

# list of the info for each api with threshold being the number of calls, and interval being the time in seconds
API_INFO = {
  :facebook => { :threshold => 600, :interval => 10*SECONDS_PER_MINUTE },
  :twitter =>  { :threshold => 180, :interval => 15*SECONDS_PER_MINUTE },
  :youtube =>  { :threshold => 10000, :interval => SECONDS_PER_DAY }
}
