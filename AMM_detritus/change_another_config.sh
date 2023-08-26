# version with nothing overridden, showing ALL relevant config options

pipetask run \
-b dp02 \
-p $DRP_PIPE_DIR/pipelines/LSSTCam-imSim/DRP-test-med-1.yaml#makeWarp,assembleCoadd \
--show config

# version with nothing overridden, showing only the one extra param to be changed

pipetask run \
-b dp02 \
-p $DRP_PIPE_DIR/pipelines/LSSTCam-imSim/DRP-test-med-1.yaml#makeWarp,assembleCoadd \
--show config=assembleCoadd::doFilterMorphological

# version with one other parameter overridden

pipetask run \
-b dp02 \
-c assembleCoadd:doFilterMorphological=True \
-p $DRP_PIPE_DIR/pipelines/LSSTCam-imSim/DRP-test-med-1.yaml#makeWarp,assembleCoadd \
--show config=assembleCoadd::doFilterMorphological

# final pipetask run processing command with this extra config option added as well

export LOGDIR=logs
mkdir $LOGDIR

LOGFILE=$LOGDIR/makeWarpAssembleCoadd-morph-logfile.log; \
date | tee $LOGFILE; \
pipetask --long-log --log-file $LOGFILE run --register-dataset-types \
-b dp02 \
-i 2.2i/runs/DP0.2 \
-o u/$USER/custom_coadd_window1_cl00 \
-p $DRP_PIPE_DIR/pipelines/LSSTCam-imSim/DRP-test-med-1.yaml#makeWarp,assembleCoadd \
-c makeWarp:doApplyFinalizedPsf=False \
-c makeWarp:connections.visitSummary="visitSummary" \
-c assembleCoadd:doFilterMorphological=True \
-d "tract = 4431 AND patch = 17 AND visit in (919515,924057,924085,924086,929477,930353) AND skymap = 'DC2'"; \
date | tee -a $LOGFILE
