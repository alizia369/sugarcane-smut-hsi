# data/

Nothing in this folder is tracked by git (see `.gitignore`).

Expected input: raw frames or ENVI files from the two snapshot cameras,
organised by camera and setting (indoor / outdoor / field). Griffith University
lists a related public dataset, *Hyperspectral Image Datasets for Sugarcane
Disease* (research-repository.griffith.edu.au). Check whether it matches
these folders.

The original scripts had absolute paths to the author's machines. These were
replaced with relative placeholders that start with `.\data\...`, so the
simplest set-up is to copy (or symlink) your data here, keeping the same
sub-folder names, and run scripts from the repository root. You can also just
edit the path variables at the top of each script.
