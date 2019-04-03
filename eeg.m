clc;clear;
addpath(genpath('/home/wind/Software/toolbox-master'))
data_dir = '/home/wind/Software/matconvnet-1.0-beta25/data/classification_wf.xlsx';
data = double(xlsread(data_dir));
feature = data(:, 3:end);
label = data(:, 1:2);

rng(1);
val_ratio=1.0/4.0;
[train_set, val_set] = split_set(label(:,1), val_ratio);

train_feature = feature(train_set, :);
train_label = label(train_set, :);
test_feature = feature(val_set, :);
test_label = label(val_set, :);
[train_feature, mean_x, std_x] = normalize_data(train_feature, [], []);
test_feature = normalize_data(test_feature, mean_x, std_x);

%train random fern
fernPrm=struct('S',8,'M',160,'thrr',[-1, 1],'bayes',1);
tic, [ferns,p_train_label]=fernsClfTrain(train_feature,train_label(:,1),fernPrm); toc
tic, p_test_label = fernsClfApply(test_feature, ferns ); toc
e0=mean(p_train_label~=train_label(:,1)); e1=mean(p_test_label~=test_label(:,1));
fprintf('errors trn=%f tst=%f\n',e0,e1);

%train random forest
pTrain={'maxDepth',6, 'F1',10,'H', 3, 'M',100,'minChild',2};
train_feature = single(train_feature);train_label = single(train_label);
test_feature = single(test_feature); test_label = single(test_label);
tic, forest=forestTrain(train_feature, train_label(:,1), pTrain{:}); toc
p_train_label = forestApply(train_feature,forest);
p_test_label = forestApply(test_feature,forest);
e0=mean(p_train_label~=train_label(:,1)); e1=mean(p_test_label~=test_label(:,1));
fprintf('errors trn=%f tst=%f\n',e0,e1);


