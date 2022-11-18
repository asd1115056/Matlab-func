%back up
function varargout = All_useful_func_v1(request, varargin)

  switch request
    case 'RMSE'
      [varargout{1:nargout}] = RMSE(varargin{:});
    case 'MED'
      [varargout{1:nargout}] = MED(varargin{:});
    case 'Draw_Graph'
      [varargout{1:nargout}] = Draw_Graph(varargin{:});
    case 'Func_Run'
      [varargout{1:nargout}] = Func_Run(varargin{:});
    case 'CDF'
      [varargout{1:nargout}] = CDF(varargin{:});
    case 'IP'
      [varargout{1:nargout}] = IP(varargin{:});
    case 'Runtime'
      [varargout{1:nargout}] = Runtime(varargin{:});

  end

end

function bb = IP(Path, load_files_name, varargin)
  p = inputParser;

  addRequired(p, 'Path');
  addRequired(p, 'load_files_name');

  parse(p, Path, load_files_name, varargin{:});

  len = size(p.Results.load_files_name);

  A = [];

  for i = 1:len(2)

    data = load(fullfile(p.Results.Path, p.Results.load_files_name{1, i}), 'Irms_x_y');
    data = data.('Irms_x_y');

    len1 = size(data);

    if (len1(2)) == 1

      for k = 1:len1(3)
        o(k) = sqrt(data(:, :, k));
      end

    else

      for k = 1:len1(3)
        o(k) = sqrt(mean(data(:, :, k)));
      end

    end

    o = sum(o);

    A = [A; o];

  end

  bb = [];

  for iii = 1:len(2)
    temp = 100 * (1 - (A(1, 1) / A(iii, 1)));
    disp(append(p.Results.load_files_name{1, iii}, ' IP: ', string(temp), ' %'));
    bb = [bb; temp];
  end

  disp(' ');

end

function Runtime(Path, load_files_name, varargin)
  p = inputParser;

  addRequired(p, 'Path');
  addRequired(p, 'load_files_name');

  parse(p, Path, load_files_name, varargin{:});

  len = size(p.Results.load_files_name);

  for i = 1:len(2)

    data = load(fullfile(p.Results.Path, p.Results.load_files_name{1, i}), 'runtime');
    data = data.('runtime');
    data = append(string(data), 's');

    disp([p.Results.load_files_name{1, i}, 'Runtime:', data]);

  end

end

function [A] = CDF(Path, load_files_name, load_variable_name, simu_round, simu_steps, varargin)
  % load_files_name = {'RUKF_Hampel_NoQ', 'RUKF_Huber_NoQ', 'Fuzzy_RUKF_Hampel_NoQ', 'Fuzzy_RUKF_Huber_NoQ'}
  % load_variable_name usually is Irms_x_y
  % simu_round = [begin, end]
  % simu_steps = [begin, end]

  p = inputParser;

  addRequired(p, 'Path');
  addRequired(p, 'load_files_name');
  addRequired(p, 'load_variable_name');
  addRequired(p, 'simu_round');
  addRequired(p, 'simu_steps');

  parse(p, Path, load_files_name, load_variable_name, simu_round, simu_steps, varargin{:});

  len = size(p.Results.load_files_name);

  for iii = 1:len(2)

    try
      data = load(fullfile(p.Results.Path, p.Results.load_files_name{1, iii}), p.Results.load_variable_name);
      data = data.(load_variable_name)(:, p.Results.simu_round(1):p.Results.simu_round(2), p.Results.simu_steps(1):p.Results.simu_steps(2));
    catch err
      disp(err);
      data = NaN(1, p.Results.simu_round(2) - p.Results.simu_round(1) + 1, p.Results.simu_steps(2) - p.Results.simu_steps(1) + 1);
    end

    if (p.Results.simu_round(2) - p.Results.simu_round(1) + 1) == 1

      for k = 1:(p.Results.simu_steps(2) - p.Results.simu_steps(1) + 1)
        o(k) = sqrt(data(:, :, k));
      end

    else

      for k = 1:(p.Results.simu_steps(2) - p.Results.simu_steps(1) + 1)
        o(k) = sqrt(mean(data(:, :, k)));
      end

    end

    y = o;
    ymin = 0;
    ymax = 100;
    x = linspace(ymin, ymax, 100);
    yy = hist(y, x) / length(y) / (x(2) - x(1));

    s = 0;

    for ii = 2:length(x)
      s = [s, trapz(x([1:ii]), yy([1:ii]))];
    end

    A{iii, 1} = x;
    A{iii, 2} = s;
  end

end

function Draw_Graph(DateInput, Lines, varargin)

  p = inputParser;

  if ~iscell(DateInput)
    YY = length(DateInput(1, :));

    %     if isfinite(DateInput(1, 1))
    MarkerIndicesDefault = (YY - 1) / 50;
    %     else
    %       MarkerIndicesDefault = 1;
    %     end

    FontSizeDefault = 20;
    x_y_labelDefault = ["", ""];
    figure_axisDefault = [, ];
    LineWidthDefault = 3;
    MarkerSizeDefault = 15;
    LegendLocationDefault = 'best';
    SaveDefault = "off";
    figure_nameDefault = '';
    figure_sizeDefault = "auto";

    is_sempty = @(x) (x);

    addRequired(p, 'DateInput');
    addRequired(p, 'Lines');
    addParameter(p, 'FontSize', FontSizeDefault);
    addParameter(p, 'x_y_label', x_y_labelDefault);
    addParameter(p, 'figure_axis', figure_axisDefault);
    addParameter(p, 'LineWidth', LineWidthDefault);
    addParameter(p, 'MarkerSize', MarkerSizeDefault);
    addParameter(p, 'MarkerIndices', MarkerIndicesDefault);
    addParameter(p, 'LegendLocation', LegendLocationDefault);
    addParameter(p, 'Save', SaveDefault);
    addParameter(p, 'figure_name', figure_nameDefault);
    addParameter(p, 'figure_size', figure_sizeDefault);

    parse(p, DateInput, Lines, varargin{:});

    figure('name', p.Results.figure_name);
    set(gca, 'FontSize', p.Results.FontSize);
    box on;

    if ~isempty(p.Results.figure_axis)
      axis(p.Results.figure_axis);
    end

    xlabel(p.Results.x_y_label(1));
    ylabel(p.Results.x_y_label(2));

    hold on;

    len = size(p.Results.DateInput);

    switch_sd_or_rmse = 0;
    DDD = isnan(p.Results.DateInput(:, 1));
    DDD = sum(DDD);

    if DDD == len(1)
      switch_sd_or_rmse = 1;
    end

    for i = 1:len(1)
      t = 0:len(2) - 1;

      if switch_sd_or_rmse == 0
        c = plot(t, p.Results.DateInput(i, t + 1));
      else
        Z = isfinite(p.Results.DateInput(i, t + 1));
        VVV = p.Results.DateInput(i, t + 1);
        c = plot(t(Z), VVV(Z));
      end

      c.Color = p.Results.Lines{i, 3};
      c.LineStyle = p.Results.Lines{i, 4};
      c.Marker = p.Results.Lines{i, 5};
      c.LineWidth = p.Results.LineWidth;
      c.MarkerSize = p.Results.MarkerSize;
      c.MarkerIndices = 1:p.Results.MarkerIndices:YY;

    end

  else
    FontSizeDefault = 20;
    x_y_labelDefault = ["", ""];
    figure_axisDefault = [, ];
    LineWidthDefault = 3;
    MarkerSizeDefault = 15;
    LegendLocationDefault = 'best';
    SaveDefault = "off";
    figure_nameDefault = '';
    MarkerIndicesDefault = 1;
    figure_sizeDefault = "auto";

    is_sempty = @(x) (x);

    addRequired(p, 'DateInput');
    addRequired(p, 'Lines');
    addParameter(p, 'FontSize', FontSizeDefault);
    addParameter(p, 'x_y_label', x_y_labelDefault);
    addParameter(p, 'figure_axis', figure_axisDefault);
    addParameter(p, 'LineWidth', LineWidthDefault);
    addParameter(p, 'MarkerSize', MarkerSizeDefault);
    addParameter(p, 'MarkerIndices', MarkerIndicesDefault);
    addParameter(p, 'LegendLocation', LegendLocationDefault);
    addParameter(p, 'Save', SaveDefault);
    addParameter(p, 'figure_name', figure_nameDefault);
    addParameter(p, 'figure_size', figure_sizeDefault);

    parse(p, DateInput, Lines, varargin{:});

    figure('name', p.Results.figure_name);
    set(gca, 'FontSize', p.Results.FontSize);
    box on;

    grid on;
    set(gca, 'GridLineStyle', ':'); % 設置爲虛線
    set(gca, 'GridAlpha', 1);

    if ~isempty(p.Results.figure_axis)
      axis(p.Results.figure_axis);
    end

    xlabel(p.Results.x_y_label(1));
    ylabel(p.Results.x_y_label(2));

    hold on;

    temp = p.Results.DateInput;

    len = size(temp);
    len2 = size(temp{1, 1});

    for i = 1:len(1)
      t = 1:len2(2);
      c = plot(p.Results.DateInput{i, 1}(t), p.Results.DateInput{i, 2}(t));
      c.Color = p.Results.Lines{i, 3};
      c.LineStyle = p.Results.Lines{i, 4};
      c.Marker = p.Results.Lines{i, 5};
      c.LineWidth = p.Results.LineWidth;
      c.MarkerSize = p.Results.MarkerSize;
      c.MarkerIndices = 1:p.Results.MarkerIndices:len2(2);
    end

  end

  legend({p.Results.Lines{:, 2}}', 'Location', p.Results.LegendLocation, 'FontSize', p.Results.FontSize);

  %set(gcf, 'position', [50, 50, 1280, 720]); %設定figure的位置和大小
  set(gcf, 'position', [50, 50, 1080, 720]); %設定figure的位置和大小
  set(gcf, 'color', 'white'); %設定figure的背景顏色
  %set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [50 50 10 6]);

  if p.Results.Save ~= "off"
    set(gcf, 'color', 'white', 'paperpositionmode', 'auto'); %保持長寬比&背景顏色儲存圖片
    saveas(gcf, append(p.Results.figure_name, '.png')); %儲存圖片
    savefig(append(p.Results.figure_name, '.fig'))
  end

end

function [A] = MED(Path, load_files_name, load_variable_name, simu_round, simu_steps, varargin)
  % load_files_name = {'RUKF_Hampel_NoQ', 'RUKF_Huber_NoQ', 'Fuzzy_RUKF_Hampel_NoQ', 'Fuzzy_RUKF_Huber_NoQ'}
  % load_variable_name usually is Irms_x_y
  % simu_round = [begin, end]
  % simu_steps = [begin, end]

  p = inputParser;

  addRequired(p, 'Path');
  addRequired(p, 'load_files_name');
  addRequired(p, 'load_variable_name');
  addRequired(p, 'simu_round');
  addRequired(p, 'simu_steps');

  parse(p, Path, load_files_name, load_variable_name, simu_round, simu_steps, varargin{:});

  A = [];

  len = size(p.Results.load_files_name);

  for i = 1:len(2)

    try
      data = load(fullfile(p.Results.Path, p.Results.load_files_name{1, i}), p.Results.load_variable_name);
      data = data.(load_variable_name)(:, p.Results.simu_round(1):p.Results.simu_round(2), p.Results.simu_steps(1):p.Results.simu_steps(2));
    catch err
      disp(err);
      data = NaN(1, p.Results.simu_round(2) - p.Results.simu_round(1) + 1, p.Results.simu_steps(2) - p.Results.simu_steps(1) + 1);
    end

    data(:, :, :) = sqrt(data(:, :, :));

    if (p.Results.simu_round(2) - p.Results.simu_round(1) + 1) == 1

      for k = 1:(p.Results.simu_steps(2) - p.Results.simu_steps(1) + 1)
        o(k) = data(:, :, k);
      end

    else

      for k = 1:(p.Results.simu_steps(2) - p.Results.simu_steps(1) + 1)
        o(k) = mean(data(:, :, k));
      end

    end

    A = [A; o];
  end

end

function [A] = RMSE(Path, load_files_name, load_variable_name, simu_round, simu_steps, varargin)
  % load_files_name = {'RUKF_Hampel_NoQ', 'RUKF_Huber_NoQ', 'Fuzzy_RUKF_Hampel_NoQ', 'Fuzzy_RUKF_Huber_NoQ'}
  % load_variable_name usually is Irms_x_y
  % simu_round = [begin, end]
  % simu_steps = [begin, end]

  p = inputParser;

  X_Axis_MultipleDefault = 1;

  is_sempty = @(x) (x);

  addRequired(p, 'Path');
  addRequired(p, 'load_files_name');
  addRequired(p, 'load_variable_name');
  addRequired(p, 'simu_round');
  addRequired(p, 'simu_steps');
  addParameter(p, 'X_Axis_Multiple', X_Axis_MultipleDefault);

  parse(p, Path, load_files_name, load_variable_name, simu_round, simu_steps, varargin{:});

  %確認模式是否為SD變化
  if p.Results.X_Axis_Multiple == 1
    A = [];

    len = size(p.Results.load_files_name);

    for i = 1:len(2)

      try
        data = load(fullfile(p.Results.Path, p.Results.load_files_name{1, i}), p.Results.load_variable_name);
        data = data.(load_variable_name)(:, p.Results.simu_round(1):p.Results.simu_round(2), p.Results.simu_steps(1):p.Results.simu_steps(2));
      catch err
        disp(err);
        data = NaN(1, p.Results.simu_round(2) - p.Results.simu_round(1) + 1, p.Results.simu_steps(2) - p.Results.simu_steps(1) + 1);
      end

      if (p.Results.simu_round(2) - p.Results.simu_round(1) + 1) == 1

        for k = 1:(p.Results.simu_steps(2) - p.Results.simu_steps(1) + 1)
          o(k) = sqrt(data(:, :, k));
        end

      else

        for k = 1:(p.Results.simu_steps(2) - p.Results.simu_steps(1) + 1)
          o(k) = sqrt(mean(data(:, :, k)));
        end

      end

      %檢查結果是否有NaN
      if sum(isnan(o)) > 0
        o = NaN(1, (p.Results.simu_steps(2) - p.Results.simu_steps(1) + 1));
      end

      A = [A; o];
    end

  else

    A = [];
    cccc = 1;

    len = size(p.Results.load_files_name);

    for i = 1:len(2)

      for jjj = p.Results.X_Axis_Multiple:-1:1

        try
          data = load(append(fullfile(p.Results.Path, p.Results.load_files_name{1, i}), '_', string(jjj)), p.Results.load_variable_name, 'TOA');
          TOA = load(append(fullfile(p.Results.Path, p.Results.load_files_name{1, i}), '_', string(jjj)), 'TOA');
          data = data.(load_variable_name)(:, p.Results.simu_round(1):p.Results.simu_round(2), p.Results.simu_steps(1):p.Results.simu_steps(2));
          TOA = TOA.('TOA');
        catch err
          disp(err);
          data = NaN(1, p.Results.simu_round(2) - p.Results.simu_round(1) + 1, p.Results.simu_steps(2) - p.Results.simu_steps(1) + 1);
        end

        if cccc == 1
          AAA = nan(1, TOA(2) + 1);
          %AAA=[];
        end

        if (p.Results.simu_round(2) - p.Results.simu_round(1) + 1) == 1

          for k = 1:(p.Results.simu_steps(2) - p.Results.simu_steps(1) + 1)
            o(k) = sqrt(data(:, :, k));
          end

        else

          for k = 1:(p.Results.simu_steps(2) - p.Results.simu_steps(1) + 1)
            o(k) = sqrt(mean(data(:, :, k)));
          end

        end

        AAA(1, TOA(2) + 1) = mean(o);

        cccc = cccc + 1;
      end

      A = [A; AAA];
    end

  end

end

function Func_Run(runsometing, load_file, save_file_name, varargin)

  p = inputParser;

  LoadFuzzyfileDefault = ' ';
  LossDataDefault = ' ';

  is_valid_string = @(x) isstring(x) || ischar(x);
  addRequired(p, 'runsometing', is_valid_string);
  addRequired(p, 'load_file', is_valid_string);
  addRequired(p, 'save_file_name', is_valid_string);
  addParameter(p, 'LoadFuzzyfile', LoadFuzzyfileDefault);
  %addParameter(p, 'LossData', LossDataDefault);
  parse(p, runsometing, load_file, save_file_name, varargin{:});

  % o.runsometing = p.Results.runsometing;
  % o.load_file = p.Results.load_file;
  % o.save_file_name = p.Results.save_file_name;
  % o.LoadFuzzyfile = p.Results.LoadFuzzyfile;
  % o.LossData = p.Results.LossData;

  load(p.Results.load_file);
  save_file_name = p.Results.save_file_name;

  if ~isempty(p.Results.LoadFuzzyfile)
    readfis_file_name = p.Results.LoadFuzzyfile;
    %readfis_file_name_2 = p.Results.LoadFuzzyfile(2);
  end

  % if p.Results.LossData
  %   gamma_r = missing_data;
  % else
  %   gamma_r = ones(1, 5001);
  % end

  try
    run(p.Results.runsometing);
    disp('-------------------------');
    disp(datestr(now, 31));
    disp(save_file_name);
    [~, name, ~] = fileparts(save_file_name);
    disp(name);
    disp(append('Load_noise=', noisetype));

    if exist ('Vel', 'var') && exist ('Acc', 'var') == 1
      disp(append('Vel=', num2str(Vel), ' ', 'Acc=', num2str(Acc)));
    end

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
