#Importing the needed library
library(testthat)
#Where the function is located
source("../R/fileValidation.R")

#A pure positive test to check intended results, PASS
test_that(
  desc = "A complete pair and adapter file are accepted",
  code = {
    #The fake file names being provided
    filenames <- c(
      "sample_R1_001.fastq.gz",
      "sample_R2_001.fastq.gz",
      "adapters.fasta"
    )
    #Where the returned list is stored
    results <- checkFastQFiles(filenames)
    #The retured result and the expected result for FASTQ
    expect_equal(
      object = results$fastqPairs,
      expected = c("sample_R1_001.fastq.gz", "sample_R2_001.fastq.gz")
    )
    #The returned result and expected result for FASTA
    expect_equal(
      object = results$adapterFile,
      expected = "adapters.fasta"
    )
    #Logical check for truthy value
    expect_true(results$complete)
  }
)
#Tests correct FASTQ and a incorrect FASTA file, FAIL
test_that(
  desc = "A complete pair and incorrect adapter file",
  code = {
    filenames <- c(
      "sample_R1_001.fastq.gz",
      "sample_R2_001.fastq.gz",
      "adapters2.fasta"
    )

    results <- checkFastQFiles(filenames)

    expect_equal(
      object = results$fastqPairs,
      expected = c("sample_R1_001.fastq.gz", "sample_R2_001.fastq.gz")
    )
    expect_equal(
      object = results$adapterFile,
      expected = character(0)
    )
    #Logical check for falsy value
    expect_false(results$complete)
  }
)

#Two reads from different samples and corrrect FASTA, FAIL
test_that(
  desc = "A non complete set and correct adapter file are not accepted",
  code = {
    filenames <- c(
      "sample_R1_001.fastq.gz",
      "sample_R2_002.fastq.gz",
      "adapters.fasta"
    )

    results <- checkFastQFiles(filenames)

    expect_equal(
      object = results$fastqPairs,
      expected = character(0)
    )
    expect_equal(
      object = results$adapterFile,
      expected = "adapters.fasta"
    )
    expect_false(results$complete)
  }
)

#Both an incomplete set of pairs and a incorrect FASTA, FAIL
test_that(
  desc = "A incomplete pair and incorrect adapter file are not accepted",
  code = {
    filenames <- c(
      "sample_R1_001.fastq.gz",
      "sample_R2_002.fastq.gz",
      "adapters2.fasta"
    )

    results <- checkFastQFiles(filenames)

    expect_equal(
      object = results$fastqPairs,
      expected = character(0)
    )
    expect_equal(
      object = results$adapterFile,
      expected = character(0)
    )
    expect_false(results$complete)
  }
)
#No FASTQ files with a correct FASTA, FAIL
test_that(
  desc = "Only a correct adapter file, are not accepted",
  code = {
    filenames <- c(
      "adapters.fasta"
    )

    results <- checkFastQFiles(filenames)

    expect_equal(
      object = results$fastqPairs,
      expected = character(0)
    )
    expect_equal(
      object = results$adapterFile,
      expected = "adapters.fasta"
    )
    expect_false(results$complete)
  }
)
#A pair of reads with no FASTA, FAIL
test_that(
  desc = "Only a complete pair no adapter, not accepted",
  code = {
    filenames <- c(
      "sample_R1_001.fastq.gz",
      "sample_R2_001.fastq.gz"
    )

    results <- checkFastQFiles(filenames)

    expect_equal(
      object = results$fastqPairs,
      expected = c(
        "sample_R1_001.fastq.gz",
        "sample_R2_001.fastq.gz"
      )
    )
    expect_equal(
      object = results$adapterFile,
      expected = character(0)
    )
    expect_false(results$complete)
  }
)

#A stress test for many complete pairs with valid FASTA, PASS
test_that(
  desc = "Lots of complete pairs and an adapter file are accepted",
  code = {
    filenames <- c(
      "sample_R1_001.fastq.gz",
      "sample_R2_001.fastq.gz",
      "sample_R1_002.fastq.gz",
      "sample_R2_002.fastq.gz",
      "sample_R1_003.fastq.gz",
      "sample_R2_003.fastq.gz",
      "sample_R1_004.fastq.gz",
      "sample_R2_004.fastq.gz",
      "sample_R1_005.fastq.gz",
      "sample_R2_005.fastq.gz",
      "sample_R1_006.fastq.gz",
      "sample_R2_006.fastq.gz",
      "sample_R1_100.fastq.gz",
      "sample_R2_100.fastq.gz",
      "adapters.fasta"
    )

    results <- checkFastQFiles(filenames)

    expect_equal(
      object = results$fastqPairs,
      expected = c(
        "sample_R1_001.fastq.gz",
        "sample_R1_002.fastq.gz",
        "sample_R1_003.fastq.gz",
        "sample_R1_004.fastq.gz",
        "sample_R1_005.fastq.gz",
        "sample_R1_006.fastq.gz",
        "sample_R1_100.fastq.gz",
        "sample_R2_001.fastq.gz",
        "sample_R2_002.fastq.gz",
        "sample_R2_003.fastq.gz",
        "sample_R2_004.fastq.gz",
        "sample_R2_005.fastq.gz",
        "sample_R2_006.fastq.gz",
        "sample_R2_100.fastq.gz"
      )
    )
    expect_equal(
      object = results$adapterFile,
      expected = "adapters.fasta"
    )
    expect_true(results$complete)
  }
)


#All pairs are complete except one with a valid FASTA, FAIL
test_that(
  desc = "Lots of complete pairs 1 incomplete 
  and an adapter file, not accepted",
  code = {
    filenames <- c(
      "sample_R1_001.fastq.gz",
      "sample_R2_001.fastq.gz",
      "sample_R1_002.fastq.gz",
      "sample_R2_002.fastq.gz",
      "sample_R1_003.fastq.gz",
      "sample_R2_003.fastq.gz",
      "sample_R1_004.fastq.gz",
      "sample_R2_004.fastq.gz",
      "sample_R1_005.fastq.gz",
      "sample_R2_005.fastq.gz",
      "sample_R1_006.fastq.gz",
      "sample_R2_006.fastq.gz",
      "sample_R1_100.fastq.gz",
      "adapters.fasta"
    )

    results <- checkFastQFiles(filenames)

    expect_equal(
      object = results$fastqPairs,
      expected = c(
        "sample_R1_001.fastq.gz",
        "sample_R1_002.fastq.gz",
        "sample_R1_003.fastq.gz",
        "sample_R1_004.fastq.gz",
        "sample_R1_005.fastq.gz",
        "sample_R1_006.fastq.gz",
        "sample_R2_001.fastq.gz",
        "sample_R2_002.fastq.gz",
        "sample_R2_003.fastq.gz",
        "sample_R2_004.fastq.gz",
        "sample_R2_005.fastq.gz",
        "sample_R2_006.fastq.gz"
      )
    )
    expect_equal(
      object = results$adapterFile,
      expected = "adapters.fasta"
    )
    expect_false(results$complete)
  }
)
