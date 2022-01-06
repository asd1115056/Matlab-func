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

function Func_Run(runsometing, load_file, save_file_name, varargin)

    p = inputParser;

    LoadFuzzyfileDefault = '';
    LossDataDefault = '';

    is_valid_string = @(x) isstring(x) || ischar(x);
    addRequired(p, 'runsometing', is_valid_string);
    addRequired(p, 'load_file', is_valid_string);
    addRequired(p, 'save_file_name', is_valid_string);
    addParameter(p, 'LoadFuzzyfile', LoadFuzzyfileDefault, is_valid_string);
    addParameter(p, 'LossData', LossDataDefault, is_valid_string)
    parse(p, runsometing, load_file, save_file_name, varargin{:});

    % o.runsometing = p.Results.runsometing;
    % o.load_file = p.Results.load_file;
    % o.save_file_name = p.Results.save_file_name;
    % o.LoadFuzzyfile = p.Results.LoadFuzzyfile;
    % o.LossData = p.Results.LossData;

    load(p.Results.load_file);

    if p.Results.LoadFuzzyfile
        readfis_file_name = p.Results.LoadFuzzyfile;
    end

    if p.Results.LossData
        gamma_r = missing_data;
    else
        gamma_r = ones(1, 5001);
    end

    try
        run(runp.Results.runsometing);
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
