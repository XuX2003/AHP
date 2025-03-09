%% 输入判断矩阵
clear; clc
A = input('判断矩阵A=');
A = [1 2 3; 1/2 1 3; 1/3 1/3 1];

%% 第一步：判断矩阵是否为正负反矩阵
% 若方阵满足aij>0且aij*aji=1，则可认为方阵为正负反矩阵
[m, n] = size(A);
if m ~= n
    disp('输入从矩阵不是方阵，无法判断是否为正负反矩阵');
end
is_zffjz = true;
for i = 1: m
    for j = 1: m
        if A(i, j)<0 || A(i, j) * A(j, i) ~= 1
            is_zffjz = false;
            break
        end
    end
end
if is_zffjz
    disp('输入的矩阵为正负反矩阵！');
else
    disp('输入的矩阵不是正负反矩阵！请修正！');
end

%% 第二步：计算权重
%% 方法1：算术平均法
% 1. 将判断矩阵按照列归一化（每一个元素除以其所在列的和）
Sum_A = sum(A); % 按列求和，得到一个行向量
SUM_A = repmat(Sum_A, n, 1);
Stand_A = A ./ SUM_A;

% 2. 将归一化的矩阵按行求和

% 3. 将相加后得到的向量中每个元素除以n即可得到平均权重
disp('算术平均法求权重的结果为：');
disp(sum(Stand_A, 2) / n);

%% 方法2：几何平均法
% 1. 将A的元素按行累乘得到一个新的列向量
Prduct_A = prod(A, 2);

% 2. 将新的向量的每个分量开n次方
Prduct_n_A = Prduct_A .^ (1 / n);

% 3. 对该列向量进行归一化即可得到权重向量
disp('几何平均法求权重的结果为：');
disp(Prduct_n_A ./ sum(Prduct_n_A));

%% 方法3：特征值法
% 1. 求出矩阵A的最大特征值以及其对应的特征向量
[V, D] = eig(A);    %V是特征向量, D是由特征值构成的对角矩阵（除了对角线元素外，其余位置元素全为0）
Max_eig = max(max(D));
[~, c] = find(D == Max_eig, 1);

% 2. 对求出的特征向量进行归一化即可得到我们的权重
disp('特征值法求权重的结果为：');
disp(V(:, c) ./ sum(V(:, c)));

%% 第三步：计算一致性比例CR
CI = (Max_eig - n) / (n - 1);
if n == 2
    disp('二阶判断矩阵，一致性比例CR定义为0。')
else
    RI=[0 0 0.52 0.89 1.12 1.26 1.36 1.41 1.46 1.49 1.52 1.54 1.56 1.58 1.59];  
    %RI最多支持 n = 15
    CR=CI / RI(n);
    disp(['一致性指标CI=', num2str(CI)]);
    disp(['一致性比例CR=', num2str(CR)]);
    if CR < 0.10
        disp('因为CR < 0.10，所以该判断矩阵A的一致性可以接受!');
    else
        disp('注意：CR >= 0.10，因此该判断矩阵A需要进行修改!');
    end
end
