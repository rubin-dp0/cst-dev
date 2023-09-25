pipetask run \
-b dp02 \
-c detection:detection.thresholdValue=10 \
-c detection:detection.thresholdType="stdev" \
-p $DRP_PIPE_DIR/pipelines/LSSTCam-imSim/DRP-test-med-1.yaml#detection \
--show config
