#the initialization only requires the outlay amount, the payment amount,
#and the time horizon. The salvage value and text description containing
#the string "Internal Rate of Return (IRR) = _____%" are left blank by default.
IRR <- function(outlay,pmt,scrap=NA,t,words=F){
  #compute discount factor for each time period
  d <- matrix(NA,nrow=t+1,ncol=1)
  #begin initially by 10% increments of the discount rate from 0-100%
  doofus <- matrix(NA,10,ncol=1)
  #to store initial 10% chunks' NPV
  dingus <- list()
  #to store the NPVs of the final discount rate increments (1/1000%)
  dong <- list()
  for (K in 1:101){
    #discount factors from year 0 (investment) to t (termination)
    for (i in 1:(t+1)){
      d[i] <- 1/(1+(K-1)/100)^(i-1)
    } 
    #capital investment at year 0 and salvage payback at year t
    CISV <- as.matrix(c(c(-outlay,rep(0,t-1)),ifelse(is.na(scrap),0,scrap)))
    #cash flow payments for all years but 0
    AVG <- as.matrix(c(c(0,rep(pmt,t))))
    #net present value = sum of net cash flows discounted by year
    NPV <- sum((CISV+AVG)*d)
    #find where zero
    dingus[[K]] <- NPV
    if(NPV<0) break()
  }
  #this goes from the discrete 10% chunks down to 0.00001%
  #K-1 is the indexing position where we saw the first NPV<0
  #K-2 is the indexing position where we saw the last NPV>0
  R <- ((K-2)*10^3):((K-1)*10^3)/10^5
  #the final loop goes through the possible values of the discount rate
  #increasing incrementally by one one-thousandth of a percent
  for (boo in 1:length(R)){
    #when "boo" = 1, we are at the last discount rate for which NPV>0
    for (i in 1:(t+1)){
      #compute the discounting factors for each period using that discount rate
      d[i] <- 1/(1+R[boo])^(i-1)
    }
    #capital investment at year 0 and salvage payback at year t
    CISV <- as.matrix(c(c(-outlay,rep(0,t-1)),ifelse(is.na(scrap),0,scrap)))
    #cash flow payments for all years but 0
    AVG <- as.matrix(c(c(0,rep(pmt,t))))
    #net present value = sum of net cash flows discounted by year
    NPV <- sum((CISV+AVG)*d)
    #find where zero
    dong[[boo]] <- NPV
    if(NPV<0) break()  
  }
  #IMPORTANT!!!!!!!!!! You CANNOT just average the last discount rate percentage
  #where NPV>0 and the first discount rate percentage where NPV<0. That would
  #simply pick the midpoint, assuming the loss in value is identical to the
  #gain in value (depending on which way the % changes), i.e., that NPV is
  #symmetric about 0 or that 0 is the midpoint. This is NOT necessarily the
  #case. Hence, interpolating using the proportion of the range in NPV (max-min)
  #will find the closest approximation to the "true" IRR.
  irr.est <- (R[boo-1])+(dong[[boo-1]]/(dong[[boo-1]]-dong[[boo]]))/10^5
  #again, the optional descriptor indicator in the function statement
  return(ifelse(words==T,
                paste0("Internal Rate of Return (IRR) = ",
                       round(100*irr.est,2),"%"),
                round(irr.est,10)))
}
#Example: investment cost is $25,000, the average (or constant) future cash flow
#payments are $1,500 per period, the salvage value is $2,500, and the time
#horizon is 30 years. This will give the IRR in an English printout.
IRR(outlay = 25000,pmt = 1500,scrap = 2500,t = 30,words=T)
#The same investment, but to use the IRR in further calculations, the text
#is eliminated and only a decimal number is returned.
IRR(outlay = 25000,pmt = 1500,scrap = 2500,t = 30)
