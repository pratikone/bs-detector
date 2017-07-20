function label = isFakeNews(news, url)

filename = 'real.xlsx';
[~,B,~] = xlsread(filename);
x = strcmp(url,B(:,1));
if (any(x))
    label = categorical({'true'}); 

else

    
    persistent net
    persistent emb
    load info.mat
 
    news = erasePunctuation(lower(news));
    inputs = strsplit(news);
    inputs = double(word2vec(emb, inputs));
    inputs(isnan(inputs)) = 0;
    label = net.classify(inputs);

    %disp("Source seems reliable, let's check the news")
end
%{
load training.mat
load labels.mat
load emb.mat
%emb = readWordEmbedding('glove.6B.50d.txt');
embeddingDimension = 50; 
sequenceLength = 200; 
hiddenUnitSize = 20; 
numClasses = 6; 
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
net = trainNetwork(training, temp, layers, opts);
news = erasePunctuation(lower(news)); 
inputs = strsplit(news);
inputs = double(word2vec(emb, inputs));
inputs(isnan(inputs)) = 0;
label = net.classify(inputs);
%}
end