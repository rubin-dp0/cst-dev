####################################
02. Custom Coadds from the Command Line (intermediate)
####################################

.. This section should provide a brief, top-level description of the page.

**Contact author:** Aaron Meisner

**Last verified to run:** 05/02/2023

**Targeted learning level:** Intermediate

**Container size:** large

**Credit:** This command line tutorial is based on the corresponding notebook tutorial by Melissa Graham. The command line approach is heavily influenced by Shenming Fu's recipe for reducing DECam data with the Gen3 LSST Science Pipelines, which is in turn based on Lee Kelvin's Merian processing instructions.

**Introduction:** 
This tutorial shows how to use command line `butler` invocations to produce custom coadds from simulated single-exposure Rubin/LSST images. It is meant to parallel the corresponding Jupyter Notebook tutorial entitled `Construct a Custom Coadded Image <https://github.com/rubin-dp0/tutorial-notebooks/blob/main/09_Custom_Coadds/09a_Custom_Coadd.ipynb>`_.

This tutorial uses the Data Preview 0.2 (DP0.2) data set.
This data set uses a subset of the DESC's Data Challenge 2 (DC2) simulated images, which have been reprocessed by Rubin Observatory using Version 23 of the LSST Science Pipelines.
More information about the simulated data can be found in the DESC's `DC2 paper <https://ui.adsabs.harvard.edu/abs/2021ApJS..253...31L/abstract>`_ and in the `DP0.2 data release documentation <https://dp0-2.lsst.io>`_.

