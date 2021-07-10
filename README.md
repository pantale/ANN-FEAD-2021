# ANN VUHARD repository



This repository contains datafiles related to the publication:

**Efficient Implementation of Non-linear Flow Law Using Neural Network into the Abaqus Explicit FEM code**

submitted to : Finite Elements in Analysis and Design journal.



# Content of the directories

## Main directory

* ANN-Learning.ipynb : Jupyter notebook main training program. This one build and train the ANN.

* PythonToFortran-3layers.ipynb : Jupyter notebook converter to write the VUHARD from the ANN parameters. This one generates the FORTRAN subroutines for Abaqus Explicit.

## ANN-JohnsonCook

This directory contains the following files:

* Datatest.npz : numpy datafile containing the testing data without derivatives
* DatatestWithDerivatives.npz : numpy datafile containing the testing data with derivatives
* JC-Experiments : excel file containing training data for the ANN

that can be used to create new ANN.

## VUHARD

Contents the following FORTRAN files which are pre-trained ANN ready to use:

- VUHARD-ANN-3-15-7-1-sigmoid.f : ANN 3-15-7-1 as proposed in the paper
- VUHARD-ANN-3-7-4-1-sigmoid.f  : ANN 3-15-7-1 as proposed in the paper
- VUHARD.f : Analytical model of the VUHARD

---

## BarNecking

### Built-in model

Built-in model is defined by the **BarNecking.inp** file for Abaqus. Running the model can be done using the following command:

	abaqus job=BI input=BarNecking double=both cpus=2 mp_mode=threads

### Analytical VUHARD model

Analytical VUHARD model is defined by the **BarNecking_VH.inp** file for Abaqus. Running the model can be done using the following command:

	abaqus job=VH input=BarNecking_VH user=../VUHARD/VUHARD.f double=both cpus=2 mp_mode=threads

### ANN VUHARD models

ANN VUHARD model is defined by the **BarNecking_VH.inp** file for Abaqus. Running the model can be done using the following commands:

	abaqus job=ANN-1 input=BarNecking_VH user=../VUHARD/VUHARD-ANN-3-7-4-1-sigmoid.f double=both cpus=2 mp_mode=threads
	abaqus job=ANN-2 input=BarNecking_VH user=../VUHARD/VUHARD-ANN-3-15-7-1-sigmoid.f double=both cpus=2 mp_mode=threads

---
## Taylor

### Built-in model

Built-in model is defined by the **Taylor.inp** file for Abaqus. Running the model can be done using the following command:

	abaqus job=BI input=Taylor double=both cpus=2 mp_mode=threads

### Analytical VUHARD model

Analytical VUHARD model is defined by the **Taylor_VH.inp** file for Abaqus. Running the model can be done using the following command:

	abaqus job=VH input=Taylor_VH user=../VUHARD/VUHARD.f double=both cpus=2 mp_mode=threads

### ANN VUHARD models

ANN VUHARD model is defined by the **Taylor_VH.inp** file for Abaqus. Running the model can be done using the following commands:

	abaqus job=ANN-1 input=Taylor_VH user=../VUHARD/VUHARD-ANN-3-7-4-1-sigmoid.f double=both cpus=2 mp_mode=threads
	abaqus job=ANN-2 input=Taylor_VH user=../VUHARD/VUHARD-ANN-3-15-7-1-sigmoid.f double=both cpus=2 mp_mode=threads



***

Olivier Pantalé  
Full Professor of Mechanics  
email : olivier.pantale@enit.fr

Laboratoire Génie de Production  
Ecole Nationale d'Ingénieurs de Tarbes  
Université de Toulouse  
47 Avenue d'Azereix - BP 1629  
65016 TARBES - CEDEX - FRANCE
