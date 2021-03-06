source="consolidated_qa_qd"
data_dir=../qa_stackoverflow/seq2seq_data/$source
grpc_port=10500
model_type="generative"
model_dir_in=models/model_"$source"
model_dir_out=serving_models/model_"$source"_"$model_type"
port=$(($grpc_port+1))
service_name=serving_$port

pwd=$(pwd)
echo "service_name=$service_name"

docker kill $service_name
docker rm $service_name

# remove old servables; turn this off if old servable is needed
rm -r $model_dir_out/*

python -m nmt.nmt \
    --out_dir=$model_dir_in \
    --export_path=$model_dir_out \
    --ckpt_path=$model_dir_in \
    --infer_mode="beam_search" \
    --beam_width=10 \
    --model=$model_type

docker run --name $service_name -p $port:8501 --mount type=bind,source=$pwd/$model_dir_out,target=/models/model_$source -e MODEL_NAME=model_$source -t tensorflow/serving
# docker run --name $service_name -p $port:8501 --mount type=bind,source=$pwd/$model_dir_out,target=/models/model_$source -e MODEL_NAME=model_$source -t zi/tensorflow-serving:latest

# enables GPU serving
# docker run --name $service_name --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=0 -p $port:8501 --mount type=bind,source=$pwd/$model_dir,target=/models/model_$source -e MODEL_NAME=model_$source -t tensorflow/serving:latest-gpu
