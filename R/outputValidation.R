outputValidation <- function(
  reportType
) {
  validReportType <- TRUE
  reportTypes <- c(
    "1", "2"
  )
  outputLog <- character(0)
  outputLogStatus <- character(0)

  if (length(reportType) != 1 || !is.character(reportType) || !reportType %in% reportTypes) {
    outputLog <- c(outputLog, "Need to select a valid choice")
    outputLogStatus <- c(outputLogStatus, "ERROR")
    validReportType <- FALSE
  } else {
    outputLog <- c(outputLog, "Valid Choice Selection")
    outputLogStatus <- c(outputLogStatus, "SUCCESS")
  }

  return(list(
    reportType = reportType,
    valid = (validReportType),
    outputLog = outputLog,
    outputLogStatus = outputLogStatus
  ))
}