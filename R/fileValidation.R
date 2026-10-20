checkFastQFiles <- function(filenames) {
  #Flags used for flow control for log recording
  adapterFilePresent <- FALSE
  fastqFilesMissing <- FALSE
  log <- character(0)
  adapterFile <- character(0)

  #Logical vector with locations of FASTQ files
  fastqReadBool <- grepl("\\.fastq\\.gz$", filenames)
  #Extracts only the FASTQ files
  fastqFiles <- filenames[fastqReadBool]
  #If there are no FASTQ files, track it
  if (length(fastqFiles) == 0) {
    fastqFilesMissing <- TRUE
    log <- c(log, "No FASTQ files supplied")
  }

  #Logical vector with location of FASTA file
  adapterReadBool <- grepl("adapters\\.fasta$", filenames)
  #Checks if a FASTA file exists
  if (any(adapterReadBool)) {
    #Extracts the FASTA file, only one enforced by Shiny
    adapterFile <- filenames[adapterReadBool]
    #Flag tracks if there is a FASTA
    adapterFilePresent <- TRUE
    #Tracks the name and adds it to the log
    log <- c(log, paste0("Fasta file ", adapterFile, " is present"))
  } else {
    #Tracks in the log if it is missing
    log <- c(log, "Missing fasta file")
  }

  # Gets all R1 and R2 boolean reads respectively
  fwdReadBool <- grepl("_R1_", fastqFiles)
  revReadBool <- grepl("_R2_", fastqFiles)

  #Checks the FASTQ files to ensure none are missing a R! or R2 idetifier
  if (any(!(fwdReadBool | revReadBool))) {
    fastqFilesMissing <- TRUE
    log <- c(log, "Some FASTQ filenames lack an _R1_ or _R2_ identifier")
  }
  #Extracts the actual R1 and R2 reads
  fwdRead <- fastqFiles[fwdReadBool]
  revRead <- fastqFiles[revReadBool]
  #Gets the expected reading pairs that match each existing read
  expectedRevRead <- sub("_R1_", "_R2_", fwdRead)
  expectedFwdRead <- sub("_R2_", "_R1_", revRead)
  #Checks if expected reads exist in other extracted read
  #Returns the left value as a truthy/falsy vector
  hasRevPair <- expectedRevRead %in% revRead
  hasFwdPair <- expectedFwdRead %in% fwdRead
  # Find the missing reads in each
  #If the value is missing from extracted read it is missing
  missingR2 <- expectedRevRead[!hasRevPair]
  missingR1 <- expectedFwdRead[!hasFwdPair]

  #All of the reads that are missing a pair read
  missingPairs <- c(missingR1, missingR2)

  #If there is missing pairs run this
  if (length(missingPairs) > 0) {
    #Flag tracks incomplete pairs
    fastqFilesMissing <- TRUE
    #Goes through each read that is missing a pairing and add it to the log
    for (pair in missingPairs) {
      log <- c(log, paste0("Missing file: ", pair))
    }
  }
  #Combines the existing reads that have pairs
  combinedPairs <- c(fwdRead[hasRevPair], expectedRevRead[hasRevPair])
  #If there are no missing files runs this loop
  if (!fastqFilesMissing) {
  #Adds to the log the paired files and their names
  for (i in seq_along(fwdRead)) {
    log <- c(
      log,
      paste0(fwdRead[i], " is paired with ", expectedRevRead[i])
    )
  }
}
  #Returns a list that has the paired files,
  #the adapter file. the tracked log for printing
  #and a final flag that controls if the files are valid
  return(list(
    fastqPairs = combinedPairs,
    adapterFile = adapterFile,
    outputLog = log,
    complete = (adapterFilePresent && !fastqFilesMissing)
  ))
}
