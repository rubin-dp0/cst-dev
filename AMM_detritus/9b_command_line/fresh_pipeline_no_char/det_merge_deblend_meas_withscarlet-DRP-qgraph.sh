rm pipeline.dot

pipetask build \
-p $DRP_PIPE_DIR/pipelines/LSSTCam-imSim/DRP-test-med-1.yaml#detection,mergeDetections,deblend,measure \
--pipeline-dot pipeline.dot; \
dot pipeline.dot -Tpdf > detectionMergeDetectionsDeblendMeasure-DRP.pdf

rm pipeline.dot
