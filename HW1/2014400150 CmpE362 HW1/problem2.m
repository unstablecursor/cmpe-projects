d = dir('/Users/unstblecrsr/Desktop/CMPE362/hakli/**');
directs = d([d.isdir]);
hold on;
for i=1:length(directs)
    cd(strcat(directs(i).folder, '/' , directs(i).name));
    files = dir('*.csv');
    if(~isempty(files))
        for j=1:length(files)
            x = csvread(files(j).name, 1, 0);
            findpeaks(x,'MinPeakProminence', 1);
        end
    end
end