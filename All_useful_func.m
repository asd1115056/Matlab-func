function varargout = All_useful_func(request, varargin)

    switch request
        case 'RMSE'
            [varargout{1:nargout}] = RMSE(varargin{:});
        case 'MED'
            [varargout{1:nargout}] = MED(varargin{:});
        case 'A_RMSE'
            [varargout{1:nargout}] = A_RMSE(varargin{:});
        case 'Draw_Graph'
            [varargout{1:nargout}] = Draw_Graph(varargin{:});
        case 'Func_Run'
            [varargout{1:nargout}] = Func_Run(varargin{:});
        case 'CDF'
            [varargout{1:nargout}] = CDF(varargin{:});

    end

end

function [A] = A_RMSE(Path, load_files_name, value, load_variable_name, simu_round, simu_steps)
    % load_files_name = {'RUKF_Hampel_NoQ', 'RUKF_Huber_NoQ', 'Fuzzy_RUKF_Hampel_NoQ', 'Fuzzy_RUKF_Huber_NoQ'}
    % load_variable_name usually is Irms_x_y
    % simu_round = [begin, end]
    % simu_steps = [begin, end]

    A = [];

    len = size(load_files_name);

    for i = 1:len(2)

        try
            data = load(append(fullfile(Path, load_files_name{1, i}), '_', string(value)), load_variable_name);
            data = data.(load_variable_name)(:, simu_round(1):simu_round(2), simu_steps(1):simu_steps(2));
        catch
            data = NaN(1, simu_round(2) - simu_round(1) + 1, simu_steps(2) - simu_steps(1) + 1);
        end

        o = sqrt(mean(data));
        o = o(:)';

        o = mean(o);
        A = [A; o];
    end

end

function [A] = RMSE(Path, load_files_name, load_variable_name, simu_round, simu_steps)
    % load_files_name = {'RUKF_Hampel_NoQ', 'RUKF_Huber_NoQ', 'Fuzzy_RUKF_Hampel_NoQ', 'Fuzzy_RUKF_Huber_NoQ'}
    % load_variable_name usually is Irms_x_y
    % simu_round = [begin, end]
    % simu_steps = [begin, end]

    A = [];

    len = size(load_files_name);

    for i = 1:len(2)

        try
            data = load(fullfile(Path, load_files_name{1, i}), load_variable_name);
            data = data.(load_variable_name)(:, simu_round(1):simu_round(2), simu_steps(1):simu_steps(2));
        catch err
            disp(err);
            data = NaN(1, simu_round(2) - simu_round(1) + 1, simu_steps(2) - simu_steps(1) + 1);
        end

        for k = 1:(simu_steps(2) - simu_steps(1) + 1)
            o(k) = sqrt(mean(data(:, :, k)));
        end

        A = [A; o];
    end

end

function [A] = MED(Path, load_files_name, load_variable_name, simu_round, simu_steps)
    % load_files_name = {'RUKF_Hampel_NoQ', 'RUKF_Huber_NoQ', 'Fuzzy_RUKF_Hampel_NoQ', 'Fuzzy_RUKF_Huber_NoQ'}
    % load_variable_name usually is Irms_x_y
    % simu_round = [begin, end]
    % simu_steps = [begin, end]

    A = [];

    len = size(load_files_name);

    for i = 1:len(2)

        try
            data = load(fullfile(Path, load_files_name{1, i}), load_variable_name);
            data = data.(load_variable_name)(:, simu_round(1):simu_round(2), simu_steps(1):simu_steps(2));
        catch
            data = NaN(1, simu_round(2) - simu_round(1) + 1, simu_steps(2) - simu_steps(1) + 1);
        end

        sdata(:, :, :) = sqrt(data(:, :, :));

        for k = 1:(simu_steps(2) - simu_steps(1) + 1)
            o(k) = mean(sdata(:, :, k));
        end

        A = [A; o];
    end

end

function CDF(figure_name, x_y_label, Path, load_files_name, load_variable_name, simu_round, simu_steps, lines, other_figure_setting, other_legend_setting, other_setting)
    % load_files_name = {'RUKF_Hampel_NoQ', 'RUKF_Huber_NoQ', 'Fuzzy_RUKF_Hampel_NoQ', 'Fuzzy_RUKF_Huber_NoQ'}
    % load_variable_name usually is Irms_x_y
    % simu_round = [begin, end]
    % simu_steps = [begin, end]

    A = {};

    len = size(load_files_name);

    for i = 1:len(2)

        try
            data = load(fullfile(Path, load_files_name{1, i}), load_variable_name);
            data = data.(load_variable_name)(:, simu_round(1):simu_round(2), simu_steps(1):simu_steps(2));
        catch err
            disp(err);
            data = NaN(1, simu_round(2) - simu_round(1) + 1, simu_steps(2) - simu_steps(1) + 1);
        end

        for k = 1:(simu_steps(2) - simu_steps(1) + 1)
            o(k) = sqrt(mean(data(:, :, k)));
        end

        y = o;
        ymin = 0;
        ymax = 100;
        x = linspace(ymin, ymax, 100);
        yy = hist(y, x) / length(y) / (x(2) - x(1));

        s = 0;

        for i = 2:length(x)
            s = [s, trapz(x([1:i]), yy([1:i]))];
        end

        A = {A; [x; s]};

    end

    figure('name', figure_name);
    set(gca, 'FontSize', other_figure_setting(1));
    box on;

    grid on;
    set(gca, 'GridLineStyle', ':'); % 設置爲虛線
    set(gca, 'GridAlpha', 1);

    xlabel(x_y_label(1));
    ylabel(x_y_label(2));

    hold on;
    len = size(A);

    for i = 1:len(1)
        p = plot(A{i}(1, :), A{i}(2, :));
        p.Color = lines{1}{i, 2};
        p.LineStyle = lines{1}{i, 3};
        p.Marker = lines{1}{i, 4};
        p.LineWidth = lines{2}(1);
        p.MarkerSize = lines{2}(2);
        p.MarkerIndices = 1:lines{2}(3):len(2);

    end

    legend(lines{1}(:, 1)', 'Location', other_legend_setting{1}, 'FontSize', other_legend_setting{2});

    %set(gcf, 'Visible', 'off');
    set(gcf, 'position', [0, 0, 1600, 900]); %設定figure的位置和大小
    set(gcf, 'color', 'white'); %設定figure的背景顏色

    if other_setting{2} == 1
        set(gcf, 'color', 'white', 'paperpositionmode', 'auto'); %保持長寬比&背景顏色儲存圖片
        saveas(gcf, append(other_setting{1}, '.png')); %儲存圖片
    end

    savefig(append(other_setting{1}, '.fig'))

end

function Draw_Graph(figure_name, x_y_label, figure_axis, lines, other_figure_setting, other_legend_setting, other_setting)
    % lines= {line_data,line_visible_parameters,other_line_setting}
    % ex:
    % line_visible_parameters = {
    %                         'FTM-REKF(Huber)', [0.00, 0.00, 1.00], '-', '+';
    %                         'FTM-REKF(Hampel)', [1.00, 0.00, 0.00], '-', 'o';
    %                         'M-REKF(Huber)', [0.48, 0.06, 0.89], '-', 'h';
    %                         'M-REKF(Hampel)', [0.00, 1.00, 0.00], '-', 's';
    %                         'R-IMM', [0.00, 1.00, 1.00], ':', '^';
    %                         'MUR-EKF', [0.60, 0.20, 0.00], '--', 'v';
    %                         'GM-IEKF', [0.00, 0.00, 0.00], ':', 'x';
    %                         };
    % other_line_setting={LineWidth,MarkerSize,MarkerIndices}
    % other_figure_setting={figure_FontSize,grid on}
    % other_legend_setting={location,legend_FontSize}
    % other_setting={savefig_name,save_png}

    figure('name', figure_name);
    set(gca, 'FontSize', other_figure_setting(1));
    box on;

    if other_figure_setting(2) == 1
        grid on;
        set(gca, 'GridLineStyle', ':'); % 設置爲虛線
        set(gca, 'GridAlpha', 1);
    end

    xlabel(x_y_label(1));
    ylabel(x_y_label(2));
    axis(figure_axis);
    hold on;
    len = size(lines{1});

    for i = 1:len(1)
        t = 0:len(2) - 1;
        p = plot(t * other_setting{3}, lines{1}(i, t + 1));
        p.Color = lines{2}{i, 2};
        p.LineStyle = lines{2}{i, 3};
        p.Marker = lines{2}{i, 4};
        p.LineWidth = lines{3}(1);
        p.MarkerSize = lines{3}(2);
        p.MarkerIndices = 1:lines{3}(3):len(2);

    end

    legend(lines{2}(:, 1)', 'Location', other_legend_setting{1}, 'FontSize', other_legend_setting{2});

    %set(gcf, 'Visible', 'off');
    set(gcf, 'position', [0, 0, 1600, 900]); %設定figure的位置和大小
    set(gcf, 'color', 'white'); %設定figure的背景顏色

    if other_setting{2} == 1
        set(gcf, 'color', 'white', 'paperpositionmode', 'auto'); %保持長寬比&背景顏色儲存圖片
        saveas(gcf, append(other_setting{1}, '.png')); %儲存圖片
    end

    savefig(append(other_setting{1}, '.fig'))
end

function Func_Run(runsometing, load_file, save_file_name, load_fis_file_name, missing_data)
    %load_variables = {'BS*', 'TOA*', 'NProb', 'z*', 'N', 'T', 'xact*', 'P1', 'ms', 'TProb', 'Acc', 'Vel', 'load_noise'};
    %All_useful_func('Func_Run', 'FTM_REKF_Hampel', {'measurement', load_variables}, 'FTM_REKF_Hampel')

    %load(load_file_variables{1}, load_file_variables{2}{:})
    load(load_file)

    gamma_r = missing_data;

    if length(load_fis_file_name) ~= 0
        readfis_file_name = load_fis_file_name;
        %fcg2 = readfis(readfis_file_name);
        %disp(readfis_file_name)
    end

    try
        run(runsometing);
        disp('-------------------------');
        disp(datestr(now, 31));
        disp(save_file_name);
        [~, name, ~] = fileparts(save_file_name);
        disp(name);
        disp(append('Load_noise=', load_noise));
        disp(append('Vel=', num2str(Vel), ' ', 'Acc=', num2str(Acc)));
        disp(append('NProb=', num2str(NProb)));
        disp('Finish');
        disp(['Runtime:', num2str(runtime), ' s']);
        disp('-------------------------');
    catch err
        disp(datestr(now, 31));
        disp([save_file_name, '        Error']);
        disp(err);
        disp('-------------------------');
        fid = fopen('log.txt', 'a+');
        fprintf(fid, '\n');
        fprintf(fid, '[%s] %s have error\n', datestr(now, 31), save_file_name);
        fprintf(fid, 'The identifier was:\n%s', err.identifier);
        fprintf(fid, 'There was an error! The message was:\n%s', err.message);
        fprintf(fid, '\n');
        fclose(fid);
    end

end
