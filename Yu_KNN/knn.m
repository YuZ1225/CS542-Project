%% Name Classify through KNN Algorithm

fid = fopen('dtrain - Copy.csv');
train_raw = textscan(fid,'%d%s%s%d', 'Delimiter', ',');
fclose(fid);

%%
% First_train_raw = string(train_raw{2});
% Last_train_raw = string(train_raw{3});
% label_train_raw = train_raw{4};

First_train = string(train_raw{2});
Last_train = string(train_raw{3});
label_train = train_raw{4};

train_len = numel(First_train);

data2num_train = zeros(train_len ,3);

%%
% rng(7);
% k = randperm(train_len);
% a = int32(0.8*train_len);
% b = train_len - a;
% First_train = First_train_raw(k(1:a));
% Last_train = Last_train_raw(k(1:a));
% label_train = label_train_raw(k(1:a));
% data2num_train = zeros(a ,3);

%%
i = 1;

while i <= train_len
    j = 2;
    je = 7; %5
    k = 2;
    ke = 7; %5
    f_len = length(First_train{i});
    l_len = length(Last_train{i});
    data2num_train(i,1) = (First_train{i}(1) - '@')*26^8;
    data2num_train(i,2) = (Last_train{i}(1) - '@')*26^8;
    while j <= f_len && je >= -1
        if First_train{i}(j) == '\'
            j = j+4;
        else
            data2num_train(i,1) = data2num_train(i,1) + (First_train{i}(j) - '`')*26^je;
            j = j+1;
            je = je-1;
        end
    end
    
    while k <= l_len && ke >= -1
        if Last_train{i}(k) == '\'
            k = k+4;
        else
            data2num_train(i,2) = data2num_train(i,2) + (Last_train{i}(k) - '`')*26^ke;
            k = k+1;
            ke = ke-1;
        end
    end
    i = i+1;
end
data2num_train(: ,3) = label_train(:);


fid = fopen('dtest - Copy.csv');
test_raw = textscan(fid,'%d%s%s%d', 'Delimiter', ',');
fclose(fid);

First_test = string(test_raw{2});
Last_test = string(test_raw{3});
label_test = test_raw{4};

test_len = numel(First_test);


data2num_test = zeros(test_len ,3);
i = 1;

%%
% rng(7);
% k = randperm(train_len);
% First_test = First_train_raw(k(a+1:end));
% Last_test = Last_train_raw(k(a+1:end));
% label_test = label_train_raw(k(a+1:end));
% data2num_test = zeros(b ,3);


% First_test = First_train_raw(k(1:a));
% Last_test = Last_train_raw(k(1:a));
% label_test = label_train_raw(k(1:a));
% data2num_test = zeros(a ,3);

%%

while i <= test_len
    j = 2;
    je = 7; %5
    k = 2;
    ke = 7; %5
    f_len = length(First_test{i});
    l_len = length(Last_test{i});
    data2num_test(i,1) = (First_test{i}(1) - '@')*26^8;
    data2num_test(i,2) = (Last_test{i}(1) - '@')*26^8;
    while j <= f_len && je >= -1
        if First_test{i}(j) == '\'
            j = j+4;
        else
            data2num_test(i,1) = data2num_test(i,1) + (First_test{i}(j) - '`')*26^je;
            j = j+1;
            je = je-1;
        end
    end
    
    while k <= l_len && ke >= -1
        if Last_test{i}(k) == '\'
            k = k+4;
        else
            data2num_test(i,2) = data2num_test(i,2) + (Last_test{i}(k) - '`')*26^ke;
            k = k+1;
            ke = ke-1;
        end
    end
    i = i+1;
end
% data2num_test(: ,3) = label_test(:);


%% 2D 74% // 1D last name 78% // 1D first name 81%
% X = data2num_train(:,1:2);
% Y = data2num_train(:,3);
% tmp1 = find(Y == 1);
% tmp2 = find(Y == 0);
% figure;
% scatter(X(tmp1, 1)/(26^8), X(tmp1, 2)/(26^8), 8, 'o', 'r', 'filled')
% hold on
% scatter(X(tmp2, 1)/(26^8), X(tmp2, 2)/(26^8), 5, '+', 'b')
% hold off
% legend('Brazillian', 'Not Brazillian')
% title('Scatter of names in unique numbers')
% xlabel('First name in unique number')
% ylabel('Last name in unique number')
% 
% Mdl = fitcknn(X,Y,'NumNeighbors',1,'Standardize',1);
% X2 = data2num_test(:,1:2);
% % Y2 = data2num_test(:,3);
% i = 0:1:test_len-1;
% lab = zeros(test_len+1,2);
% lab(2:end,1) = i;
% lab(2:end, 2) = predict(Mdl, X2);
% % xxx = find(lab(:) == Y2(:));
% % CCR = length(xxx)/length(X2);
% csvwrite('sample.csv', lab);

%% compare distance in last name or first name(first name first) %82.8 // increase the effective digits to 8 digits we have 83%, no increase.lack of data.
i = 0:1:test_len-1;
lab = zeros(test_len+1,2);
lab(2:end,1) = i;
X_first = data2num_train(:,1);
X_last = data2num_train(:,2);
X2_first = data2num_test(:,1);
X2_last = data2num_test(:,2);
Y = data2num_train(:,3);
[id_tmp1, d1] = knnsearch(X_first, X2_first);
[id_tmp2, d2] = knnsearch(X_last, X2_last);
lab(2:end, 2) = Y(id_tmp1);
tmp = find(d1>d2);
lab(tmp+1, 2) = Y(id_tmp2(tmp));

csvwrite('sample.csv', lab);

%% find nearer point in last name or first name(last name first) 82.2%
% 
% i = 0:1:test_len-1;
% lab = zeros(test_len+1,2);
% lab(2:end,1) = i;
% X_first = data2num_train(:,1);
% X_last = data2num_train(:,2);
% X2_first = data2num_test(:,1);
% X2_last = data2num_test(:,2);
% Y = data2num_train(:,3);
% [id_tmp1, d1] = knnsearch(X_first, X2_first);
% [id_tmp2, d2] = knnsearch(X_last, X2_last);
% lab(2:end, 2) = Y(id_tmp2);
% tmp = find(d1<d2);
% lab(tmp+1, 2) = Y(id_tmp1(tmp));
% 
% csvwrite('sample.csv', lab);




