# RNA-ML-Sample-Hierarchical-Classification
Protocol for RNA-based sample discrimination and hierarchical classification.  

## Table of Contents
* [Introduction](#intro)
* [Software installation and directory set-up](#setup)
* [Materials and equipment](#materials)
* [MFeaST Usage](#mfeast-usage)
* [Troubleshooting](#troubleshooting)

## Introduction<a name="intro"></a>

RNA-based sample discrimination and classification can be used to provide biological insights and/or distinguish between clinical groups. However, finding informative differences between sample groups can be challenging due to the multidimensional and noisy nature of sequencing data. Here, we apply a machine learning approach for hierarchical discrimination and classification of samples with high dimensional miRNA expression data. Our protocol comprises data preprocessing, unsupervised learning, feature selection, and machine learning-based hierarchical classification, alongside open-source MATLAB code.

The full text of this protocol is available here: 
INSERT LINK FOR PUBLISHED PAPER?

For questions regarding usage, please email: kt40@queensu.ca

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

## Materials and equipment<a name="materials"></a>
- [MATLAB ver. R2020a or later](https://www.mathworks.com/products/matlab.html)
- [_Molecular Feature Selection Tool_ (_MFeaST)_](https://www.renwicklab.com/molecular-feast/)
- Custom MATLAB scripts and functions (found in `Supplementary Materials`)
- Expression data (e.g. miRNA-Seq, RNA-Seq, scRNA-Seq, etc.)

**Note:** The example in this protocol uses miRNA expression data from different neuroendocrine neoplasms. This data is available in the `Supplementary Materials` of this protocol. The complete analysis is available at [Nanayakkara et al.,2020](https://academic.oup.com/narcancer/article/2/3/zcaa009/5867117)

### Hardware requirements
- Computer with internet access and `>=` 4 GB of RAM. This protocol was developed on Mac OS 10.14.6 with 8 GB of RAM, 2 cores and Windows 11 with 32 GB of RAM, 8 cores. In addition, the protocol was tested on both Mac and Windows operating systems with a range of specifications. 

## MFeaST usage

## Troubleshooting

Below are common issues which may arise during the installation steps of this protocol. The below and additional troubleshooting instructions are available in the full text.

**Problem 1:**<a name="t1"></a>
Check that the required MATLAB toolboxes are installed: *Bioinformatics Toolbox*, *Statistics and Machine Learning Toolbox*, *Deep Learning Toolbox*, *Parallel Computing Toolbox* and/or the *Optimization Toolbox* are installed.

**Potential Solution:**
To view installed toolboxes, navigate to the *Home* tab in MATLAB. Click the arrow under the *Add-ons* button, then click *Manage Add-ons* (Figure 29A). In the pop-up window, installed add-ons are listed under the *Installed* tab (Figure 29B). 

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
        - Cancel current installation (Figure 30A).
        - Click the “System Preferences” icon ![image](https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/4604f734-870d-4e09-a6ca-330269687786) in the Dock or click the Apple menu from the toolbar  ![image](https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/0b8104e1-dd11-440c-b9e0-7d09783e2fbd) > “System Preferences”. Click “Security & Privacy” ![image](https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/1449683b-54bf-4c31-8e14-e5b892728d11) (Figure 30B).
        - From the top menu, select “General” (Figure 30C). Under “Allow apps downloaded from:”, make sure “App Store and identified developers” is selected. You may have to enter your administrator password to apply changes.
        - Click the lock icon in the left-hand corner beside “Click the lock to make changes.” A message should appear in the “Allow apps downloaded from:” section indicating MolecularFeaST was blocked. Select the “Open Anyway” button beside this message. A pop-up window will appear, select “Open” (Figure 30D).
        - MFeaST will begin installing. You may get a pop-up message “java wants to make changes” (Figure 30E). Type in your administrator password and select “OK”.


    - _"Cannot locate a valid install area"_
        - Make sure you download and install the “One-step installation” version of MFeaST from https://www.renwicklab.com/downloads/. 
     
   
* Windows operating system:
    *  _“Do you want to allow this app from an unknown publisher to make changes to your device?”_
        * Select “Yes”. Make sure you are running as an administrator.


