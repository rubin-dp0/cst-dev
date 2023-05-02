####################################
02. Custom Coadds from the Command Line (intermediate)
####################################

.. This section should provide a brief, top-level description of the page.

**Contact author:** Aaron Meisner

**Last verified to run:** 05/02/2023

**Targeted learning level:** Intermediate

**Container size:** large

**Credit:** This command line tutorial is based on the corresponding notebook tutorial by Melissa Graham. The command line approach is heavily influenced by Shenming Fu's recipe for reducing `DECam <https://noirlab.edu/science/programs/ctio/instruments/Dark-Energy-Camera>`_ data with the Gen3 LSST Science Pipelines, which is in turn based on `Lee Kelvin's Merian processing instructions <https://hackmd.io/@lsk/merian>`_.

**Introduction:** 
This tutorial shows how to use command line ``pipetask`` invocations to produce custom coadds from simulated single-exposure Rubin/LSST images. It is meant to parallel the corresponding Jupyter Notebook tutorial entitled `Construct a Custom Coadded Image <https://github.com/rubin-dp0/tutorial-notebooks/blob/main/09_Custom_Coadds/09a_Custom_Coadd.ipynb>`_.

This tutorial uses the Data Preview 0.2 (DP0.2) data set.
This data set uses a subset of the DESC's Data Challenge 2 (DC2) simulated images, which have been reprocessed by Rubin Observatory using Version 23 of the LSST Science Pipelines.
More information about the simulated data can be found in the DESC's `DC2 paper <https://ui.adsabs.harvard.edu/abs/2021ApJS..253...31L/abstract>`_ and in the `DP0.2 data release documentation <https://dp0-2.lsst.io>`_.


**WARNING:
This custom coadd tutorial will only run with LSST Science Pipelines version Weekly 2022_40.**

To find out which version of the LSST Science Pipelines you are using, look in the footer bar.

If you are using ``w_2022_40``, you may proceed with executing the custom coadd notebooks.

If you are **not** using ``w_2022_40`` you **must** log out and start a new server:
 1. At top left in the menu bar choose File then Save All and Exit.
 2. Re-enter the Notebook Aspect.
 3. At `the "Server Options" stage <https://dp0-2.lsst.io/data-access-analysis-tools/nb-intro.html#how-to-log-in-navigate-and-log-out-of-jupyterlab>`_, under "Select uncached image (slower start)" choose ``w_2022_40``.
 4. Note that it might take a few minutes to start your server with an old image.

**Why do I need to use an old image for this tutorial?**
In this tutorial and in the future with real LSST data, users will be able to recreate coadds starting with intermediate data products (the warps).
On Feb 16 2023, as documented in the `Major Updates Log <https://dp0-2.lsst.io/tutorials-examples/major-updates-log.html#major-updates-log>`_ for DP0.2 tutorials, the recommended image of the RSP at data.lsst.cloud was bumped from Weekly 2022_40 to Weekly 2023_07.
However, the latest versions of the pipelines are not compatible with the intermediate data products of DP0.2, which were produced in early 2022.
To update this tutorial to be able to use Weekly 2023_07, it would have to demonstrate how to recreate coadds *starting with the raw data products*.
This is pedagogically undesirable because it does not accurately represent *future workflows*, which is the goal of DP0.2.
Thus, it is recommended that delegates learn how to recreate coadds with Weekly 2022_40.

Step 1. Access the terminal and setup
=====================================

1.1. Log in to the Notebook Aspect. The terminal is a subcomponent of the Notebook Aspect.

1.2. In the launcher window under "Other", select the terminal.

1.3. Set up the Rubin Observatory environment.

.. code-block::

    setup lsst_distrib
    
1.4. Perform a command line verification that you are using the correct `w_2022_40` version of the LSST Science Pipelines.

.. code-block::

     eups list lsst_distrib
     g0b29ad24fb+9b30730ed8       current w_2022_40 setup

Step 2. Build your custom coaddition pipeline
=============================================

As you saw in tutorial notebook 9b, you do not need to rerun the entire DP0.2 data processing in order to obtain custom coadds. You only need to run a subset of the Tasks that make up ``step3`` of the DP0.2 processing, where ``step3`` refers to coadd-level processing. Specifically, you want to rerun only the `makeWarp` and `assembleCoadd` tasks.

The strategy for running these custom coadds via the command line is to start with the "Data Release Production" (DRP) pipeline used for DP0.2 processing and make relatively minor edits to isolate the specific ``makeWarp`` and ``assembleCoadd`` tasks of interest.

2.1. Inspect the DP0.2 YAML pipeline definition

Let's start by taking a look at the DRP pipeline YAML pipeline definition file for DP0.2. As mentioned in notebook tutorial 9a, this can be viewed from within the Rubin Science Platform (RSP) at ``$DRP_PIPE_DIR/ingredients/LSSTCam-imSim/DRP.yaml``. There are multiple ways to view an `ASCII <https://en.wikipedia.org/wiki/ASCII>`_ (plain text) file such as ``DRP.yaml`` from a Linux terminal. Here we use a program called `cat <https://en.wikipedia.org/wiki/Cat_(Unix)>`_.


.. code-block::

    cat $DRP_PIPE_DIR/ingredients/LSSTCam-imSim/DRP.yaml
    description: DRP specialized for ImSim-DC2 data
    instrument: lsst.obs.lsst.LsstCamImSim
    imports:
      - $DRP_PIPE_DIR/ingredients/DRP-minimal-calibration.yaml
      - $FARO_DIR/pipelines/metrics_pipeline.yaml
    tasks:
      isr:
        class: lsst.ip.isr.IsrTask
        config:
          connections.newBFKernel: bfk
          doDefect: false
          doBrighterFatter: true
      calibrate:
        class: lsst.pipe.tasks.calibrate.CalibrateTask
        config:
          connections.astromRefCat: "cal_ref_cat_2_2"
          connections.photoRefCat: "cal_ref_cat_2_2"
          python: >
            config.astromRefObjLoader.filterMap = {band: 'lsst_%s_smeared' % (band) for band in 'ugrizy'};
            config.photoRefObjLoader.filterMap = {band: 'lsst_%s_smeared' % (band) for band in 'ugrizy'};
      measure:
        class: lsst.pipe.tasks.multiBand.MeasureMergedCoaddSourcesTask
        config:
          connections.refCat: "cal_ref_cat_2_2"
          python: >
            config.match.refObjLoader.filterMap = {band: 'lsst_%s_smeared' % (band) for band in 'ugrizy'};
      matchObjectToTruth:
        class: lsst.pipe.tasks.match_tract_catalog.MatchTractCatalogTask
        config:
          python: |
            # Target settings are likely common to all object tables
            from lsst.pipe.tasks.match_tract_catalog_probabilistic import MatchTractCatalogProbabilisticTask
            config.match_tract_catalog.retarget(MatchTractCatalogProbabilisticTask)
            config.match_tract_catalog.columns_ref_flux = [
                'flux_u', 'flux_g', 'flux_r',
                'flux_i', 'flux_z', 'flux_y',
            ]
            config.match_tract_catalog.columns_ref_meas = [
                'ra', 'dec',
                'flux_u', 'flux_g', 'flux_r',
                'flux_i', 'flux_z', 'flux_y',
            ]
            config.match_tract_catalog.columns_target_meas = [
                'x', 'y',
                'u_cModelFlux', 'g_cModelFlux', 'r_cModelFlux',
                'i_cModelFlux', 'z_cModelFlux', 'y_cModelFlux',
            ]
            config.match_tract_catalog.columns_target_err = [
                'xErr', 'yErr',
                'u_cModelFluxErr', 'g_cModelFluxErr', 'r_cModelFluxErr',
                'i_cModelFluxErr', 'z_cModelFluxErr', 'y_cModelFluxErr',
            ]
            config.match_tract_catalog.coord_format.coords_ref_to_convert = {'ra': 'x', 'dec': 'y'}
            # Might need adjusting for different survey depths
            config.match_tract_catalog.mag_faintest_ref = 27.0
            config.match_tract_catalog.columns_ref_copy = ['id']
            config.match_tract_catalog.columns_target_copy = ['objectId']
      compareObjectToTruth:
        class: lsst.pipe.tasks.diff_matched_tract_catalog.DiffMatchedTractCatalogTask
        config:
          columns_target_coord_err: ['xErr', 'yErr']
          coord_format.coords_ref_to_convert: {'ra': 'x', 'dec': 'y'}
    
          python: |
            from lsst.pipe.tasks.diff_matched_tract_catalog import MatchedCatalogFluxesConfig
            columns_flux = {}
            for band in 'ugrizy':
                columns_flux[band] = MatchedCatalogFluxesConfig(
                    column_ref_flux=f'flux_{band}',
                    columns_target_flux=[f'{band}_cModelFlux',],
                    columns_target_flux_err=[f'{band}_cModelFluxErr',],
                )
            config.columns_flux = columns_flux
    subsets:
      step1:
        subset:
          - isr
          - characterizeImage
          - calibrate
          - writeSourceTable
          - transformSourceTable
        description: |
          Per-detector tasks that can be run together to start the DRP pipeline.
    
          These may or may not be run with 'tract' or 'patch' as part of the data
          ID expression. This specific pipeline contains no tasks that require full
          visits. Running with 'tract' (and 'patch') constraints will select
          partial visits that overlap that region.
    
          In data release processing, operators should stop to address unexpected
          failures before continuing on to step2.
      step2:
        subset:
          - consolidateSourceTable
          - consolidateVisitSummary
          - isolatedStarAssociation
          - finalizeCharacterization
          - makeCcdVisitTable
          - makeVisitTable
        description: |
          Tasks that can be run together, but only after the 'step1'.
    
          This is a mix of visit-level, tract-level, and collection-level tasks
          that must not be run with any data query constraints other than
          instrument. For example, running with 'tract' (and 'patch') constraints
          will select partial visits that overlap that region.
    
          Visit-level tasks include consolidateSourceTable, consolidateVisitSummary,
          finalizeCharacterization.
          Tract-level tasks include: isolatedStarAssociation
          Full collection-level tasks include: makeCcdVisitTable, makeVisitTable
      step3:
        subset:
          - makeWarp
          - assembleCoadd
          - detection
          - mergeDetections
          - deblend
          - measure
          - mergeMeasurements
          - forcedPhotCoadd
          - transformObjectTable
          - writeObjectTable
          - consolidateObjectTable
          - healSparsePropertyMaps
          - selectGoodSeeingVisits
          - templateGen
        description: |
          Tasks that can be run together, but only after the 'step1' and 'step2'
          subsets.
    
          These should be run with explicit 'tract' constraints essentially all the
          time, because otherwise quanta will be created for jobs with only partial
          visit coverage.
    
          It is expected that many forcedPhotCcd quanta will "normally" fail when
          running this subset, but this isn't a problem right now because there are
          no tasks downstream of it.  If other tasks regularly fail or we add tasks
          downstream of forcedPhotCcd, these subsets or the tasks will need
          additional changes.
    
          This subset is considered a workaround for missing middleware and task
          functionality.  It may be removed in the future.
      step4:
        subset:
          - forcedPhotCcd
          - forcedPhotDiffim
          - getTemplate
          - subtractImages
          - detectAndMeasureDiaSources
          - transformDiaSourceCat
          - writeForcedSourceTable
        description: |
          Tasks that can be run together, but only after the 'step1', 'step2' and
          'step3' subsets
    
          These detector-level tasks should not be run with 'tract' or 'patch' as
          part of the data ID expression if all reference catalogs or diffIm
          templates that cover these detector-level quanta are desired.
      step5:
        subset:
          - drpAssociation
          - drpDiaCalculation
          - forcedPhotCcdOnDiaObjects
          - forcedPhotDiffOnDiaObjects
          - transformForcedSourceTable
          - consolidateForcedSourceTable
          - consolidateAssocDiaSourceTable
          - consolidateFullDiaObjectTable
          - writeForcedSourceOnDiaObjectTable
          - transformForcedSourceOnDiaObjectTable
          - consolidateForcedSourceOnDiaObjectTable
        description: |
          Tasks that can be run together, but only after the 'step1', 'step2',
          'step3', and 'step4' subsets
    
          This step includes patch-level aggregation Tasks. These should be run
          with explicit 'tract' constraints in the data query, otherwise quanta
          will be created for jobs with only partial visit coverage.
          'consolidateForcedSourceTable' is a tract-level task that aggregates
          patches and should be rerun if any of the patches fail.
      step6:
        subset:
          - consolidateDiaSourceTable
        description: |
          Tasks that can be run together, but only after the 'step1', 'step2',
          'step3', and 'step4' subsets
    
          This step includes visit-level aggregation tasks. Running without tract
          or patch in the data query is recommended, otherwise the outputs of
          consolidateDiaSourceTable will not contain complete visits.
    
          This subset is separate from step4 to signal to operators to pause to
          assess unexpected image differencing failures before these aggregation
          steps. Otherwise, if run in the same quantum graph, aggregated data
          products (e.g. diaObjects) would not be created if one or more of the
          expected inputs is missing.
      step7:
        subset:
          - consolidateHealSparsePropertyMaps
        description: |
          Tasks that should be run as the final step that require global inputs,
          and can be run after the 'step3' subset.
    
          This step has global aggregation tasks to run over all visits, detectors,
          tracts, etc.  This step should be run only with the instrument constraint
          in the data query.
      faro_all:
        subset:
          # visit-level on single-frame products
          - nsrcMeasVisit
          - TE3
          - TE4
          # tract-level, matched-visit on single-frame products
          - matchCatalogsTract
          - matchCatalogsPatch
          - matchCatalogsPatchMultiBand
          - matchCatalogsTractMag17to21p5
          - matchCatalogsTractStarsSNR5to80
          - matchCatalogsTractGxsSNR5to80
          - PA1
          - PF1_design
          - AM1
          - AM2
          - AM3
          - AD1_design
          - AD2_design
          - AD3_design
          - AF1_design
          - AF2_design
          - AF3_design
          - AB1
          - modelPhotRepGal1
          - modelPhotRepGal2
          - modelPhotRepGal3
          - modelPhotRepGal4
          - modelPhotRepStar1
          - modelPhotRepStar2
          - modelPhotRepStar3
          - modelPhotRepStar4
          - psfPhotRepStar1
          - psfPhotRepStar2
          - psfPhotRepStar3
          - psfPhotRepStar4
          # tract-level on coadd products
          - matchObjectToTruth
          - compareObjectToTruth
          - TE1
          - TE2
          - wPerp
          - skyObjectMean
          - skyObjectStd
        description: |
          Set of tasks for calculation of metrics via faro.
          These tasks are a mix of visit- and tract-level.
    
          Tasks that require single-frame products use Calibrated Source Tables,
          which are available after consolidateSourceTable (step2).
          Tasks that require coadd products use Object Tables which are available
          after consolidateObjectTable (step3).
          
2.2. Edit the YAML pipeline definition for making custom coadds

That's a lot of pipeline definition YAML! Luckily, it's only necessary for your purposes to be concerned with the ``step3`` (coadd-level processing) portion of the pipeline definition, which is shown below.

.. code-block::

      step3:
        subset:
          - makeWarp
          - assembleCoadd
          - detection
          - mergeDetections
          - deblend
          - measure
          - mergeMeasurements
          - forcedPhotCoadd
          - transformObjectTable
          - writeObjectTable
          - consolidateObjectTable
          - healSparsePropertyMaps
          - selectGoodSeeingVisits
          - templateGen

Hopefully you're in whatever working directory on RSP you've chosen to be the place from which you will run the custom coadd processing. It is somewhat of a convention to put pipeline configuration files in a subdirectory named `config`. So let's make that `config` subdirectory:

.. code-block::

    mkdir config
    
Let's not modify the original ``$DRP_PIPE_DIR/ingredients/LSSTCam-imSim/DRP.yaml`` file in place, but rather bring in a copy to the newly made `config` directory. We will then edit this copy to customize it for the desired coaddition.

.. code-block::

    cp $DRP_PIPE_DIR/ingredients/LSSTCam-imSim/DRP.yaml config/makeWarpAssembleCoadd.yaml
    
Note that in doing this copy you've given the resulting file a name of `makeWarpAssembleCoadd.yaml`, which better reflects its purpose than would simply ``DRP.yaml``.

Now let's edit your ``config/makeWarpAssembleCoadd.yaml`` pipeline definition file. There are multiple ways to edit a text file in a Linux environment, such as `nano <https://www.nano-editor.org/>`_, `emacs <https://www.gnu.org/software/emacs/>`_, and `vim <https://www.vim.org/>`_, all of which are available to you at the RSP terminal. As an example, here is the relevant nano command:

.. code-block::

    nano config/makeWarpAssembleCoadd.yaml

Whatever editor you've chosen, edit the ``step3`` section shown above so that only the ``makeWarp`` and ``assembleCoadd`` tasks remain:

.. code-block::

      step3:
        subset:
          - makeWarp
          - assembleCoadd

Make sure to save your changes when you exit the text editor! Also make sure that you did not change any of the indentation in the ``config/makeWarpAssembleCoadd.yaml`` file, for the lines that remain.

To arrive at the above ``step3`` YAML, you should have deleted exactly 12 lines worth of YAML tasks from the material originally contained in ``DRP.yaml``. You can check exactly what you changed using the Linux command ``diff``, which prints out the difference between two files. The following shows the expected ``diff`` results for proper editing of the YAML pipeline definition:

.. code-block::

    diff $DRP_PIPE_DIR/ingredients/LSSTCam-imSim/DRP.yaml config/makeWarpAssembleCoadd.yaml 
    116,127d115
    <       - detection
    <       - mergeDetections
    <       - deblend
    <       - measure
    <       - mergeMeasurements
    <       - forcedPhotCoadd
    <       - transformObjectTable
    <       - writeObjectTable
    <       - consolidateObjectTable
    <       - healSparsePropertyMaps
    <       - selectGoodSeeingVisits
    <       - templateGen

The lines starting with ``<`` symbols indicate lines that were deleted from ``$DRP_PIPE_DIR/ingredients/LSSTCam-imSim/DRP.yaml``. Now you're ready to start running some ``pipetask`` commands at the terminal!

Step 3. Show your pipeline and its configurations
=================================================

3.1 Choose an output collection name/location

.. probably want to change where this appears relative to other items, figure out later

Some of the ``pipetask`` commands later in this tutorial require you to specify an output collection where your new coadds will eventually be written to. As described in the notebook version of tutorial 9a, you want to name your output collection as something like ``u/<Your User Name>/<Collection Identifier>``. As an concrete example, throughout the rest of this tutorial ``u/ameisner/custom_coadd_window1_cl00`` is used as the collection name.

3.2 Build your custom-defined pipeline

``pipetask`` commands are provided as part of the LSST Science Pipelines software stack and are used to build, visualize, and run processing pipelines from the terminal. Let's not jump straight into running the pipeline, but rather start by checking whether the pipeline will even ``build``. To ``build`` a pipeline, you use a command starting with ``pipetask build`` and specify an argument telling ``pipetask`` which specific YAML pipeline definition file you want it to build. If there are syntax or other errors in the YAML file's pipeline definition, then ``pipetask build`` will fail with an error about the problem. If ``pipetask build`` succeeds, it will run without generating errors and print a YAML version of the pipeline to standard out. Here is the exact syntax:

.. code-block::

    pipetask build \
    -p config/makeWarpAssembleCoadd.yaml#step3 \
    --show pipeline
    
This is all one single terminal (shell) command, but spread out over three input lines using ``\`` for line continuation. It would be entirely equivalent to run:

.. code-block::

    pipetask build -p config/makeWarpAssembleCoadd.yaml#step3 --show pipeline
    
Separating out each ``pipetask`` input can sometimes result in easier debugging, as it is easy to see exactly what input was specified for each ``pipetask`` parameter.

The ``-p`` parameter of ``pipetask`` is short for ``--pipeline`` and it is critical that this parameter be specified as the new ``config/makeWarpAssembleCoadd.yaml`` file made in section 2.2. It is also critical that the ``-p`` argument contain the string ``#step3`` appended at the end of the config file name. This is because you want to only run the coaddition step to make custom coadds (other steps like ``step1`` have to do with reducing the single-frame images, which isn't relevant). Here's what running the command, and its output should look like:

.. code-block::

    pipetask build -p config/makeWarpAssembleCoadd.yaml#step3 --show pipeline
    description: DRP specialized for ImSim-DC2 data
    instrument: lsst.obs.lsst.LsstCamImSim
    tasks:
      makeWarp:
        class: lsst.pipe.tasks.makeWarp.MakeWarpTask
        config:
        - makePsfMatched: true
      assembleCoadd:
        class: lsst.pipe.tasks.assembleCoadd.CompareWarpAssembleCoaddTask
        config:
        - doInputMap: true
    subsets:
      step3:
        subset:
        - makeWarp
        - assembleCoadd
        description: |
          Tasks that can be run together, but only after the 'step1' and 'step2'
          subsets.
    
          These should be run with explicit 'tract' constraints essentially all the
          time, because otherwise quanta will be created for jobs with only partial
          visit coverage.
    
          It is expected that many forcedPhotCcd quanta will "normally" fail when
          running this subset, but this isn't a problem right now because there are
          no tasks downstream of it.  If other tasks regularly fail or we add tasks
          downstream of forcedPhotCcd, these subsets or the tasks will need
          additional changes.
    
          This subset is considered a workaround for missing middleware and task
          functionality.  It may be removed in the future.

``pipetask --help`` provides a bunch of documentation about ``pipetask``.

3.3 Customize and inspect the coaddition configurations

As mentioned in tutorial notebook 9a, there are a couple of specific coaddition configuration parameters that need to be set in order to accomplish the desired custom coaddition. In detail, two ``makeWarp`` task needs two of its configuration parameters configured: ``doApplyFinalizedPsf`` and ``connections.visitSummary``. First, let's try an experiment of simply finding out what the default value of ``doApplyFinalizedPsf``, so that you can appreciate the results of having modified this parameteter later on. To view the configuration parameters, you need to use a ``pipetask run`` command, not a ``pipetask build`` command. The command used is shown here, and will be explained below:

.. code-block::

    pipetask run \
    -b dp02 \
    -p config/makeWarpAssembleCoadd.yaml#step3 \
    --show config=makeWarp::doApplyFinalizedPsf
    
Notice that the ``-p`` parameter passed to ``pipetask`` has remained the same. But in order for ``pipetask run`` to operate, it also needs to know what Butler repository it's dealing with. That's why the `-b dp02` argument has been added. `dp02` is an alias that points to the S3 location of the DP0.2 Butler repository.

The final line merits further explanation. ``--show config`` tells the LSST pipelines not to actually run the pipeline, but rather to only show the configuration parameters, so that you can understand all the detailed choices being made by your processing, if desired. The last line would be valid as simply ``--show config``. However, this would print out every single configuration parameter and its description -- more than 1300 lines of printouts in total! Appending ``=<Task>::<Parameter>`` to ``--show config`` specifies exactly which parameter you want to be shown. In this case, it's known from tutorial notebook 9a that you want to adjust the ``doApplyFinalizedPsf`` parameter of the ``makeWarp`` Task, hence why ``makeWarp::doApplyFinalizedPsf`` is appended to ``--show config``.

Now let's look at what happens when you run the above ``pipetask command``:

.. code-block::

    pipetask run \
    > -b dp02 \
    > -p config/makeWarpAssembleCoadd.yaml#step3 \
    > --show config=makeWarp::doApplyFinalizedPsf
    Matching "doApplyFinalizedPsf" without regard to case (append :NOIGNORECASE to prevent this)
    ### Configuration for task `makeWarp'
    # Whether to apply finalized psf models and aperture correction map.
    config.doApplyFinalizedPsf=True
    No quantum graph generated or pipeline executed. The --show option was given and all options were processed.
    
Ignore the lines about "No quantum graph" and "NOIGNORECASE" -- for the present purposes, these can be considered non-fatal warnings. The line that starts with ``###`` specificies that ``pipetask run`` is showing us a parameter of the ``makeWarp`` Task (as opposed to some other task, like ``assembleCoadd``). The line that starts with ``#`` provides the plain English description of the parameter that you requested to be shown. The line following the plain English description of ``doApplyFinalizedPsf`` shows this parameter's default value, which is a boolean equal to ``True``. From tutorial notebook 9a, you know that it's necessary to change ``doApplyFinalizedPsf`` to ``False`` i.e., the opposite of its default value. Let's see how this plays out in practice. The following modified ``pipetask run`` command adds one extra input parameter for the custom ``doApplyFinalizedPsf`` setting:

.. code-block::

    pipetask run \
    -b dp02 \
    -p config/makeWarpAssembleCoadd.yaml#step3 \
    -c makeWarp:doApplyFinalizedPsf=False \
    --show config=makeWarp::doApplyFinalizedPsf
    
The penultimate line (``-c makeWarp:doApplyFinalizedPsf=False \``) is newly added. The ``-c`` parameter of ``pipetask run`` (note the lower case ``c``) can be used to specify a desired value of a given parameter, with argument syntax of ``<Task>:<Parameter>=<Value>``. In this case, the Task is ``makeWarp``, the parameter is ``doApplyFinalizedPsf``, and the desired value is ``False``. Now find out if you succeeded in changing the configuration, by looking at the printouts generated from running the above command:

.. code-block::

    pipetask run \
    > -b dp02 \
    > -p config/makeWarpAssembleCoadd.yaml#step3 \
    > -c makeWarp:doApplyFinalizedPsf=False \
    > --show config=makeWarp::doApplyFinalizedPsf
    Matching "doApplyFinalizedPsf" without regard to case (append :NOIGNORECASE to prevent this)
    ### Configuration for task `makeWarp'
    # Whether to apply finalized psf models and aperture correction map.
    config.doApplyFinalizedPsf=False

    No quantum graph generated or pipeline executed. The --show option was given and all options were processed.
    
Notice that the printed configuration parameter value is indeed ``False`` i.e., not the default value...great! The second configuration parameter that we need to change can be passed to ``pipetask run`` in the exact same way, by simply adding a second ``-c`` argument whose line in the full shell command would look like

.. code-block::

    -c makeWarp:connections.visitSummary="visitSummary" \
    
Step 3. Explore and Visualize the QuantumGraph
==============================================

Before actually deploying the custom coaddition, let's take some time to understand the ``QuantumGraph`` of the processing to be run. The ``QuantumGraph`` is a tool used by the LSST Science Pipelines to break a large processing into relatively "bite-sized" ``quanta`` and arrange these quanta into a sequence such that all inputs needed by a given ``quantum`` are available for the execution of that ``quantum``. In the present case, you will not be doing an especially large processing, but for production deployments it makes sense to inspect and validate the ``QuantumGraph`` before proceeding straight to full-scale processing launch. It is a valuable practice to validate your ``QuantumGraph`` before generating a bunch of outputs.

So far, you've seen ``pipetask build`` and ``pipetask run``. For the ``QuantumGraph``, you'll use another ``pipetask`` variant, ``pipetask qgraph``. ``pipetask qgraph`` determines the full list of ``quanta`` that your processing will entail, so at this stage its important to bring in the query constraints that specify what subset of DP0.2 will be analyzed. This information is already available from notebook tutorial 9a. In detail, you want to make a coadd only for ``patch=4431``, ``tract=17`` of the ``DC2`` ``skyMap``, and only using a particular set of 6 input exposures drawn from a desired temporal interval (``visit`` = 919515, 924057, 924085, 924086, 929477, 930353). Tutorial notebook 9a also provides a translation of these constraints into Butler query syntax as:

.. code-block::

    tract = 4431 AND patch = 17 AND visit in (919515,924057,924085,924086,929477,930353) AND skymap = 'DC2'
    
3.1 How many ``quanta``?

Tutorial notebook 9a shows that the desired custom coaddition entails executing 7 ``quanta`` (6 for ``makeWarp`` -- one per input exposure -- plus one for ``assembleCoadd``). Hopefully the command line version of this processing has the same number (and list) of ``quanta``! Let's check. Here's the ``pipetask qgraph`` command to use:

.. code-block::

    pipetask qgraph \
    -b dp02 \
    -i 2.2i/runs/DP0.2 \
    -p config/makeWarpAssembleCoadd.yaml#step3 \
    -c makeWarp:doApplyFinalizedPsf=False \
    -c makeWarp:connections.visitSummary="visitSummary" \
    -d "tract = 4431 AND patch = 17 AND visit in (919515,924057,924085,924086,929477,930353) AND skymap = 'DC2'"
    
Note a few things about this command:

* the command starts out with ``pipetask qgraph`` rather than ``pipetask run`` or ``pipetask build``

* the input data set collection (DP0.2) is specified via the argument ``-i 2.2i/runs/DP0.2``. It's necessary to know about the input collection in order for ``pipetask`` and Butler to figure out how many (and which) ``quanta`` are expected.

* The same custom pipeline as always is specified, ``-p config/makeWarpAssembleCoadd.yaml#step3 \``.

* `-c` is used twice, to override the default configuration parameter settings for both ``doApplyFinalizedPsf=False`` and ``connections.visitSummary``.

* The query string has speen specified via the `-d` argument of ``pipetask``.


