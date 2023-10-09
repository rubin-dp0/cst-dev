LOGFILE=$LOGDIR/det_deblend_thresh_noreg_meas_noref.log; \
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
-p nb9b_det_deblend_meas.yaml#detection,deblend_single,measure \
-d "tract = 4431 AND patch = 17 AND band = 'i' AND skymap = 'DC2'"; \
date | tee -a $LOGFILE
