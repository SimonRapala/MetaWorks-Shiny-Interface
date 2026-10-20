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
    expect_false(results$complete)
  }
)


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



test_that(
  desc = "Lots of complete pairs 1 incomplete and an adapter file, not accepted",
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
