load('predict_input.mat');
load('predict_output.mat');
load('train_input.mat');
load('train_output.mat');
data=[train_input;predict_input];
%��Ϊ��Ҫ�����ݽ���һЩ���������ǰ�ѵ������Ԥ�⼯�ϲ�
sex=[train_output;predict_output];
checkpoint=1600;
%������ǰ1600������ѵ������������ݽ���Ԥ��
std_data=zscore(data);
%��׼��
[coeff,score,latent,tsguared,explained]=pca(data);
%pca��ά
re_train=score(:,1:10);
%ѡȡӰ������10����������Ϊ����pca�ۼƷ���95%
trunc1_train=re_train(1:checkpoint,:);
%������checkpointǰ������ѵ��
trunc1_sex=sex(1:checkpoint,:);
trunc2_train=re_train(checkpoint+1:end,:);
trunc2_sex=sex(checkpoint+1:end,:);
svmstruct=svmtrain(trunc1_train,trunc1_sex);
group=svmclassify(svmstruct,trunc2_train);
count=0
%ͳ��׼ȷ��
for i=1:(size(data,1)-checkpoint)
    if(group(i,1)==sex(i+checkpoint,1))
        count=count+1;
    end
end
count/(size(data,1)-checkpoint)