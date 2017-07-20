layers = [
    sequenceInputLayer(embeddingDimension)
    lstmLayer( hiddenUnitSize, 'OutputMode', 'last' )
    fullyConnectedLayer( numClasses )
    softmaxLayer()
    classificationLayer() 
];
opts = trainingOptions('sgdm', ...
'InitialLearnRate', 1e-3, ...
'MiniBatchSize', 20, ...
'SequenceLength', 200, ...
'MaxEpochs', 50 ...
);

%%
load emb.mat
load labels.mat
load training.mat
%%
clc
net = trainNetwork(training, temp, layers, opts);