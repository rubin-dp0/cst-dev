pipetask build \
-p nb9b_det_deblend_meas-scarlet.yaml#detection,mergeDetections,deblend,measure \
--pipeline-dot pipeline.dot; \
dot pipeline.dot -Tpdf > detectionMergeDetectionsDeblendMeasure.pdf
