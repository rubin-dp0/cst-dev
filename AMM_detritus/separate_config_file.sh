LOGFILE=$LOGDIR/makeWarpAssembleCoadd-configfile-logfile.log; \
date | tee $LOGFILE; \
pipetask --long-log --log-file $LOGFILE run --register-dataset-types \
-b dp02 \
-i 2.2i/runs/DP0.2 \
-o u/$USER/custom_coadd_window1_cl00 \
-p $DRP_PIPE_DIR/pipelines/LSSTCam-imSim/DRP-test-med-1.yaml#makeWarp,assembleCoadd \
-C makeWarp:config/makeWarp_config.py \
-d "tract = 4431 AND patch = 17 AND visit in (919515,924057,924085,924086,929477,930353) AND skymap = 'DC2'"; \
date | tee -a $LOGFILE
