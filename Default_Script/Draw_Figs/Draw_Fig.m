clc;
clearvars

%讀取預設好的axis
fig_border;
Dates = Fig_A;
%-----------------------------------------------------------------------------------------------------------%
%{"讀取檔名","圖Legend顯示的名稱","線顏色(hex)","Line Style"," Line Marker" }
Lines = {
      'Test_file', 'test', '#ff0000', '-', 'o';
      };
path1 = {'SD NLOS Fixed', 'SD NLOS Change'};
path2 = {'Fixed', 'Markov'};
path3 = {'Gaussian', 'Exprnd'};
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
%-----------------------------------------------------------------------------------------------------------%
tic
%-----------------------------------------------------------------------------------------------------------%
% 得知當前絕對路徑與資料夾的名稱
[Dir, name, ext] = fileparts(pwd);
name = append(name, ext);
% 添加All_useful_func絕對路徑
addpath(Dir);

for y = 1:2 % for Fixed or Markov

  for j = 1:2 %for nlos type

    for i = 1:2 %for speed

      parfor l = 1:7 % for n types different nlos prob
        Fig_name = append('RMSE-', path2{y}, ' ', path3{j}, ' ', path4{i}{2}, ' ', path5{l}{6}, '_5k');
        Path = fullfile(Dir, name, path1{1}, path2{y}, path3{j}, path4{i}{2}, path5{l}{6});
        RMSE_test = All_useful_func_v1('RMSE', Path, {Lines{:, 1}}, 'Irms_x_y', [1, 100], [1, 5001]);
        %auto set fig axis
        All_useful_func_v1('Draw_Graph', RMSE_test, Lines, 'x_y_label', {'Time step(n)', 'RMS x-y location error (m)'}, 'Save', "on", 'figure_name', Fig_name);
        %load fig axis from fig_border
        %All_useful_func_v1('Draw_Graph', RMSE_test, Lines, 'LegendLocation', Dates{j, i}{l, 1}, 'figure_axis', [0, 5000, Dates{j, i}{l, 2}, Dates{j, i}{l, 3}], 'x_y_label', {'{\sigma}_{NL} (m)', 'Average RMSE x-y location error (m)'}, 'Save', "on", 'figure_name', Fig_name);
      end

      %movefile('*.png', fullfile(Dir, name, 'fig1', path1{1}, 'RMSE(Ours)', path2{y}, path3{j}, path4{i}{2}))
      %movefile('*.fig', fullfile(Dir, name, 'fig1', path1{1}, 'RMSE(Ours)', path2{y}, path3{j}, path4{i}{2}))

    end

  end

end

close all;

%-----------------------------------------------------------------------------------------------------------%

toc
