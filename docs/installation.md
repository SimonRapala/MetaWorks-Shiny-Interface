# MetaWorks Shiny Installation

## Verified development environment

- Operating system: Linux through WSL
- Conda environment: MetaWorks_v1.13.0
- MetaWorks version: 1.13.0
- Snakemake version: 7.24.2
- R version: 4.5.2
- Java version: OpenJDK 11.0.13
- ORFfinder path: /home/simonr/bin/ORFfinder
- Classifier path: /home/simonr/MetaWorks1.13.0/mydata/rRNAClassifier.properties

## Environment files

- `environment/metaworks-original.yml` contains the original MetaWorks environment specification.
- `environment/metaworks-working.yml` records the currently working Conda environment.

## Additional components

The following components are not fully contained in the Conda environment and must eventually be installed or copied separately:

- MetaWorks Snakefiles and supporting scripts
- ORFfinder
- Trained RDP classifier files
- R and Shiny packages
- Required library-path configuration

## Linux system dependencies

The following Ubuntu packages are required to compile the R package dependencies:

    sudo apt update
    sudo apt install cmake libuv1-dev

- `cmake` provides tools used when compiling certain R packages.
- `libuv1-dev` provides the development headers and library files required by the R package `fs`.
