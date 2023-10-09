# tried adding the following:
#    -c measure:connections.refCat=None \
# but this failed validation (i think because None is not an acceptable value...)
# "lsst.pex.config.config.FieldValidationError: Field 'connections.refCat' failed validation: Required value cannot be None"

LOGFILE=$LOGDIR/det_deblend_thresh_noreg_meas_noref_noscarlet.log; \
date | tee $LOGFILE; \
pipetask --long-log --log-file $LOGFILE run \
-b dp02 \
-i u/$USER/custom_coadd_window1_test1,2.2i/runs/DP0.2 \
-o u/$USER/custom_coadd_window1_test1_O \
-c detection:detection.thresholdValue=10 \
-c detection:detection.thresholdType="stdev" \
-c measure:doMatchSources=False \
-c measure:doWriteMatchesDenormalized=False \
-c measure:doPropagateFlags=False \
-c measure:inputCatalog="deblendedFlux" \
-c measure:connections.inputCatalog="deepCoadd_deblendedFlux" \
-c measure:connections.scarletCatalog="deepCoadd_deblendedFlux" \
-c measure:connections.refCat="cal_ref_cat_2_2" \
-p nb9b_det_deblend_meas.yaml#detection,deblend_single,measure \
-d "tract = 4431 AND patch = 17 AND band = 'i' AND skymap = 'DC2'"; \
date | tee -a $LOGFILE
