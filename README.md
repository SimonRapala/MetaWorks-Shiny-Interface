# MetaWorks Shiny Interface

This is an interface written in R Shiny to help users navigate, configure, learn and launch MetaWorks v1.13 workflows for DNA metabarcoding.

## Project Status

The project is in early development. The initial project structure and interface design have been established.
R package dependencies are recorded using renv, and Conda environment files are included to support reproducible local setup.

The application does not yet launch complete MetaWorks workflows.

## Goals

Intended Function:

- Accept paired fastq files along with an adapter fasta file
- Validate file names, types, pairings and sizes to be compatible with MetaWorks
- Generate the MetaWorks config file based off of the users selected settings
- Launch MetaWorks and provide all validated files using the command line interface
- Monitor process data, status and logs 
- Preserve all input names, configurations, outputs and metadata
- Provide access to completed run results

## Architecture

- R Shiny provides the interface that users will interact with to validate files and settings
- MetaWorks 1.13 will perform the bioinfomatic processing
- The Conda environment manages the dependencies of the MetaWorks process
- renv manages the R and R Shiny dependencies
- Docker will eventually provide a reproducible runtime environment for the complete application
- SQLite may be used to store run data and metadata, not concrete
