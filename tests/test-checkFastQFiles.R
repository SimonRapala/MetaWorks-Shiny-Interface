library(testthat)
source("../R/fileValidation.R")

test_that(
  desc = "A complete pair and adapter file are accepted",
  code = {
    filenames <- c(
      "sample_R1_001.fastq.gz",
      "sample_R2_001.fastq.gz",
      "adapters.fasta"
    )

    results <- checkFastQFiles(filenames)

    expect_equal(
      object = results$fastqPairs,
      expected = c("sample_R1_001.fastq.gz", "sample_R2_001.fastq.gz")
    )
    expect_equal(
      object = results$adapterFile,
      expected = "adapters.fasta"
    )
    expect_true(results$complete)
  }
)
