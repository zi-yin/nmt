# an tf serving image build from source using sse and avx
docker run -d --name serving_base zi/tensorflow-serving:latest
# alternatively, can use the default serving image
# docker run -d --name serving_base tensorflow/serving
docker cp serving_models/model_consolidated_qa_qd serving_base:/models/model_consolidated_qa_qd
# id 7960533f2a25 is the container for serving_base
docker commit --change "ENV MODEL_NAME model_consolidated_qa_qd" serving_base 7960533f2a25
docker kill serving_base
# d583c3ac45fd is the id for the new image with model baked in
docker tag d583c3ac45fd zi/askme_seqeval_service:latest
# start service
docker run --name serving_8501 -p 8501:8501 zi/askme_seqeval_service
