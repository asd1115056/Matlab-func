 clc
 clear
 
% files = dir('*.fig');
% % Get a logical vector that tells which is a directory.
% dirFlags = [files.isdir];
% % Extract only those that are directories.
% subDirs = files(dirFlags); % A structure with extra info.
% % Get only the folder names into a cell array.
% subDirsNames = {files.name};

files = dir('*.fig');
for i = 1:length(files)
    currentfile = files(i).name;
    f = openfig(currentfile);
    set(gcf,'WindowStyle','normal')
    %set(gcf,'position', [50, 50, 900, 600]); %設定figure的位置和大小
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 6]);
    print(f,'-dpng',[currentfile(1:end-3),'png']);
    close(f);
end