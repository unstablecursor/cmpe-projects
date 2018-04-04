x = csvread("as.csv", 1, 0);


t = zeros(20,1); 
for i = 1:20
    m = movmean(x, i);
    [pks,locs] = findpeaks(m);
    t(i) = length(locs);
end

plot(t)