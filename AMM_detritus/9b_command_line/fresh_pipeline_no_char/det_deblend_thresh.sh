LOGFILE=$LOGDIR/det_deblend_thresh.log; \
date | tee $LOGFILE; \
pipetask --long-log --log-file $LOGFILE run --register-dataset-types \
-b dp02 \
-i u/$USER/custom_coadd_window1_test1,2.2i/runs/DP0.2 \
-o u/$USER/custom_coadd_window1_test1_O \
-c detection:detection.thresholdValue=10 \
-c detection:detection.thresholdType="stdev" \
-p nb9b_det_deblend.yaml#detection,deblend_single \
-d "tract = 4431 AND patch = 17 AND band = 'i' AND skymap = 'DC2'"; \
date | tee -a $LOGFILE
