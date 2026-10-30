reviewValidation <- function(
  seqprep, cutadapt, vsearch,
  classification, pseudogene, output
) {
  errorMessage <- " has a problem and must be fixed"

  remove <- c(
    "valid", "outputLog", "outputLogStatus"
  )

  sections <- list(
    seqprep = seqprep,
    cutadapt = cutadapt,
    vsearch = vsearch,
    classification = classification,
    pseudogene = pseudogene,
    output = output
  )

  allLogs <- list()

  for (sectionName in names(sections)) {
    section <- sections[[sectionName]]
    fieldNames <- setdiff(names(section), remove)
    sectionLog <- character(0)

    for (fieldName in fieldNames) {
      field <- section[[fieldName]]

      if (identical(field$valid, TRUE)) {
        sectionLog <- c(
          sectionLog,
          paste0(fieldName, ": ", field$value)
        )
      } else {
        sectionLog <- c(
          sectionLog,
          paste0(fieldName, errorMessage)
        )
      }
    }

    logName <- paste0(sectionName, "Log")
    allLogs[[logName]] <- sectionLog
  }

  return(allLogs)
}