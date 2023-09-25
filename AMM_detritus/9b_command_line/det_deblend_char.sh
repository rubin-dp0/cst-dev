LOGFILE=$LOGDIR/detection_deblend_char.log; \
date | tee $LOGFILE; \
pipetask --long-log --log-file $LOGFILE run --register-dataset-types \
-b dp02 \
-i u/$USER/custom_coadd_window1_cl00 \
-o u/$USER/custom_coadd_window1_cl00 \
-c detection:detection.thresholdValue=10 \
-c detection:detection.thresholdType="stdev" \
-p $DRP_PIPE_DIR/pipelines/LSSTCam-imSim/DRP-test-med-1.yaml#characterizeImage,detection,deblend \
-d "tract = 4431 AND patch = 17 AND visit in (919515,924057,924085,924086,929477,930353) AND skymap = 'DC2'"; \
date | tee -a $LOGFILE
