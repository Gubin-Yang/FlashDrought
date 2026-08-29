# Eroding Soil-Moisture Buffer Releases Heatwave Flash Droughts

## Overview

This repository contains the MATLAB code and processed data used to reproduce the principal analyses and figures for the manuscript **“Eroding Soil-Moisture Buffer Releases Heatwave Flash Droughts.”** The workflow identifies flash-drought events from standardized soil-moisture indices, classifies their dominant hydroclimatic controls, evaluates historical and projected changes, quantifies exposure, and examines causal links between atmospheric demand, water availability, soil-moisture buffering, and flash-drought occurrence.

`A1_MainFun.m` is the central analysis and plotting script. It integrates historical reanalysis products, CMIP6 simulations, standardized drought indices, precomputed event catalogues, population and land masks, and custom routines in `MyFun/`. Computationally intensive intermediate products are supplied as `.mat` files so that reviewers can inspect the analysis and regenerate manuscript figures without repeating the complete raw-data workflow.

> **Important scope note:** The original hydro-meteorological archive exceeds 560 TB, and complete preprocessing and event detection require substantial computing time. This repository is therefore a simplified, review-oriented release. It primarily presents processed results and reproduces analyses and figures reported in the manuscript.

All code developed for this study, sufficient to reproduce all analyses and figures, is archived in the Science Data Bank ([scienceDB: https://www.scidb.cn/en/s/2QBf2q](https://www.scidb.cn/en/s/2QBf2q)).

## Purpose

This code is released as the source-code record for **“Eroding Soil-Moisture Buffer Releases Heatwave Flash Droughts”** and is intended for peer review. It supports:

- inspection of analysis logic and parameter choices;
- reproduction of principal and supplementary figures from processed data;
- comparison of surface and root-zone soil-moisture estimates;
- evaluation of historical and future flash-drought regimes under SSP scenarios;
- assessment of affected land area and population exposure;
- examination of geographical attribution and information-flow causality.

The repository is not a distribution of the complete raw hydro-meteorological archive and should not be interpreted as a turnkey reconstruction of every preprocessing step from source observations and climate-model output.

## Repository Structure

```text
FlashDrought/
|-- A1_MainFun.m               Main analysis and figure-production script
|-- MyFun/                     Project-specific analysis and plotting functions
|   `-- LKIF/                  Liang-Kleeman information-flow routines
|-- HistReanalysis/            Processed historical reanalysis products
|-- StandardizedIndexSSI/      Standardized soil-moisture indices by dataset/model
|-- StandardizedIndexSDI/      SPI, STI, SEI, and SSI inputs
|-- FlashDroughtEvent/         Precomputed flash-drought event catalogues
|-- ModelMean/                 Multimodel mean hydroclimatic fields
|-- ShapData/                  Population grids and geographic region boundaries
|-- CMIP6Data/                 Placeholder for optional raw/intermediate CMIP6 fields
|-- Mask.mat                   Land and analysis masks
|-- Coordinate.mat             Common latitude-longitude grids
|-- Characteristic.mat         Historical event characteristics
|-- CharacteristicTrends.mat   Projected trends in event characteristics
|-- Dominanted.mat             Dominant-type and scenario-level intermediates
|-- RiskDeep.mat               Surface and root-zone drought-risk fields
|-- Lag-correlation.mat        Lag-correlation results
|-- MeteForcing-Trend.mat      Trends in meteorological forcing and buffer metrics
|-- Causal-Input.mat           Inputs to information-flow analysis
|-- ML-TrainingData.mat        Aggregated machine-learning input data
`-- SSP.svg                    SSP graphic asset
```

The distributed repository contains approximately 33.5 GB of processed `.mat` data. File sizes and memory use can vary after loading because MATLAB arrays are decompressed and expanded in memory.

## Computing Environment

### Software

- **MATLAB R2026a**
- **Mapping Toolbox**, required for geographic rasters, shapefiles, masks, projections, and regional summaries
- **Statistics and Machine Learning Toolbox**, required for percentiles, outlier handling, rank correlations, distributions, and statistical tests
- **Image Processing Toolbox**, recommended for spatial masking, filling, and raster operations used by mapping utilities
- **NetCDF support**, including MATLAB NetCDF interfaces required by the complete preprocessing workflow

Several plotting and statistical utilities, including `cbrewer2`, `trend`, `mann_kendall`, `mask3`, `island`, `cdtarea`, and related mapping functions, may originate from third-party MATLAB packages used in the authors' environment. They are not all included in this review repository. Add compatible implementations to the MATLAB path when executing sections that invoke them.

### Hardware

The simplified repository is designed for a high-memory scientific workstation. Recommended resources are:

| Resource | Simplified review workflow | Complete raw-data workflow |
|---|---:|---:|
| CPU | Multicore workstation | High-core-count workstation or HPC node |
| RAM | At least 96 GB | More than 1 TB for the largest concurrent operations |
| Storage | At least 100 GB of free working space | More than 560 TB for the source archive, plus temporary and derived products |
| Graphics | MATLAB-compatible GPU optional | Optional; most routines are CPU- and memory-bound |

Actual peak memory depends on the section executed, array precision, number of models retained simultaneously, and whether intermediate variables are cleared between analyses. Running the script section by section is strongly recommended.

## Analysis Workflow

`A1_MainFun.m` is organized as an analysis notebook rather than a single production pipeline. Major stages are:

1. **Flash-drought detection.** Standardized soil-moisture indices are converted into event catalogues for root-zone and surface layers. Computationally intensive detection blocks are commented because corresponding products are already available in `FlashDroughtEvent/`.
2. **Historical characterization.** Event frequency, onset duration, intensity, timing, and depth sensitivity are evaluated across observational products and CMIP6 models.
3. **Hydroclimatic classification.** Events are assigned to heatwave-driven, compound-intensified, precipitation-deficit, or cold/snow-induced regimes from precipitation, temperature, evapotranspiration, and soil-moisture anomalies.
4. **Model agreement and regional analysis.** Multimodel voting, IPCC reference-region summaries, latitudinal profiles, and distributional comparisons quantify spatial robustness.
5. **Future projections.** Historical and SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5 simulations are compared to resolve changes in type proportions, event counts, transitions, and onset speed.
6. **Exposure assessment.** Event footprints are combined with land-area and gridded population data to estimate exposed area and population.
7. **Soil-moisture-buffer attribution.** Trends in soil moisture, evapotranspiration, potential evapotranspiration, vapour-pressure deficit, and precipitation are evaluated alongside flash-drought characteristics.
8. **Causality analysis.** Geographical-detector statistics and Liang-Kleeman information flow assess directional associations between meteorological drivers, soil-moisture buffering, and projected flash-drought frequency.
9. **Figure production.** Maps, heatmaps, zonal profiles, bar charts, circular plots, Sankey diagrams, ridge plots, and causal graphs reproduce main-text and supplementary results.

## Principal Functions

### Event characterization and classification

| Function | Role |
|---|---|
| `PTanom` | Extracts event-scale precipitation, temperature, evapotranspiration, and soil-moisture anomalies; assigns hydroclimatic classes. |
| `GetTiming` | Determines characteristic flash-drought timing from event dates. |
| `GetInt` | Calculates event intensity from standardized soil-moisture evolution. |
| `GetCha` | Aggregates annual frequency, duration, and intensity for historical and SSP experiments. |
| `getZD` | Converts classified events into spatially dominant flash-drought types. |
| `onesetspeed`, `onesetspeed_org` | Summarize and plot changes in flash-drought onset speed. |
| `BufferSSP` | Tests sensitivity of projected soil-moisture-buffer trends to threshold choice. |

`FDenvent` and `FDenventEns` are referenced in optional, commented preprocessing blocks that generate event catalogues. These routines are not included in the simplified review package; supplied catalogues should be used for figure reproduction.

### Spatial statistics and attribution

| Function | Role |
|---|---|
| `cor3d`, `corr3` | Compute gridwise and multidimensional correlation fields. |
| `Contribution`, `Contribution3d` | Estimate standardized contributions of covarying drought types or drivers. |
| `geodetector_factor` | Quantifies spatial explanatory power using geographical-detector statistics. |
| `WilcoxonRanksumTest`, `WilcoxonSignedRankTest` | Perform nonparametric comparisons and report effect sizes. |
| `fdr_bh` | Applies Benjamini-Hochberg false-discovery-rate correction. |
| `CausalityMap`, `causality_Vct` | Estimate gridwise and aggregated information flow. |
| `lkif_analyze_multiX` | Resolves conditional multivariate Liang-Kleeman information flow and significant directed links. |

### Mapping and figure generation

| Function | Role |
|---|---|
| `globalMap`, `globalMapIPCC1`, `globalMapIPCC1tpye`, `globalMap2IPCC` | Produce global maps, IPCC-region summaries, agreement layers, and bivariate regional displays. |
| `PlotLonNew` | Plots latitudinal distributions and intermodel spread. |
| `quadrants1d` | Displays precipitation-temperature anomaly quadrants and class proportions. |
| `EnsLine`, `stage`, `stageDiv` | Plot ensemble trajectories and temporal regime transitions. |
| `plotSankeyFlashDrought` | Visualizes transitions among dominant flash-drought regimes. |
| `barexposedarea`, `barexposedareaRegin`, `expose` | Calculate and display exposed area and population. |
| `plotHeatmap`, `PlotGroupBar`, `PlotPie`, `GeoPlotPie`, `ScatterPlot` | Generate supporting statistical graphics. |
| `MatCM`, `NclCM` | Provide scientific colour maps used throughout the figures. |

## Running the Code

### 1. Prepare MATLAB

Start MATLAB R2026a, install the required toolboxes, and add any external utilities listed above. Confirm toolbox availability with:

```matlab
ver
```

### 2. Set the working directory

Set MATLAB's current folder to the repository root. Relative paths in the main script are resolved from this location.

```matlab
cd('E:\FlashDrought')  % Replace with the local repository path
addpath('MyFun')
addpath('MyFun\LKIF')
```

Do not rename data directories or `.mat` files. Several filenames encode model names or distinguish surface-layer products from root-zone products.

### 3. Verify core inputs

Before execution, confirm that the following commands complete without error:

```matlab
load Mask.mat
load Coordinate.mat
load RiskDeep.mat
load Characteristic.mat
load Dominanted.mat
```

For a stronger dependency check, run:

```matlab
assert(exist('globalMap','file') == 2)
assert(exist('PTanom','file') == 2)
assert(exist('cbrewer2','file') == 2)
assert(exist('trend','file') == 2)
assert(exist('mann_kendall','file') == 2)
```

### 4. Execute by section

Open `A1_MainFun.m` in the MATLAB Editor and use **Run Section** rather than running the entire file at once. Begin with the initialization lines and then execute only the analysis or figure block of interest. This approach limits peak memory and preserves the intended intermediate state.

Recommended order:

1. initialize masks, coordinates, model lists, and custom paths;
2. load supplied event and characteristic products;
3. reproduce historical characterization and classification figures;
4. load `Dominanted.mat` before future-regime analyses;
5. run exposure, forcing-trend, and causality sections independently;
6. export figures from MATLAB using the dimensions and formats required by the target journal.

The commented event-detection and raw-variable assembly blocks are provenance records. Leave them commented when using this simplified release because their raw inputs and several preprocessing functions are not distributed.

### 5. Manage memory explicitly

Close figures and clear large arrays between sections when necessary:

```matlab
close all
clearvars -except latForm lonForm latFormX lonFormX maskpre Aland land nanindall
```

Use this command only after confirming which variables the next section requires. Some later blocks depend on objects created earlier in the script.

## Expected Outputs

The script creates MATLAB figure windows and, in selected preprocessing blocks, updates intermediate `.mat` products. Outputs include:

- global maps of frequency, duration, intensity, timing, and soil-moisture-buffer change;
- surface-versus-root-zone and interdataset comparisons;
- dominant-type maps and model-agreement summaries;
- SSP trajectories, type transitions, and Sankey diagrams;
- exposed-area and exposed-population estimates;
- meteorological-driver trends and threshold-sensitivity maps;
- geographical-detector and information-flow causality results;
- main-text, Extended Data, and Supplementary figure components.

Figure export is intentionally left under reviewer control; the script does not impose a single output directory or overwrite a complete figure set automatically.

## Reproducibility Notes

- All analyses assume a common latitude-longitude grid defined in `Coordinate.mat` and land masks defined in `Mask.mat`.
- Historical analyses generally cover 1950-2014; projections cover 2015-2100 under four SSP scenarios.
- Event statistics frequently use pentads, with 73 pentads per no-leap year.
- Ensemble operations use means, medians, modes, or model-agreement counts as specified in `A1_MainFun.m`; these operations are not interchangeable.
- Missing values represent ocean cells, unavailable simulations, or filtered outliers and must remain `NaN` during spatial aggregation.
- Some commented lines contain author-local absolute paths. They document the original preprocessing environment and are not required for the supplied processed-data workflow.
- Randomized procedures, such as geographical-detector permutation tests, may require a fixed MATLAB random seed for bitwise repetition. Set `rng` explicitly if exact stochastic replication is required.

## Data and Code Boundaries

Processed data are supplied solely to support transparent review of the manuscript workflow. Source products remain subject to the licences and citation requirements of their respective providers. Users should obtain original reanalysis, CMIP6, population, and geographic datasets from their authoritative repositories for independent reconstruction or reuse.

No scientific result should be inferred from function names or comments alone. Numerical outputs should be checked against manuscript figures, stated units, model coverage, and scenario definitions before reuse.

