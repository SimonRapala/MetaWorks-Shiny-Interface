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

    if (){
      
    }
  } else if (validEnableFiltering && !enableFiltering) {
    outputLog <- c(outputLog, "Pseudogene Filtering is disabled")
    outputLogStatus <- c(outputLogStatus, "SUCCESS")
  } else {
    outputLog <- c(outputLog, "Pseudogene Filtering does not have a valid input")
    outputLogStatus <- c(outputLogStatus, "ERROR")
  }
}
