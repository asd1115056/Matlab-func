
clc
clear

path1 = {'SD NLOS Fixed', 'SD NLOS Change'};
path2 = {'Fixed', 'Markov'};
path3 = {{'robust_gaussian_noise', 'Gaussian'}; {'robust_exprnd_noise', 'Exprnd'}};
path4 = {{0, '0vel'}; {4, '4vel'}};
path5 = {{0.25 0.25 0.25 0.25 0.25, '0.25 0.25 0.25 0.25 0.25'}; {0.50 0.50 0.50 0.50 0.50, '0.50 0.50 0.50 0.50 0.50'}; {0.75 0.75 0.75 0.75 0.75, '0.75 0.75 0.75 0.75 0.75'}; {1 1 1 1 1, '1 1 1 1 1'}; {0.75 0.25 1 0.75 0.50, '0.75 0.25 1 0.75 0.50'}; {0 0 0 0 0, '0 0 0 0 0'}; {0.25 0.50 0.50 0.25 0.75, '0.25 0.50 0.50 0.25 0.75'}};

% 得知當前絕對路徑與資料夾的名稱
[Dir, name, ext] = fileparts(pwd);
name = append(name, ext);
% 添加All_useful_func絕對路徑
addpath(Dir);

tic
gg=0;
for n = 1:2
    for m = 1:2
        for j = 1:2 % for nlos type

            for i = 1:2 % for speed

                for l = 1:7 % for 4 different nlos prob


                        Save_Path = fullfile(Dir, name, path1{n}, path2{m}, path3{j}{2}, path4{i}{2}, path5{l}{6});
                        cd (Save_Path) ;
                        files = dir('*.mat');
                        parfor jj = 1:length(files)
                            currentfile = files(jj).name;
                            clearvar(currentfile);
                            %disp("Done");
                        end
                        gg=gg+length(files);
                        disp(append(string(gg),' files ','Finish'));

                end

            end

        end
    end
end
toc

function clearvar(currentfile)
    load(currentfile);
    save_var = {'Acc', 'gaussian_argument', 'load_noise', 'Vel', 'TOA', 'T', 'NProb', 'P1', 'Irms_x_y', 'runtime'};
    %clear('Irmse_x', 'Irmse_y','xact');
    %save(currentfile);
    save (currentfile, save_var{:})
end