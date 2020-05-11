# sidora.cli

A CLI for terminal based data extraction and summary for the MPI-SHH Department of Archaeogenetics PANDORA Database

## Quickstart

1. Install sidora.cli from github within R 

```
if(!require('remotes')) install.packages('remotes')
remotes::install_github('sidora-tools/sidora.cli')
```

2. Install the script in your user directory with `sidora.cli::quick_install()` within R
3. Make the main script file executable with `chmod +x sidora.R`
4. Provide a `.credentials` file in your user directory
5. Run it with `./sidora.R --help`

This will only work within the MPI-SHH network. It also requires R and most likely a UNIX system.
