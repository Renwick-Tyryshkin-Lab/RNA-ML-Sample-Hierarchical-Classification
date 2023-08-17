# A User-Driven Machine Learning Approach for RNA-Based Sample Discrimination and Hierarchical Classification 
Protocol for RNA-based sample discrimination and hierarchical classification.  

## Table of Contents
* [Introduction](#intro)
* [Software installation and directory set-up](#setup)
* [Materials and equipment](#materials)
* [How to use this github page](#git-instructions)
* [MFeaST Usage](#mfeast-usage)
* [Troubleshooting](#troubleshooting)

## Introduction<a name="intro"></a>

RNA-based sample discrimination and classification can be used to provide biological insights and/or distinguish between clinical groups. However, finding informative differences between sample groups can be challenging due to the multidimensional and noisy nature of sequencing data. Here, we apply a machine learning approach for hierarchical discrimination and classification of samples with high dimensional miRNA expression data. Our protocol comprises data preprocessing, unsupervised learning, feature selection, and machine learning-based hierarchical classification, alongside open-source MATLAB code.

The full text of this protocol is available here: 
INSERT LINK FOR PUBLISHED PAPER?

For questions regarding usage, please email: kt40@queensu.ca or 17ti6@queensu.ca

<div align="center">
    <img src="https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/c0ce8e7e-8a0b-4768-9f5e-85c8db870526" width="750">
</div>

## Software installation and directory set-up<a name="setup"></a>
Estimated time: 1 hour

1.	Install MATLAB (ver. R2020a or later). Follow web-accessible [download and installation instructions](https://www.mathworks.com/help/install/install-products.html). To learn more about the MATLAB development environment, see this video on [“Working in the Development Environment.”](https://www.mathworks.com/videos/working-in-the-development-environment-69021.html?s_tid=vid_pers_recs)

**CRITICAL:** During installation, ensure the following toolboxes are selected for download: *Bioinformatics Toolbox*, *Statistics and Machine Learning Toolbox*, *Deep Learning Toolbox*, *Parallel Computing Toolbox*, and the *Optimization Toolbox*. To check if these toolboxes are installed in MATLAB, see [Troubleshooting 1](#t1). 

2. Download and install _MFeaST_ from: [https://www.renwicklab.com/molecular-feast/](https://www.renwicklab.com/molecular-feast/).  
    a. Choose the one-step installation version. This ensures the MATLAB Runtime corresponding to the app version is also installed.  
    b. Select your operating system and then click the “Add to cart” button. Click “View cart”.  
    c. Click “Proceed to checkout”. Type in your contact information as requested and click “Submit”.  
    d. Click the “Download” button.  
    e. A pop-up will appear. Type in the username: mfeast, password: rankmolecules.  
    f. Install _MFeaST_ as an “Administrator”. See [Troubleshooting 2](#t1) for errors during installation and Mac OS specific installation instructions.

3. Create a `utility_functions` directory to store utility functions (programming code). These functions may be applied in other future projects. We recommend creating this directory within the `Documents/MATLAB` directory.

4. Create a main project directory to store MATLAB scripts and functions for each project. For this example, we name this directory, `Neuroendocrine_neoplasms`. We create this directory under `Documents`; however, you may create this directory wherever you store your work.  
    a. Within the main project directory, create a subdirectory, `results_data`. Throughout the protocol, new output files will be saved to the `results_data` directory.  
    b. Within the main project directory, create a subdirectory, `project_data`.  
    
5. Download the required input, output, and MATLAB code (.m) files from the `Supplementary Materials` of this protocol.  
    a. Place all input files into the `project_data` directory. These include the Supplementary Tables (.xlsx files) and MATLAB workspace variables (.mat files).   
    b. Place all project specific .m files that contain “scripts” in their file name, into the `Neuroendocrine_neoplasms` main directory.   
   c. Place all other .m files in the `utility_functions` directory. These files can be used for the current protocol and future projects.

6. Open the MATLAB user interface and set the current working directory to `Neuroendocrine_neoplasms`. Select the _Open Folder_ button on the working directory toolbar (Figure 1A) and navigate to the `Neuroendocrine_neoplasms` directory in the pop-up window.

7. Add the `utility_functions` directory to the MATLAB path. Select the _Set Path_ button located in the _Environment_ section of the _Home_ tab (Figure 1B). In the pop-up window, click on _Add Folder_, navigate to the `utility_functions` directory and add it to the path. Similarly, add the `Neuroendocrine_neoplasms` directory to the path.

<div align="center">
    <img src="https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/a72d1ed1-726f-450f-932f-8b4072e31df4">
</div>

**Figure 1. Open directory and set path in MATLAB.** (A) To open a directory in MATLAB, select the _Open Folder_ button on the working directory toolbar. (B) To change or add a directory to the MATLAB path, select the _Set Path_ button from the _Home_ tab toolbar. Click on the _Add Folder_ button in the pop-up window to add a folder to the path.

## Materials and equipment<a name="materials"></a>
- [MATLAB ver. R2020a or later](https://www.mathworks.com/products/matlab.html)
- [_Molecular Feature Selection Tool_ (_MFeaST)_](https://www.renwicklab.com/molecular-feast/)
- Custom MATLAB scripts and functions (found in `Supplementary Materials`)
- Expression data (e.g. miRNA-Seq, RNA-Seq, scRNA-Seq, etc.)

**Note:** The example in this protocol uses miRNA expression data from different neuroendocrine neoplasms. This data is available in the `Supplementary Materials` of this protocol. The complete analysis is available at [Nanayakkara et al.,2020.](https://academic.oup.com/narcancer/article/2/3/zcaa009/5867117)

### Hardware requirements
- Computer with internet access and &ge; 4 GB of RAM.

**Note:** This protocol was developed on Mac OS 10.14.6 with 8 GB of RAM, 2 cores and Windows 11 with 32 GB of RAM, 8 cores. In addition, the protocol was tested on both Mac and Windows operating systems with a range of specifications. Some of the time estimates may vary based on the hardware specifications.

## How to use this github page<a name="git-instructions"></a>
* Download the `Supplementary Materials` directory.
    * The `utility_functions` directory contains all custom functions required in this protocol. These functions are also found in the `Supplementary Materials` directory.
    * The `Scripts` directory contains all MATLAB scripts used in this protocol. These scripts are also found in the `Supplementary Materials` directory.
    * The `Example data` directory contains all example data described in the protocol text. These files are also found in the `Supplementary Materials` directory.
* This folder contains the MATLAB scripts and functions required for this protocol.
* `Supplementary Materials` also contains the example data used in the protocol. 
* Download _MFeaST_ from https://www.renwicklab.com/molecular-feast/. See [Software installation and directory set-up](#setup))
* Follow the instructions in [Software installation and directory set-up](#setup) for setting up your MATLAB workspace and directories.
* Follow the complete protocol text for how to run the MATLAB scripts, functions and apps for your data.

## _MFeaST_ Usage

The _Molecular Feature Selection Tool (MFeaST)_ is an ensemble feature selection tool. _MFeaST_ ranks all available features based on their combined score from multiple selection algorithms. Compared to other ensemble approaches which are limited to a subset of feature selection algorithms, _MFeaST_ uses filter, wrapper, and embedded techniques. 

See [Gerolami et al. (2022)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9407361/) for more information on _MFeaST_.

### Format data for _MFeaST_
MFeaST requires the data to be formatted with sample IDs as the first row, class labels as the subsequent rows, followed by the remaining feature expression rows and the feature names in the first column. Our formatted data is saved in the _training_data4MFeaST.csv_ file and is also provided in Supplementary Table 4.

Example: 
![image](https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/a939a64d-3719-41eb-bec5-c92af3ea29d2)

### Run feature selection with _MFeaST_
1. Open the _MFeaST_ application. If this is your first time opening the application and/or you receive an error, see [Troubleshooting 2](#t2).

2. Click _Import Data_ and navigate to your expression data file. The file must be a .csv or .xlsx file. In our example, the data is stored in _training_data4MFeaST.csv_ located within the `Neuroendocrine_neoplasms/results_data` directory (Figure 2A).

3. When prompted, indicate that the data are not log2 transformed. Click _Next_ to proceed. 

**Note:** The data must be positive unless they are log2 transformed. If your data are log2 transformed, select “Yes”. If the data are log2 transformed and/or contain negative values, “Negative values detected” will appear next to the _Value Check_ (under the _Data Input_ section, Figure 2A). It is assumed that expression data must be positive, therefore if your data has negative values, it may be log-transformed or contain an error.

4. Select a binary comparison for feature selection. The categories in the input file are listed on the lefthand menu. All possible binary comparisons of classes within a category are listed on the righthand menu. Under the _Comparisons Selection_ tab, select a category e.g. 'Embryological_Origin' from the lefthand menu (Figure 2B). Then, select the comparison e.g. ‘Midgut vs Non-midgut’ from the righthand menu. Click _Next_ to continue.

<div align="center">
    <img src="https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/2d45e4fb-025c-405a-adcf-d1e012fe1e0d">
</div>

**Figure 2. Import data and select comparison for feature selection in _Molecular Feature Selection Tool (MFeaST)_.** (A) To import data into _MFeaST_, click the _Import Data_ button and navigate to the .xlsx or .csv file to import. Verify expected values through the _Value Check_ parameter. (B) To select a comparison for feature selection, select the category from the left menu. Go through potential binary comparisons from the drop-down menu on the right and select the specific binary comparison to perform. Click _Next_ to proceed. 

5. Under the _Feature Selection_ tab (Figure 3), set the relevant feature selection parameters. There are three menus on this page: Select algorithms, Cross-validation, and # Iterations for Sequential algorithms (alg.). Recommendations for each menu are listed below. After adjusting the menu options, click _Run_ to proceed.
    a. Select Algorithms: We recommend using all algorithms. However, the sequential algorithms will take a long time to run and may need to be excluded for datasets with thousands of features remaining after filtering.    
    b.	Cross-validation: Select 5-fold cross-validation (default). For datasets with less than five samples in one class, use leave-one-out validation.    
    c.	# Iterations for Sequential alg.: Use the default 5 iterations. This value is the maximum number of iterations the sequential algorithms perform to compute a stable solution.    

**Note:** You may increase the number of iterations to improve the stability of features selected by the sequential algorithms. Or you may decrease this value to speed up execution. Using the example data, this step may take 2-4 hours to run depending on the computer specifications and if sequential algorithms were selected. 

<div align="center">
    <img src="https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/633d372d-032d-48a0-bc40-ee48aa216928">
</div>

**Figure 3. Select parameters for feature selection in _Molecular Feature Selection Tool (MFeaST)_.** Select feature selection algorithms from the _Select Algorithms_ menu on the left. Select the cross-validation method from the _Cross-Validation_ menu, the default is set to 5-fold cross-validation. Set the number of iterations for the sequential algorithms in the _# Iterations for Sequential alg._ menu. Select _Run_ to begin feature selection. 

6. Once the feature selection ranking algorithms are complete, the results are presented under the _Results_ tab (Figure 4). To review the ranking information from each feature selection algorithm, select _Ranked Features_ from the drop-down list (Figure 4, number 1). Select _Ranked cell data_ from the drop-down menu to view the ranked expression data.

<div align="center">
    <img src="https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/c7cb81e4-7ace-4fd3-9d73-f7625fc124c3">
</div>

**Figure 4. View results of feature selection in _Molecular Feature Selection Tool (MFeaST)_.** To view the ranked list of features after running feature selection, scroll through the list on the left (1). To visualize how samples discriminate based on the selected features, plot the expression data through scatterplots, t-SNE plots or hierarchical clustering (_Clustering_ tab; Figure 5). Select a subset of features based on their ability to discriminate classes. 

8. Export the results into a .mat file (Figure 4, number 2). Click _Export Results_ and then click on the .mat button. Name the file as e.g. _midgut_v_nonmidgut_rankedResults.mat_.

**Note:** The ranking results can also be exported into an Excel file by clicking Export Results → .xlsx.

9. Save the session by clicking _Save as_ from the drop-down list at the top right of the window (Figure 4, number 13). This saves the entire _MFeaST_ session. The session can be opened later, without re-running the feature selection, by selecting _Open_ in the Session drop down list. You can override an existing session or save as a new session.

### Select top ranking features

There are several approaches for selecting the top-ranked features. The discriminatory features can be selected using all, a top percentage, and/or a custom list of ranked features. The selected features can be visualized as a group, individually or pairwise.

#### Select all possible features important for discrimination
If the goal is to select all possible features that are important for discrimination, select the top % of features (Figure 4, number 14) for which the best clustering is observed.    

1. Select the top 1% and visualize with a clustergram and/or t-SNE plot.     

**Note:** There is a minimum number of features required to generate a t-SNE scatterplot and/or clustergram. For t-SNE, you require at least two features. For hierarchical clustering, this value may vary based on the distance metric chosen.  

2. To generate a clustergram using the features in the _Selected Features_ list, proceed to the _Clustering_ tab (Figure 5). We recommend using the default parameters (Samples similarity: Spearman, Features similarity: Euclidean, Linkage: Average, Color map: RedBlue, Symmetric: yes) and adjusting as necessary. Click on the _Boxplot_ button to create a boxplot and select a value for the display range. Choose the display range based on the upper quartile of majority of the plotted boxes. After adjusting the parameters, click the _Generate_ button. After reviewing the clustergram, return to the _Results_ tab.

<div align="center">
    <img src="https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/4da57f43-49e0-4441-b69d-b98a1b824c17">
</div>

**Figure 5. Visualize clustering of samples by selected features in _Molecular Feature Selection Tool (MFeaST)_.** To visualize how the selected features (_Results_ tab; Figure 4) cluster the samples, generate a clustergram through the _Clustering_ tab. Select the distance measure for the samples and features, the linkage method, the colormap for the heatmap, the display range and whether the colorbar should be symmetric around 0. Click _Generate_ to create the clustergram. 

4. To generate a t-SNE plot using the selected features, click on the _TSNE_ button in the _Results_ tab (Figure 4, number 18).     

5. Repeat the visualization with the top 5%, 10%, etc. of selected features. Note the range of top percentages for which the best clustering is observed, i.e. where the two classes form distinct clusters. The range identifies features to use in subsequent analysis.     

**Note:** Depending on your application and objective, you may go with the smallest or largest percentage of features within the range.

#### Select smallest set of features
If the goal is to select the smallest set of features, then further custom selection is required.

1. Click on the _Predictive Importance Plot_ button (Figure 4, number 12) to visualize the ranked discriminatory ability of all features. For a given feature, a value closer to 1 indicates higher importance in discriminating between the two classes.

2. Make a note of where there is a drop in discriminatory ability on the predictive importance plot (e.g. an L shaped curve or an inflection point). This point is an estimate of how far to go down the ranked list when selecting features. In our midgut vs non-midgut comparison, the drop occurs between the top 1% and 5% of features (Figure 6).

<div align="center">
    <img src="https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/dd2601ee-c525-4207-a077-d6cc04c46094">
</div>

**Figure 6. Predictive importance of ranked features in _Molecular Feature Selection Tool (MFeaST)_.** To estimate the range of features for selection, visualize the predictive importance of the ranked features under the _Results_ tab. The “Average Discriminatory Ability” of a feature is the average of the scores from all feature selection algorithms that were run (_Feature Selection tab_; Figure 3). The ranked list of features is presented along the horizontal axis, with the dashed lines representing the divisions between the top % of features. 

4. Review the discriminatory power of (a) individual features (b) consecutive pairs of features, or (c) one feature paired with any other feature, by generating scatterplots under the _Plot_ panel. You may edit the plot markers by clicking on the eyedropper button (Figure 4, number 9).    
    a. To plot features individually: Click on the first feature in the ranked list. The feature row will become highlighted on the ranking list panel. This will plot the expression values on the y-axis against the sample numbers on the x-axis.    
   b. To view paired features: Select the button underneath the ranked list with two circles and a downward arrow (Figure 4, number 3) to plot the first two features. Click on this button again to move down the ranked list pairwise. To move up the list, click on the button beside it, with an upward arrow.    
   c. To view any feature paired with any other feature: Click on any two features consecutively. The two selected features will be highlighted on the ranking list panel and displayed on the scatterplot, one versus the other.

**Note:** To better visualize positively skewed expression values, select the “LOG 2” button (Figure 4, number 8) to apply log2 transformation. 

4. Add a feature shown on the scatterplot to the _Selected Features_ list by clicking the plus button beside the axis corresponding to the feature (Figure 4, number 5 and 10).

5. Remove a feature from the Selected Features list by clicking the minus button beside the axis corresponding to the feature (Figure 4, number 6 and 11). Alternatively, select the feature on the _Selected Features_ list and click the minus button (Figure 4, number 16).
   
7. Based on the results of the scatterplot and predictive importance plot, add, or remove features from the custom list. Visualize the combined discriminatory ability of the features through generating t-SNE scatterplot (Figure 4, number 18) and clustergram.

8. Copy the list of selected features by clicking the Copy button (Figure 4, number 19).

**Note:** This process requires some trial and error as features are added or removed. 

## Troubleshooting

Below are common issues which may arise during the installation steps of this protocol. The below and additional troubleshooting instructions are available in the full text.

**Problem 1:**<a name="t1"></a>
Check that the required MATLAB toolboxes are installed: *Bioinformatics Toolbox*, *Statistics and Machine Learning Toolbox*, *Deep Learning Toolbox*, *Parallel Computing Toolbox* and/or the *Optimization Toolbox* are installed.

**Potential Solution:**
To view installed toolboxes, navigate to the *Home* tab in MATLAB. Click the arrow under the *Add-ons* button, then click *Manage Add-ons* (Figure 7A). In the pop-up window, installed add-ons are listed under the *Installed* tab (Figure 7B). 

<div align="center">
    <img src="https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/76cf0ae3-f5f4-4262-b001-afc5b8d416e7">
</div>

**Figure 7. Troubleshooting Problem 1 – Check installed toolboxes.** (A) To view installed add-ons, select _Add-ons_ from the MATLAB _Home_ toolbar. Click _Manage Add-ons_ to view add-ons. (B) Under the _Installed_ add-ons tab, verify installation of the __Bioinformatics_ Toolbox, Statistics and Machine Learning Toolbox, Deep Learning Toolbox_ and the _Optimization Toolbox_. 

Alternatively, type the following in the MATLAB command window to view a list of installed toolboxes: 

```matlab
matlab.addons.installedAddons
```

If you do not see the *Statistics and Machine Learning Toolbox*, the *Bioinformatics Toolbox*, *Deep Learning Toolbox*, *Parallel Computing Toolbox*, and/or the *Optimization Toolbox*, install these toolboxes by following this [video tutorial](https://www.mathworks.com/videos/add-on-explorer-106745.html). 

**Problem 2:**<a name="t2"></a>
Errors during *MFeaST* installation. 

**Potential Solution:**
- Mac operating system:
    - _"MolecularFeaST.app cannot be opened because the developer cannot be verified."_ **Note:** This error and solution were generated on macOS Monterey v12.5.1. If you are running another version of macOS, this solution may or may not work for you. 
        - Cancel current installation (Figure 8A).
        - Click the “System Preferences” icon ![image](https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/4604f734-870d-4e09-a6ca-330269687786) in the Dock or click the Apple menu from the toolbar  ![image](https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/0b8104e1-dd11-440c-b9e0-7d09783e2fbd) > “System Preferences”. Click “Security & Privacy” ![image](https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/1449683b-54bf-4c31-8e14-e5b892728d11) (Figure 8B).
        - From the top menu, select “General” (Figure 8C). Under “Allow apps downloaded from:”, make sure “App Store and identified developers” is selected. You may have to enter your administrator password to apply changes.
        - Click the lock icon in the left-hand corner beside “Click the lock to make changes.” A message should appear in the “Allow apps downloaded from:” section indicating MolecularFeaST was blocked. Select the “Open Anyway” button beside this message. A pop-up window will appear, select “Open” (Figure 8D).
        - MFeaST will begin installing. You may get a pop-up message “java wants to make changes” (Figure 8E). Type in your administrator password and select “OK”.

    - _"Cannot locate a valid install area"_
        - Make sure you download and install the “One-step installation” version of _MFeaST_ from https://www.renwicklab.com/downloads/.

<div align="center">
    <img src="https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/f1d322f8-55db-485f-b698-b2964079ad12">
</div>

**Figure 8. Troubleshooting Problem 2 – MFeaST “Developer cannot be verified” Installation error on Mac OS.** (A) “Developer cannot be verified” error will window pop-up when trying to open _MFeaST_ for the first time. Click “Cancel.” (B) Open “System Preferences” and select “Security and Privacy.” (C) Under the “General” tab of the “Security and Privacy” window, warning for _MolecularFeast_ will appear. Select “Open Anyway.” (D) Click the _MFeaST_ icon to open again. Click “Open” on pop-up “Developer cannot be verified” error window. (E) Enter administrator password if prompted. 
   
* Windows operating system:
    *  _“Do you want to allow this app from an unknown publisher to make changes to your device?”_
        * Select “Yes”. Make sure you are running as an administrator.


