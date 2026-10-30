classificationValidation <- function(
  genMarker, itsRegion, memAllocation,
  classifierSource, externalPath,
  fungalITSReference
) {
  validMarker <- TRUE
  validITSRegion <- TRUE
  validMemAllocation <- TRUE
  validClassifierSource <- TRUE
  validExternalPath <- TRUE
  validFungalITSReference <- TRUE
  markers <- c(
    "16S (built-in available)" = "16S",
    "16S_vertebrate (external classifier required)" = "16S_vertebrate",
    "18S_eukaryota (external classifier required)" = "18S_eukaryota",
    "18S_diatom (external classifier required)" = "18S_diatom",
    "12S_fish (external classifier required)" = "12S_fish",
    "12S_vertebrate (external classifier required)" = "12S_vertebrate",
    "ITS_fungi (built-in available)" = "ITS_fungi",
    "28S_fungi (built-in available)" = "28S_fungi",
    "rbcL_eukaryota (external classifier required)" = "rbcL_eukaryota",
    "rbcL_diatom (external classifier required)" = "rbcL_diatom",
    "rbcL_landPlant (external classifier required)" = "rbcL_landPlant",
    "ITS_plants (external classifier required)" = "ITS_plants",
    "COI (classifier included)" = "COI"
  )
  itsRegions <- c(
    "ITS1",
    "ITS2"
  )
  its <- c(
    "ITS_fungi (built-in available)" = "ITS_fungi",
    "ITS_plants (external classifier required)" = "ITS_plants"
  )
  builtIn <- c(
    "ITS_fungi (built-in available)" = "ITS_fungi",
    "28S_fungi (built-in available)" = "28S_fungi",
    "16S (built-in available)" = "16S"
  )
  fungalITSReferences <- c(
    "fungalits_warcup",
    "fungalits_unite"
  )
  outputLog <- character(0)
  outputLogStatus <- character(0)

  #Ensures there is only 1 input and that it is in the list of possible inputs for markers
  if (length(genMarker) == 1 && genMarker %in% markers) {
    outputLog <- c(outputLog, "Valid Marker Chosen")
    outputLogStatus <- c(outputLogStatus, "SUCCESS")
  } else {
    outputLog <- c(outputLog, "Need to choose a Valid Marker")
    outputLogStatus <- c(outputLogStatus, "ERROR")
    validMarker <- FALSE
  }

  # Ensures that only runs this if the selection is valid and is an ITS marker
  if (validMarker && genMarker %in% its) {
    # Checks that only one input region was given and that selection is valid and is an ITS region
    if (length(itsRegion) == 1 && itsRegion %in% itsRegions) {
      outputLog <- c(outputLog, "Valid ITS region")
      outputLogStatus <- c(outputLogStatus, "SUCCESS")
    } else {
      outputLog <- c(outputLog, "Choose a valid ITS region")
      outputLogStatus <- c(outputLogStatus, "ERROR")
      validITSRegion <- FALSE
    }
  }

  # Ensures that only 1 number is input, that it is a number, that it is not INF or NA
  if (length(memAllocation) != 1 || !is.numeric(memAllocation) || !is.finite(memAllocation)) {
    outputLog <- c(outputLog, "Memory Allocation is required and needs a valid number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
    validMemAllocation <- FALSE
    #Ensures that allocated memory is not negative
  } else if (memAllocation <= 0) {
    outputLog <- c(outputLog, "Memory Allocation must be greater than 0")
    outputLogStatus <- c(outputLogStatus, "ERROR")
    validMemAllocation <- FALSE
    #Ensures allocated memory is a whole number
  } else if (memAllocation %% 1 != 0) {
    outputLog <- c(outputLog, "Memory Allocation must be a whole number")
    outputLogStatus <- c(outputLogStatus, "ERROR")
    validMemAllocation <- FALSE
  } else {
    outputLog <- c(outputLog, "Memory Allocation is valid")
    outputLogStatus <- c(outputLogStatus, "SUCCESS")
  }

  #Ensures that marker is valid
  if (validMarker) {
    # Ensures there is only one selection for the source and that it is an existing option
    if (length(classifierSource) != 1 ||
      !classifierSource %in% c("included", "builtin", "external")) {
      outputLog <- c(outputLog, "Choose a valid classifier source")
      outputLogStatus <- c(outputLogStatus, "ERROR")
      validClassifierSource <- FALSE
      # Branch for in COI classifier shipped with interface
    } else if (classifierSource == "included") {
      # Ensures that the Marker is COI
      if (genMarker == "COI") {
        outputLog <- c(outputLog, "Included COI classifier selected")
        outputLogStatus <- c(outputLogStatus, "SUCCESS")
      } else {
        outputLog <- c(outputLog, "Included COI classifier requires the COI marker")
        outputLogStatus <- c(outputLogStatus, "ERROR")
        validClassifierSource <- FALSE
      }
      # Branchfor using classifiers shipped with Metaworks
    } else if (classifierSource == "builtin") {
      # Ensures selected marker has a builtin classifier
      if (!genMarker %in% builtIn) {
        outputLog <- c(outputLog, "No built-in classifier for this marker")
        outputLogStatus <- c(outputLogStatus, "ERROR")
        validClassifierSource <- FALSE
        # If the marker has built in classifier and is the ITS Fungi marker, checks user selection for option
      } else if (genMarker == "ITS_fungi") {
        if (length(fungalITSReference) == 1 &&
          fungalITSReference %in% fungalITSReferences) {
          outputLog <- c(outputLog, "Valid built-in fungal ITS reference")
          outputLogStatus <- c(outputLogStatus, "SUCCESS")
        } else {
          outputLog <- c(outputLog, "Choose Warcup or UNITE 2014")
          outputLogStatus <- c(outputLogStatus, "ERROR")
          validFungalITSReference <- FALSE
        }
        # If is valid and not ITS Fungi, then valid selection
      } else {
        outputLog <- c(outputLog, "Built-in classifier selected")
        outputLogStatus <- c(outputLogStatus, "SUCCESS")
      }
      # Branch for external classifier
    } else if (classifierSource == "external") {
      # Ensures one choice, the path is a string, is not NA, and exists as a file not directory
      if (length(externalPath) != 1 ||
        !is.character(externalPath) ||
        is.na(externalPath) ||
        !nzchar(trimws(externalPath)) ||
        !file.exists(externalPath) ||
        dir.exists(externalPath)) {
        outputLog <- c(outputLog, "Choose an accessible external classifier file")
        outputLogStatus <- c(outputLogStatus, "ERROR")
        validExternalPath <- FALSE
      } else {
        outputLog <- c(outputLog, paste0("External classifier selected: ", externalPath))
        outputLogStatus <- c(outputLogStatus, "SUCCESS")
      }
    }
  }
  #Returns a list of all the settings, and if they were validated 
  #even if not being used, along with an output log and status log
  return(list(
  valid = validMarker && validITSRegion && validMemAllocation &&
    validClassifierSource && validExternalPath &&
    validFungalITSReference,

  genMarker = list(value = genMarker, valid = validMarker),
  itsRegion = list(value = itsRegion, valid = validITSRegion),
  memAllocation = list(value = memAllocation, valid = validMemAllocation),
  classifierSource = list(value = classifierSource, valid = validClassifierSource),
  externalPath = list(value = externalPath, valid = validExternalPath),
  fungalITSReference = list(
    value = fungalITSReference,
    valid = validFungalITSReference
  ),
  outputLog = outputLog,
  outputLogStatus = outputLogStatus
))
}
