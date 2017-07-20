%%
t = readtable('train.tsv', 'filetype', 'text'); 
train = t.Var3;
labels = t.Var2;

%%

train = lower(train);
train = erasePunctuation(train);
%%
content = strings(length(train), 1); 
for i = 1:length(train)
    content(i) = string(train{i});
end 

%%
len = 200;
splitstrs = strings(len, length(content));
for i = 1:length(content)
    temp = strsplit(content(i)); 
    cur_len = min(len, length(temp)); 
    splitstrs(len - cur_len + 1:len, i) = temp(1:cur_len);
end 
%%
emb = readWordEmbedding('glove.6B.50d.txt');
embeddingDimension = 50; 
sequenceLength = 200; 
hiddenUnitSize = 20; 
numClasses = 6; 
%%
n = 10240;
training = cell(n, 1);
for i = 1:n    
    cur = zeros(embeddingDimension, sequenceLength);
    cur = double(word2vec(emb, splitstrs(:, i))'); 
    cur(isnan(cur)) = 0;
    training{i} = cur; 
end 
%%
temp = zeros(n, 1); 
temp(strcmp('pants-fire', labels(:, 1)))=0;
temp(strcmp('false', labels(:, 1)))=1;
temp(strcmp('barely-true', labels(:, 1)))=2;
temp(strcmp('half-true', labels(:, 1)))=3;
temp(strcmp('mostly-true', labels(:, 1)))=4;
temp(strcmp('true', labels(:, 1)))=5;
temp = categorical(temp)

%%
% architecture. 
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
load training.mat
load labels.mat
load emb.mat
%%
clc
net = trainNetwork(training, temp, layers, opts);

%%

%text =  "One idea being discussed is what one senior administration official directly familiar with the ongoing discussions official called a stick approach to Pakistan rather than a carrot. It could include cutting US assistance to Pakistan and a bolstering of security relationships with India, Pakistan longtime adversary.";
text = erasePunctuation(lower(text)); 
inputs = strsplit(text);
inputs = double(word2vec(emb, inputs))
inputs(isnan(inputs)) = 0;
net.classify(inputs)


isfakenews(text)


