pseudogeneValidation <- function(
  enableFiltering, filteringType,
  primaryFilter, secondaryFilter,
  removalMethod, hmmProfile,
  geneticCode, codonBehaviour,
  minORFLength, ignoreNestedORF,
  orfStrand
) {
  validEnableFiltering <- length(enableFiltering) == 1 &&
    is.logical(enableFiltering) &&
    !is.na(enableFiltering)
  validFilteringType <- TRUE
  validPrimaryFilter <- TRUE
  validSecondaryFilter <- TRUE
  validRemovalMethod <- TRUE
  validHMMProfile <- TRUE
  validGeneticCode <- TRUE
  validCodonBehaviour <- TRUE
  validMinORFLength <- TRUE
  validIgnoreNestedORF <- TRUE
  validORFStrand <- TRUE
  filteringTypes <- c(
    "1", "2"
  )
  removalMethods <- c(
    "1", "2"
  )
  geneticCodes <- c(
    "1", "2", "5"
  )
  codonBehaviours <- c(
    "0", "1", "2"
  )
  orfStrands <- c(
    "plus", "minus", "both"
  )
  outputLog <- character(0)
  outputLogStatus <- character(0)


  if (validEnableFiltering && enableFiltering) {
    if (length(filteringType) != 1 || !filteringType %in% filteringTypes || !is.character(filteringType)) {
      outputLog <- c(outputLog, "Filtering Type Needs to be a valid choice")
      outputLogStatus <- c(outputLogStatus, "ERROR")
      validFilteringType <- FALSE
    } else {
      if (identical(filteringType, "1") && nzchar(primaryFilter)) {
        outputLog <- c(outputLog, paste0("Valid simple primary filtering for ", primaryFilter))
        outputLogStatus <- c(outputLogStatus, "SUCCESS")
      } else if (identical(filteringType, "2") && nzchar(primaryFilter) && nzchar(secondaryFilter)) {
        outputLog <- c(outputLog, paste0("Valid simple primary filtering for ", primaryFilter))
        outputLogStatus <- c(outputLogStatus, "SUCCESS")
        outputLog <- c(outputLog, paste0("Valid simple secondary filtering for ", secondaryFilter))
        outputLogStatus <- c(outputLogStatus, "SUCCESS")
      } else { # this need to be fix with a list that I can compare to
        outputLog <- c(outputLog, "Issue with one of the filters")
        outputLogStatus <- c(outputLogStatus, "ERROR")
        validPrimaryFilter <- FALSE
        validSecondaryFilter <- FALSE
      }
    }

    if (length(removalMethod) != 1 || !removalMethod %in% removalMethods ||
      !is.character(removalMethod) || is.null(removalMethod) || is.na(removalMethod)) {
      outputLog <- c(outputLog, "Pseudogene Removal Method must be a valid option")
      outputLogStatus <- c(outputLogStatus, "ERROR")
      validRemovalMethod <- FALSE
    } else {
      if (identical(removalMethod, "2")) {
        if (identical(hmmProfile, "bold.hmm") && !is.null(hmmProfile) && !is.na(hmmProfile) && is.character(hmmProfile)) {
          outputLog <- c(outputLog, "HMM Profile is chosen as the removal method")
          outputLogStatus <- c(outputLogStatus, "SUCCESS")
        } else {
          outputLog <- c(outputLog, "The chosen HMM Profile is not valid")
          outputLogStatus <- c(outputLogStatus, "ERROR")
          validHMMProfile <- FALSE
        }
      }
      if (identical(removalMethod, "1")) {
        outputLog <- c(outputLog, "ORF Finder is chosen as the removal method")
        outputLogStatus <- c(outputLogStatus, "SUCCESS")
      }
    }

    if (length(geneticCode) != 1 || !geneticCode %in% geneticCodes || !is.character(geneticCode)) {
      outputLog <- c(outputLog, "The Genetic Code choice needs to be a valid option")
      outputLogStatus <- c(outputLogStatus, "ERROR")
      validGeneticCode <- FALSE
    } else {
      outputLog <- c(outputLog, "Valid Genetic Code choice")
      outputLogStatus <- c(outputLogStatus, "SUCCESS")
    }

    if (length(codonBehaviour) != 1 || !codonBehaviour %in% codonBehaviours || !is.character(codonBehaviour)) {
      outputLog <- c(outputLog, "The Codon Behaviour choice needs to be a valid option")
      outputLogStatus <- c(outputLogStatus, "ERROR")
      validCodonBehaviour <- FALSE
    } else {
      outputLog <- c(outputLog, "Valid Codon Behaviour choice")
      outputLogStatus <- c(outputLogStatus, "SUCCESS")
    }

    if (length(minORFLength) != 1 || !is.numeric(minORFLength) || !is.finite(minORFLength)) {
      outputLog <- c(outputLog, "The Minimum ORF Length needs to be a valid whole number")
      outputLogStatus <- c(outputLogStatus, "ERROR")
      validCodonBehaviour <- FALSE
    } else if (minORFLength < 30 || minORFLength > 1000) {
      outputLog <- c(outputLog, "The Minimum ORF Length cannot be outside of allowed range")
      outputLogStatus <- c(outputLogStatus, "ERROR")
      validMinORFLength <- FALSE
    } else {
      outputLog <- c(outputLog, "Minimum ORF Length is a valid number within the range")
      outputLogStatus <- c(outputLogStatus, "SUCCESS")
    }

    if (length(ignoreNestedORF) != 1 || !is.logical(ignoreNestedORF) || !is.na(ignoreNestedORF)) {
      outputLog <- c(outputLog, "Ignore Nested ORF needs to have a valid logical choice")
      outputLogStatus <- c(outputLogStatus, "ERROR")
      validIgnoreNestedORF <- FALSE
    } else {
      outputLog <- c(outputLog, "Ignore Nested ORF has a valid state")
      outputLogStatus <- c(outputLogStatus, "SUCCESS")
    }
    orfStrand <- tolower(orfStrand)
    if (length(orfStrand) != 1 || !orfStrand %in% orfStrands || !is.character(orfStrand)) {
      outputLog <- c(outputLog, "ORF Strand needs to be a valid choice")
      outputLogStatus <- c(outputLogStatus, "ERROR")
      validORFStrand <- FALSE
    } else {
      outputLog <- c(outputLog, "ORF Strand selection is valid")
      outputLogStatus <- c(outputLogStatus, "SUCCESS")
    }
  } else if (validEnableFiltering && !enableFiltering) {
    outputLog <- c(outputLog, "Pseudogene Filtering is disabled")
    outputLogStatus <- c(outputLogStatus, "SUCCESS")
  } else {
    outputLog <- c(outputLog, "Pseudogene Filtering does not have a valid input")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  }

  return(list(
    enableFiltering = enableFiltering,
    filteringType = filteringType,
    primaryFilter = primaryFilter,
    secondaryFilter = secondaryFilter,
    removalMethod = removalMethod,
    hmmProfile = hmmProfile,
    geneticCode = geneticCode,
    codonBehaviour = codonBehaviour,
    minORFLength = minORFLength,
    ignoreNestedORF = ignoreNestedORF,
    orfStrand = orfStrand,
    valid = (
      validEnableFiltering &&
        validFilteringType &&
        validPrimaryFilter &&
        validSecondaryFilter &&
        validRemovalMethod &&
        validHMMProfile &&
        validGeneticCode &&
        validCodonBehaviour &&
        validMinORFLength &&
        validIgnoreNestedORF &&
        validORFStrand),
    outputLog = outputLog,
    outputLogStatus = outputLogStatus
  ))
}
