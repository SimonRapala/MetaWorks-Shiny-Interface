seqprepValidation <- function(
  phredScore, minReadOverlap, maxMismatchFraction,
  minMatchingOverlapFraction
) {
  outputLog <- character(0)
  outputLogStatus <- character(0)
  validPhred <- FALSE
  validMinOverlap <- FALSE
  validMaxMismatch <- FALSE
  validMatchingOverlap <- FALSE

  if (length(phredScore) != 1 || !is.numeric(phredScore) ||
    !is.finite(phredScore)) {
    outputLog <- c(outputLog, "Phred Score is required and must be a number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (phredScore %% 1 != 0) {
    outputLog <- c(outputLog, "Phred Score must be a whole number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (phredScore >= 0 && phredScore <= 40) {
    outputLog <- c(outputLog, paste0("Valid Phred Score of ", phredScore))
    outputLogStatus <- c(outputLogStatus, "SUCCESS")
    validPhred <- TRUE
  } else {
    outputLog <- c(
      outputLog,
      paste0("Phred Score of ", phredScore, " is out of range")
    )
    outputLogStatus <- c(outputLogStatus, "ERROR")
  }

  if (length(minReadOverlap) != 1 || !is.numeric(minReadOverlap) ||
    !is.finite(minReadOverlap)) {
    outputLog <- c(
      outputLog,
      "Minimum Read Overlap is required and must be a number"
    )
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (minReadOverlap %% 1 != 0) {
    outputLog <- c(outputLog, "Minimum Read Overlap must be a whole number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (minReadOverlap >= 10 && minReadOverlap <= 100) {
    outputLog <- c(
      outputLog,
      paste0("Valid Minimum Read Overlap of ", minReadOverlap)
    )
    outputLogStatus <- c(outputLogStatus, "SUCCESS")
    validMinOverlap <- TRUE
  } else {
    outputLog <- c(
      outputLog,
      paste0("Minimum Read Overlap of ", minReadOverlap, " is out of range")
    )
    outputLogStatus <- c(outputLogStatus, "ERROR")
  }

  if (length(maxMismatchFraction) != 1 ||
    !is.numeric(maxMismatchFraction) ||
    !is.finite(maxMismatchFraction)) {
    outputLog <- c(
      outputLog,
      "Max Mismatch Fraction is required and must be a number"
    )
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (maxMismatchFraction >= 0 && maxMismatchFraction <= 0.2) {
    outputLog <- c(
      outputLog,
      paste0("Valid Max Mismatch Fraction of ", maxMismatchFraction)
    )
    outputLogStatus <- c(outputLogStatus, "SUCCESS")
    validMaxMismatch <- TRUE
  } else {
    outputLog <- c(
      outputLog,
      paste0(
        "Max Mismatch Fraction of ",
        maxMismatchFraction,
        " is out of range"
      )
    )
    outputLogStatus <- c(outputLogStatus, "ERROR")
  }

  if (length(minMatchingOverlapFraction) != 1 ||
    !is.numeric(minMatchingOverlapFraction) ||
    !is.finite(minMatchingOverlapFraction)) {
    outputLog <- c(
      outputLog,
      "Minimum Matching-Overlap Fraction is required and must be a number"
    )
    outputLogStatus <- c(outputLogStatus, "ERROR")
  } else if (
    minMatchingOverlapFraction >= 0.7 &&
      minMatchingOverlapFraction <= 1.0
  ) {
    outputLog <- c(
      outputLog,
      paste0(
        "Valid Minimum Matching-Overlap Fraction of ",
        minMatchingOverlapFraction
      )
    )
    outputLogStatus <- c(outputLogStatus, "SUCCESS")
    validMatchingOverlap <- TRUE
  } else {
    outputLog <- c(
      outputLog,
      paste0(
        "Minimum Matching-Overlap Fraction of ",
        minMatchingOverlapFraction,
        " is out of range"
      )
    )
    outputLogStatus <- c(outputLogStatus, "ERROR")
  }

  return(list(
    phredScore = phredScore,
    minReadOverlap = minReadOverlap,
    maxMismatchFraction = maxMismatchFraction,
    minMatchingOverlapFraction = minMatchingOverlapFraction,
    outputLog = outputLog,
    outputLogStatus = outputLogStatus,
    valid = (
      validPhred && validMinOverlap &&
        validMaxMismatch && validMatchingOverlap
    )
  ))
}
