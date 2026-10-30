cutadaptValidation <- function(
  minRetainedSequence, endQuality5,
  endQuality3, maxPrimerError, minPrimerOverlap, maxAmbiguousBases,
  reverseComplementSearch
) {
  validMinRetainedSequence <- FALSE
  validEndQuality5 <- FALSE
  validEndQuality3 <- FALSE
  validMaxPrimerError <- FALSE
  validMinPrimerOverlap <- FALSE
  validMaxAmbiguousBases <- FALSE
  validReverseComplementSearch <- FALSE
  outputLog <- character(0)
  outputLogStatus <- character(0)

  if (length(minRetainedSequence) != 1 || !is.numeric(minRetainedSequence) || !is.finite(minRetainedSequence)) {
    outputLog <- c(outputLog, "Minimum Retained Sequence is required and must be a number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (minRetainedSequence %% 1 != 0) {
    outputLog <- c(outputLog, "Minimum Retained Sequence must be a whole number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (minRetainedSequence < 0) {
    outputLog <- c(outputLog, "Minimum Retained Sequence cannot be negative")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else {
    outputLog <- c(outputLog, paste0("Valid Minimum Retained Sequence of ", minRetainedSequence))
    outputLogStatus <- c(outputLogStatus, "SUCCESS")
    validMinRetainedSequence <- TRUE
  }

  if (length(endQuality5) != 1 || !is.numeric(endQuality5) || !is.finite(endQuality5)) {
    outputLog <- c(outputLog, "End Quality Prime 5 is required and must be a number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (endQuality5 %% 1 != 0) {
    outputLog <- c(outputLog, "End Quality Prime 5 must be a whole number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (endQuality5 < 0) {
    outputLog <- c(outputLog, "End Quality Prime 5 cannot be negative")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else {
    outputLog <- c(outputLog, paste0("Valid End Quality Prime 5 of ", endQuality5))
    outputLogStatus <- c(outputLogStatus, "SUCCESS")
    validEndQuality5 <- TRUE
  }

  if (length(endQuality3) != 1 || !is.numeric(endQuality3) || !is.finite(endQuality3)) {
    outputLog <- c(outputLog, "End Quality Prime 3 is required and must be a number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (endQuality3 %% 1 != 0) {
    outputLog <- c(outputLog, "End Quality Prime 3 must be a whole number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (endQuality3 < 0) {
    outputLog <- c(outputLog, "End Quality Prime 3 cannot be negative")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else {
    outputLog <- c(outputLog, paste0("Valid End Quality Prime 3 of ", endQuality3))
    outputLogStatus <- c(outputLogStatus, "SUCCESS")
    validEndQuality3 <- TRUE
  }

  if (length(maxPrimerError) != 1 || !is.numeric(maxPrimerError) || !is.finite(maxPrimerError)) {
    outputLog <- c(outputLog, "Max Primer Error is required and must be a number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (maxPrimerError >= 0 && maxPrimerError < 1) {
    outputLog <- c(outputLog, paste0("Valid Max Primer Error of ", maxPrimerError))
    outputLogStatus <- c(outputLogStatus, "SUCCESS")
    validMaxPrimerError <- TRUE
  } else {
    outputLog <- c(outputLog, "Max Primer Error must be at least 0 and less than 1")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  }

  if (length(minPrimerOverlap) != 1 || !is.numeric(minPrimerOverlap) || !is.finite(minPrimerOverlap)) {
    outputLog <- c(outputLog, "Minimum Primer Overlap is required and must be a number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (minPrimerOverlap %% 1 != 0) {
    outputLog <- c(outputLog, "Minimum Primer Overlap must be a whole number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (minPrimerOverlap < 0) {
    outputLog <- c(outputLog, "Minimum Primer Overlap cannot be negative")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else {
    outputLog <- c(outputLog, paste0("Valid Minimum Primer Overlap of ", minPrimerOverlap))
    outputLogStatus <- c(outputLogStatus, "SUCCESS")
    validMinPrimerOverlap <- TRUE
  }

  if (length(maxAmbiguousBases) != 1 || !is.numeric(maxAmbiguousBases) || !is.finite(maxAmbiguousBases)) {
    outputLog <- c(outputLog, "Maximum Ambiguous Bases is required and must be a number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (maxAmbiguousBases %% 1 != 0) {
    outputLog <- c(outputLog, "Maximum Ambiguous Bases must be a whole number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (maxAmbiguousBases < 0) {
    outputLog <- c(outputLog, "Maximum Ambiguous Bases cannot be negative")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else {
    outputLog <- c(outputLog, paste0("Valid Maximum Ambiguous Bases of ", maxAmbiguousBases))
    outputLogStatus <- c(outputLogStatus, "SUCCESS")
    validMaxAmbiguousBases <- TRUE
  }

  if (identical(reverseComplementSearch, TRUE)){
    outputLog <- c(outputLog, "Reverse Complement Search is enabled")
    outputLogStatus <- c(outputLogStatus, "SUCCESS")
    validReverseComplementSearch <- TRUE
  } else if (identical(reverseComplementSearch, FALSE)){
    outputLog <- c(outputLog, "Reverse Complement Search is disabled")
    outputLogStatus <- c(outputLogStatus, "SUCCESS")
    validReverseComplementSearch <- TRUE
  } else {
    outputLog <- c(outputLog, "Reverse Complement Search needs to be a valid logical choice")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  }

  return(list(
  minRetainedSequence = list(
    value = minRetainedSequence, valid = validMinRetainedSequence
  ),
  endQuality5 = list(value = endQuality5, valid = validEndQuality5),
  endQuality3 = list(value = endQuality3, valid = validEndQuality3),
  maxPrimerError = list(value = maxPrimerError, valid = validMaxPrimerError),
  minPrimerOverlap = list(value = minPrimerOverlap, valid = validMinPrimerOverlap),
  maxAmbiguousBases = list(value = maxAmbiguousBases, valid = validMaxAmbiguousBases),
  reverseComplementSearch = list(
    value = reverseComplementSearch, valid = validReverseComplementSearch
  ),

  outputLog = outputLog,
  outputLogStatus = outputLogStatus,
  valid = validMinRetainedSequence &&
    validEndQuality5 &&
    validEndQuality3 &&
    validMaxPrimerError &&
    validMinPrimerOverlap &&
    validMaxAmbiguousBases &&
    validReverseComplementSearch
))
}
