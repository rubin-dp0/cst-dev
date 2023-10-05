pipetask --long-log --log-file $LOGDIR/char.log run \
-b dp02 \
-i u/$USER/custom_coadd_window1_test1,2.2i/runs/DP0.2 \
-o u/$USER/custom_coadd_window1_test1_o \
-c characterizeImage:connections.exposure="deepCoadd" \
-p nb9b.yaml#characterizeImage \
-d "tract = 4431 AND patch = 17 AND band = 'i' AND skymap = 'DC2'"
#date | tee -a $LOGFILE
