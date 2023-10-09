LOGFILE=$LOGDIR/det_deblend_thresh_noreg_meas_noscarlet.log; \
date | tee $LOGFILE; \
pipetask --long-log --log-file $LOGFILE run \
-b dp02 \
-i u/$USER/custom_coadd_window1_test1,2.2i/runs/DP0.2 \
-o u/$USER/custom_coadd_window1_test1_O \
-c detection:detection.thresholdValue=10 \
-c detection:detection.thresholdType="stdev" \
-c measure:inputCatalog="deblendedFlux" \
-c measure:connections.inputCatalog="deepCoadd_deblendedFlux" \
-c measure:connections.scarletCatalog="deepCoadd_deblendedFlux" \
-c measure:connections.refCat="cal_ref_cat_2_2" \
-p nb9b_det_deblend_meas.yaml#detection,deblend_single,measure \
-d "tract = 4431 AND patch = 17 AND band = 'i' AND skymap = 'DC2'"; \
date | tee -a $LOGFILE
