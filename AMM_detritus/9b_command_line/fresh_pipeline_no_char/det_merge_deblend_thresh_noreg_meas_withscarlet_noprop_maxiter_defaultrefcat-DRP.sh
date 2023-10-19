LOGFILE=$LOGDIR/det_merge_deblend_thresh_noreg_meas_withscarlet_noprop_maxiter_defaultrefcat-DRP.log; \
date | tee $LOGFILE; \
pipetask --long-log --log-file $LOGFILE run \
-b dp02 \
-i u/$USER/custom_coadd_window1_test1,2.2i/runs/DP0.2 \
-o u/$USER/custom_coadd_window1_test1_O \
-c detection:detection.thresholdValue=10 \
-c detection:detection.thresholdType="stdev" \
-c deblend:multibandDeblend.maxIter=20 \
-c measure:doPropagateFlags=False \
-p $DRP_PIPE_DIR/pipelines/LSSTCam-imSim/DRP-test-med-1.yaml#detection,mergeDetections,deblend,measure \
-d "tract = 4431 AND patch = 17 AND band = 'i' AND skymap = 'DC2'"; \
date | tee -a $LOGFILE
