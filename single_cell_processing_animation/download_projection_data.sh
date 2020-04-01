[ ! -d human ] && mkdir human
pushd human
wget -O 2d-coordinates.zip https://transcriptomic-viewer-downloads.s3-us-west-2.amazonaws.com/human/2d-coordinates.zip
unzip -o 2d-coordinates.zip

wget -O sample-annotations.zip https://transcriptomic-viewer-downloads.s3-us-west-2.amazonaws.com/human/sample-annotations.zip
unzip -o sample-annotations.zip

popd

python prepare_data_for_processing.py human/2d_coordinates.csv human/sample_annotations.csv > human/processing_data.json

[ ! -d mouse ] && mkdir mouse
pushd mouse
wget -O 2d-coordinates.zip https://transcriptomic-viewer-downloads.s3-us-west-2.amazonaws.com/mouse/2d-coordinates.zip
unzip -o 2d-coordinates.zip

wget -O sample-annotations.zip https://transcriptomic-viewer-downloads.s3-us-west-2.amazonaws.com/mouse/sample-annotations.zip
unzip -o sample-annotations.zip
popd

python prepare_data_for_processing.py mouse/2d_coordinates.csv mouse/sample_annotations.csv > mouse/processing_data.json
