# RNA-ML-Sample-Hierarchical-Classification

## Introduction

RNA-based sample discrimination and classification can be used to provide biological insights and/or distinguish between clinical groups. However, finding informative differences between sample groups can be challenging due to the multidimensional and noisy nature of sequencing data. Here, we apply a machine learning approach for hierarchical discrimination and classification of samples with high dimensional miRNA expression data. Our protocol comprises data preprocessing, unsupervised learning, feature selection, and machine learning-based hierarchical classification, alongside open-source MATLAB code.

The full text of this protocol is available here: 
INSERT LINK FOR PUBLISHED PAPER?

CITATION FOR PAPER HERE?

For questions regarding usage, please email: 17ti6@queensu.ca or kt40@queensu.ca CONFIRM WHO BE IT

<div align="center">
    <img src="https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/c0ce8e7e-8a0b-4768-9f5e-85c8db870526" width="750">
</div>


## Software Installation and Directory Set-up
Estimated time: 1 hour

1.	Install MATLAB (ver. R2020a or later). Follow web-accessible [download and installation instructions](https://www.mathworks.com/help/install/install-products.html). To learn more about the MATLAB development environment, see this video on [“Working in the Development Environment.”](https://www.mathworks.com/videos/working-in-the-development-environment-69021.html?s_tid=vid_pers_recs)

2. Download and install MFeaST from: [https://www.renwicklab.com/molecular-feast/](https://www.renwicklab.com/molecular-feast/).  
    a. Choose the one-step installation version. This ensures the MATLAB Runtime corresponding to the app version is also installed.  
    b. Select your operating system and then click the “Add to cart” button. Click “View cart”.  
    c. Click “Proceed to checkout”. Type in your contact information as requested and click “Submit”.  
    d. Click the “Download” button.  
    e. A pop-up will appear. Type in the username: mfeast, password: rankmolecules.  
    f. Install MFeaST as an “Administrator”. See Troubleshooting 2 for errors during installation and Mac OS specific installation instructions.



**CRITICAL:** During installation, ensure the following toolboxes are selected for download: *Bioinformatics Toolbox*, *Statistics and Machine Learning Toolbox*, *Deep Learning Toolbox*, *Parallel Computing Toolbox*, and the *Optimization Toolbox*. To check if these toolboxes are installed in MATLAB, follow Troubleshooting 1. 

## Troubleshooting
Below are common issues which may arise during the installation steps of this protocol. The below and additional troubleshooting instructions are available in the full text.

**Problem 1:**
Check that the required MATLAB toolboxes are installed: *Bioinformatics Toolbox*, *Statistics and Machine Learning Toolbox*, *Deep Learning Toolbox*, *Parallel Computing Toolbox* and/or the *Optimization Toolbox* are installed.

**Potential Solution:**
To view installed toolboxes, navigate to the *Home* tab in MATLAB. Click the arrow under the Add-ons button, then click Manage Add-ons (Figure 29A). In the pop-up window, installed add-ons are listed under the Installed tab (Figure 29B). 

Alternatively, type the following in the MATLAB command window to view a list of installed toolboxes: 

```matlab
matlab.addons.installedAddons
```

If you do not see the *Statistics and Machine Learning Toolbox*, the *Bioinformatics Toolbox*, *Deep Learning Toolbox*, *Parallel Computing Toolbox* and/or the *Optimization Toolbox*, install these toolboxes by following this video tutorial. 


