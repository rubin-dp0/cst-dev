LOGFILE=$LOGDIR/det.log; \
date | tee $LOGFILE; \
pipetask --long-log --log-file $LOGFILE run \
-b dp02 \
-i u/$USER/custom_coadd_window1_test1,2.2i/runs/DP0.2 \
-o u/$USER/custom_coadd_window1_test1_O \
-p nb9b.yaml#detection \
-d "tract = 4431 AND patch = 17 AND band = 'i' AND skymap = 'DC2'"; \
date | tee -a $LOGFILE
