%創建空資料夾
Folder_level.L1 = {'SD NLOS Fixed'; 'SD NLOS Change'};
Folder_level.L2 = {'Fixed'; 'Markov'};
Folder_level.L3 = {{'robust_gaussian_noise', 'Gaussian'}; {'robust_exprnd_noise', 'Exprnd'}};
Folder_level.L4 = {{0, '0vel'}; {4, '4vel'}};
Folder_level.L5 = {
                {0 0 0 0 0, '0 0 0 0 0'};
                {0.25 0.25 0.25 0.25 0.25, '0.25 0.25 0.25 0.25 0.25'};
                {0.25 0.50 0.50 0.25 0.75, '0.25 0.50 0.50 0.25 0.75'};
                {0.50 0.50 0.50 0.50 0.50, '0.50 0.50 0.50 0.50 0.50'};
                {0.75 0.25 1 0.75 0.50, '0.75 0.25 1 0.75 0.50'};
                {0.75 0.75 0.75 0.75 0.75, '0.75 0.75 0.75 0.75 0.75'};
                {1 1 1 1 1, '1 1 1 1 1'};
                };

for a = 1:length(Folder_level.L1)

    [status, msg, msgID] = mkdir(Folder_level.L1{a});
    cd (Folder_level.L1{a});

    for b = 1:length(Folder_level.L2)

        [status, msg, msgID] = mkdir(Folder_level.L2{b});
        cd (Folder_level.L2{b});

        for c = 1:length(Folder_level.L3)

            [status, msg, msgID] = mkdir(Folder_level.L3{c}{end});
            cd (Folder_level.L3{c}{end});

            for d = 1:length(Folder_level.L4)

                [status, msg, msgID] = mkdir(Folder_level.L4{d}{end});
                cd (Folder_level.L4{d}{end});

                for e = 1:length(Folder_level.L5)
                    [status, msg, msgID] = mkdir(Folder_level.L5{e}{end});
                end

                cd . ./
            end

            cd . ./

        end

        cd . ./
    end

    cd . ./
end
