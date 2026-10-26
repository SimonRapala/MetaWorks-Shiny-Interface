vsearchValidation <- function(minReadsCluster, threadCount){
  validMinReadCluster <- FALSE
  validThreadCount <- FALSE
  outputLog <- character(0)
  outputLogStatus <- character(0)

  if (length(minReadsCluster) != 1 || !is.numeric(minReadsCluster) || !is.finite(minReadsCluster)){
    outputLog <- c(outputLog, "Minimum Reads per Cluster is required and must be a number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (minReadsCluster %% 1 != 0) {
    outputLog <- c(outputLog, "Minimum Reads per Cluster must be a whole number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (minReadsCluster < 0) {
    outputLog <- c(outputLog, "Minimum Reads per Cluster cannot be negative")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else {
    outputLog <- c(outputLog, paste0("Valid Minimum Reads per Cluster of ", minReadsCluster))
    outputLogStatus <- c(outputLogStatus, "SUCCESS")
    validMinReadCluster <- TRUE
  }


  if (length(threadCount) != 1 || !is.numeric(threadCount) || !is.finite(threadCount)){
    outputLog <- c(outputLog, "Thread Count is required and must be a number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (threadCount %% 1 != 0) {
    outputLog <- c(outputLog, "Thread Count must be a whole number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (threadCount < 0) {
    outputLog <- c(outputLog, "Thread Count cannot be negative")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else {
    outputLog <- c(outputLog, paste0("Valid Thread Count of ", threadCount))
    outputLogStatus <- c(outputLogStatus, "SUCCESS")
    validThreadCount <- TRUE
  }

  return(list(
    minReadsCluster = minReadsCluster,
    threadCount = threadCount,
    outputLog = outputLog,
    outputLogStatus = outputLogStatus,
    valid = (validMinReadCluster && validThreadCount)
  ))
}