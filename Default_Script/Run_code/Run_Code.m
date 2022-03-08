clc
clear

% 得知當前絕對路徑與資料夾的名稱
[Dir, name, ext] = fileparts(pwd);
name = append(name, ext);
% 添加All_useful_func絕對路徑
addpath(Dir);

path1 = {'SD NLOS Fixed', 'SD NLOS Change'};
path2 = {'Fixed', 'Markov'};
path3 = {'Gaussian'; 'Exprnd'};
path4 = {{0, '0vel'}; {4, '4vel'}};
path5 = {
    {0 0 0 0 0, '0 0 0 0 0'};
    {0.25 0.25 0.25 0.25 0.25, '0.25 0.25 0.25 0.25 0.25'};
    {0.25 0.50 0.50 0.25 0.75, '0.25 0.50 0.50 0.25 0.75'};
    {0.50 0.50 0.50 0.50 0.50, '0.50 0.50 0.50 0.50 0.50'};
    {0.75 0.25 1 0.75 0.50, '0.75 0.25 1 0.75 0.50'};
    {0.75 0.75 0.75 0.75 0.75, '0.75 0.75 0.75 0.75 0.75'};
    {1 1 1 1 1, '1 1 1 1 1'};
    };

%{"程式檔名","Fuzzzy檔名與位置" }
load_func = {
        {'Test', ''};
        {'Test1', fullfile(Dir, 'Algorithm', 'Test1_Fuzzy')};
        };

tic

for jjj = 1:2 % for Fixed or Markov

    parfor j = 1:2 % for nlos type

        for i = 1:2 % for speed

            for l = 1:7 % for n types different nlos prob

                for K = 1:length(load_func)

                    Save_name = append(Func_name, '_R_10');

                    Func_name = load_func{K}{1};
                    Fuzzy_name = load_func{K}{2};
                    Measurement_Path = fullfile(Dir, 'Env', path1{1}, path2{jjj}, path3{j}, path4{i}{2}, path5{l}{6}, 'measurement_5k');
                    Save_Path = fullfile(Dir, name, path1{1}, path2{jjj}, path3{j}, path4{i}{2}, path5{l}{6}, Save_name);
                    All_useful_func_v1('Func_Run', fullfile(Dir, 'Algorithm', name, Func_name), Measurement_Path, Save_Path, 'LoadFuzzyfile', Fuzzy_name);

                end

            end

        end

    end

end

toc
