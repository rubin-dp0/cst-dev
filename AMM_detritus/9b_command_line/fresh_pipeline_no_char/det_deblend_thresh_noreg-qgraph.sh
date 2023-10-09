pipetask build -p nb9b_det_deblend.yaml#detection,deblend_single \
--pipeline-dot pipeline.dot; \
dot pipeline.dot -Tpdf > detect_deblend.pdf  
rm pipeline.dot
