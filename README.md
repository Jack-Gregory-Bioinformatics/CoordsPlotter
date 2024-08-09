# CoordsPlotter: an open-source automated ImageJ macro for extraction and plotting of positional coordinates
## Table of contents
* [Introduction](#Introduction)
* [Installation](#Installation)
* [Running locally on your machine](#Running-on-your-local-machine)

## Introduction
Microscopy image analysis is crucial in many biological research areas, but sometimes mistakes can happen, such as forgetting to save postional data on multi-position microscopy imaging. This metadata exists, however, manual analysis can be time-consuming, especially when scalled up to dozens of postions. The aim of CoordsPlotter is to automate this metadata extractiong and plotting. It is designed to streamline the process, accurately extract coordinate postions, and ensure that existing data can be used rather than needed to repeat lengthy microscopy set-up and experiments.
The ImageJ macro (CoordsPlotter.ijm) automatically extracts the positional coordinates for each .vsi image in a folder, saves these coordinates as a .csv file, and plots these coordinates to show spatial distribution from the original slide/plate. The macro will output 2 files:
* image_coordinates.csv file (contains all identified coordinates, each row = new .vsi image).
* Coordinates_Plot.jpeg image (scales and plots the coordinates with labels to show positiioning on the slide/plate).

To use the macro on your local machine download all files from the Local_Scripts folder or run the following code:
```
$ wget -O https://github.com/Jack-Gregory-Bioinformatics/CoordsPlotter.git
```
The macro has been written for the Olymppus IX83 microscope, feel free to edit it for your own microscope brand/model.

## Running on your local machine
To run this pipeline on your local machine, run the ImageJ macro (CryptoClassifier.ijm) using ImageJ by selecting:
```
Toolbar -> Plugins -> Macros -> Run -> (select the 'CoordsPlotter.ijm' macro from where you saved it)
```
* A file browser will pop-up, prompting you for an input directory (the folder containing your microscopy images), select the input directory from your machines files.

The macro will now be run on all '.vsi' files in the input directory. The outputs will be saved to the same folder.

## Running remotely on Mycoserv
This script can also be run remotely on Mycoserv. This can be done by downloading the script to Mycoserv and running it as above.
