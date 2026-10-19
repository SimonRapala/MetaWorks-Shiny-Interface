checkFastQFiles <- function(filenames) {
  adapterFilePresent <- FALSE
  fastqFilesMissing <- FALSE
  log <- character(0)
  adapterFile <- character(0)

  fastqReadBool <- grepl("\\.fastq\\.gz$", filenames)
  fastqFiles <- filenames[fastqReadBool]
  if (length(fastqFiles) == 0) {
    fastqFilesMissing <- TRUE
    log <- c(log, "No FASTQ files supplied")
  }

  # Everything to do with fasta verification and error messageing is here
  adapterReadBool <- grepl("adapters\\.fasta$", filenames)
  if (any(adapterReadBool)) {
    adapterFile <- filenames[adapterReadBool]
    adapterFilePresent <- TRUE
    log <- c(log, paste0("Fasta file ", adapterFile, " is present"))
  } else {
    log <- c(log, "Missing fasta file")
  }

  # Gets all R1 and R2 boolean reads respectively
  fwdReadBool <- grepl("_R1_", fastqFiles)
  revReadBool <- grepl("_R2_", fastqFiles)

  if (any(!(fwdReadBool | revReadBool))) {
    fastqFilesMissing <- TRUE
    log <- c(log, "Some FASTQ filenames lack an _R1_ or _R2_ identifier")
  }
  # Gets actual R1 and R2 reads
  fwdRead <- fastqFiles[fwdReadBool]
  revRead <- fastqFiles[revReadBool]
  # Gets the expected reading pairs
  expectedRevRead <- sub("_R1_", "_R2_", fwdRead)
  expectedFwdRead <- sub("_R2_", "_R1_", revRead)
  # Checks if those pairs exist in other read
  hasRevPair <- expectedRevRead %in% revRead
  hasFwdPair <- expectedFwdRead %in% fwdRead
  # Find the missing reads in each
  missingR2 <- expectedRevRead[!hasRevPair]
  missingR1 <- expectedFwdRead[!hasFwdPair]

  missingPairs <- c(missingR1, missingR2)

  if (length(missingPairs) > 0) {
    fastqFilesMissing <- TRUE
    for (pair in missingPairs) {
      log <- c(log, paste0("Missing file: ", pair))
    }
  }

  combinedPairs <- c(fwdRead[hasRevPair], expectedRevRead[hasRevPair])
  if (!fastqFilesMissing) {
  for (i in seq_along(fwdRead)) {
    log <- c(
      log,
      paste0(fwdRead[i], " is paired with ", expectedRevRead[i])
    )
  }
}

  return(list(
    fastqPairs = combinedPairs,
    adapterFile = adapterFile,
    outputLog = log,
    complete = (adapterFilePresent && !fastqFilesMissing)
  ))
}
