# MetaWorks Shiny Interface

This project is an interface written in R using Shiny to help users navigate, configure, learn, and launch MetaWorks v1.13 workflows for DNA metabarcoding.

## Project Status

The project is in early development. The initial project structure and interface design have been established. R package dependencies are recorded using `renv`, and Conda environment files are included to support reproducible local setup.

The application does not yet launch complete MetaWorks workflows.

## Goals

The intended functions of the application are to:

- Accept paired FASTQ files and an adapter FASTA file
- Validate filenames, file types, read pairings, and file sizes for compatibility with MetaWorks
- Generate a MetaWorks configuration file based on the user's selected settings
- Launch MetaWorks through its command-line interface using the validated files and generated configuration
- Monitor process status, resource usage, and logs
- Preserve input filenames, configurations, outputs, and run metadata
- Provide access to completed run results

## Architecture

- R and Shiny provide the interface users will interact with to validate files and configure settings
- MetaWorks v1.13 performs the bioinformatics processing
- Conda manages the software dependencies required by MetaWorks
- `renv` manages the R package dependencies used by the Shiny application
- Docker will eventually provide a reproducible runtime environment for the complete application
- SQLite is being considered for storing run history and metadata

## Structure

- `app.R` - Main Shiny application entry point
- `R/` - Reusable R and Shiny functions
- `tests/` - Automated test suites that may eventually be run through GitHub Actions
- `www/` - CSS, images, JavaScript, and other browser assets
- `config/` - Example application configurations
- `environment/` - Conda environment specifications
- `docs/` - Installation and development documentation
- `renv.lock` - Recorded R package versions
- `README.md` - Project overview and documentation

## Development Roadmap

- [x] Establish the initial project structure
- [x] Create the initial interface design
- [x] Configure R dependency management with `renv`
- [x] Record the existing MetaWorks Conda environment
- [ ] Build the main Shiny interface
- [ ] Implement file upload and validation
- [ ] Generate MetaWorks configuration files
- [ ] Launch and monitor MetaWorks processes
- [ ] Store run history and metadata
- [ ] Provide access to completed outputs
- [ ] Add automated tests
- [ ] Package the application with Docker
- [ ] Document installation and usage

## Acknowledgements

This project is designed as a user interface for [MetaWorks](https://github.com/terrimporter/MetaWorks), a multi-marker DNA metabarcoding pipeline developed by Teresita M. Porter and Mehrdad Hajibabaei.

MetaWorks should be cited as:

> Porter, T. M., & Hajibabaei, M. (2022). MetaWorks: A flexible, scalable bioinformatic pipeline for high-throughput multi-marker biodiversity assessments. *PLOS ONE, 17*(9), e0274260. https://doi.org/10.1371/journal.pone.0274260

This interface is a separate project and does not alter the underlying MetaWorks source code or workflow.
