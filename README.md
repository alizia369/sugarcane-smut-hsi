# Early Detection of Sugarcane Smut Disease in Hyperspectral Images

**Dong Bao, Jun Zhou, Shamsul Arafin Bhuiyan, Ali Zia, Rebecca Ford, Yongsheng Gao**
*36th International Conference on Image and Vision Computing New Zealand (IVCNZ), Tauranga, 2021*

[![Paper](https://img.shields.io/badge/Paper-IVCNZ%202021-blue)](https://doi.org/10.1109/IVCNZ54163.2021.9653386) ![Language](https://img.shields.io/badge/Language-MATLAB-orange) [![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

> **Status.** This is the original research code behind the publication,
> prepared for release. Duplicate, backup and autosave files, data and personal
> file paths were removed and third-party code was separated into
> `third_party/`; the algorithms themselves were not modified. It is research
> code rather than a polished toolbox, and it was developed on Windows MATLAB.

## Overview

Sugarcane smut is a fungal disease that can cause heavy yield losses, and its
early stages are not visible to the naked eye. By the time whips appear, the
infection is well established. Hyperspectral imaging records reflectance well
beyond the visible range and can reveal physiological changes before visible
symptoms develop.

This repository contains the MATLAB tools used in the study to turn snapshot
hyperspectral captures of sugarcane plants into analysis-ready data. They
cover cube extraction and normalisation, background removal, spectral
similarity analysis, patch-dataset construction, and a ResNet-18 baseline
classifier.

## Method

1. **Cube extraction and normalisation.** Raw mosaic frames from two snapshot
   cameras (a visible-range camera and a near-infrared camera) are converted
   into reflectance cubes using camera-specific correction matrices
   (`saveMatandNormalise_blackCam.m`, `saveMatandNormalise_pinkCam.m`,
   `utils/X2Cube*.m`).
2. **Background removal.** Plant pixels are separated from the background
   (`RemoveBackground.m`).
3. **Spectral similarity analysis.** Local neighbourhoods are compared with the
   spectral angle mapper and spectral information divergence
   (`neighbourhoodSAM*.m`, `neighbourhoodSID.m`). The resulting maps are
   analysed for infected and healthy plants (`AnalysisandResults*_BlackCam.m`,
   `findBrightestPixels*.m`).
4. **Learning.** Labelled patches are extracted (`CreatePatches.m`,
   `im2patches.m`), and a ResNet-18 classifier is trained and tested on them
   (`src/machine_learning/`).

## Repository structure

```
setup_paths.m                    add all code folders to the MATLAB path
src/
  saveMatandNormalise_*.m        raw frames -> normalised cubes
  RemoveBackground.m             plant / background separation
  neighbourhoodSAM*.m, neighbourhoodSID.m   spectral similarity maps
  AnalysisandResults*_BlackCam.m analysis of the similarity maps
  CreatePatches.m, im2patches.m  patch dataset construction
  machine_learning/              ResNet-18 definition, training, visualisation
  utils/                         label renaming helper
utils/                           camera-specific cube loaders and correction matrices
third_party/                     ENVI header reader
data/                            place your data here (not tracked)
```

## Requirements

- MATLAB R2021a or newer (developed on Windows)
- Image Processing Toolbox; Statistics and Machine Learning Toolbox
- Deep Learning Toolbox (for `src/machine_learning/`)

## Getting started

```matlab
>> cd sugarcane-smut-hsi
>> setup_paths
```

1. Convert and normalise raw captures with `saveMatandNormalise_blackCam.m`
   or `saveMatandNormalise_pinkCam.m`, after setting the folders at the top.
2. Run `RemoveBackground.m`, then `AnalysisandResults_BlackCam.m` (or
   `AnalysisandResults2_BlackCam.m`) for the spectral similarity analysis.
3. Run `CreatePatches.m` to build the training, validation and test patch
   files, then `src/machine_learning/trainResnet18.m`.

## Data

The captures used in the paper are not distributed with this repository.
Griffith University lists a related public dataset, *Hyperspectral Image
Datasets for Sugarcane Disease*, in its research repository; check whether it
matches the folder layout described in `data/README.md`.

## Notes on reproducibility

- The paper's proposed classifier, a CNN with a dual self-attention block, is
  **not** part of this repository. The code here covers the data preparation,
  spectral analysis and the ResNet-18 baseline.
- `TestDataSugarCane.m` is a small script for checking the loaders.

## Citation

If you use this code, please cite:

```bibtex
@inproceedings{bao2021sugarcane,
  title     = {Early Detection of Sugarcane Smut Disease in Hyperspectral Images},
  author    = {Bao, Dong and Zhou, Jun and Bhuiyan, Shamsul Arafin and Zia, Ali and Ford, Rebecca and Gao, Yongsheng},
  booktitle = {36th International Conference on Image and Vision Computing New Zealand (IVCNZ)},
  year      = {2021},
  doi       = {10.1109/IVCNZ54163.2021.9653386}
}
```

A `CITATION.cff` file is included, so GitHub's **Cite this repository** button gives the same reference.

## Licence and third-party code

Released under the **MIT licence** (see `LICENSE`). `third_party/read_envihdr`
(Jarek Tuszynski) keeps its own terms.

## Acknowledgements

See the paper for acknowledgements of funding and data collection.

## Contact

Questions and bug reports are welcome through [GitHub issues](https://github.com/alizia369/sugarcane-smut-hsi/issues).
Ali Zia, La Trobe University — [www.ali-zia.me](https://www.ali-zia.me)

## Related repositories

This repository is one of a set released together from the same line of work on hyperspectral computer vision:

- [`hsi-3d-reconstruction`](https://github.com/alizia369/hsi-3d-reconstruction): 3D reconstruction from hyperspectral images (WACV 2015)
- [`hsi-relative-depth-estimation`](https://github.com/alizia369/hsi-relative-depth-estimation): Relative depth from a hyperspectral cube (DICTA 2015)
- [`hsi-chromatic-defocus-depth`](https://github.com/alizia369/hsi-chromatic-defocus-depth): Chromatic aberration + defocus for relative depth (IEEE TIP 2021)
- [`hsi-occluded-object-detection`](https://github.com/alizia369/hsi-occluded-object-detection): Occluded object detection (PhD thesis, arXiv forthcoming)
- [`hsi-material-boundary-detection`](https://github.com/alizia369/hsi-material-boundary-detection): Material-based boundary detection (DICTA 2017)
- [`hsi-matlab-utils`](https://github.com/alizia369/hsi-matlab-utils): Shared hyperspectral I/O and normalisation helpers
