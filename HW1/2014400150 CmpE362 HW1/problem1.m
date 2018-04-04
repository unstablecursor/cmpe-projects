[y,Fs] = audioread('highFreq.wav');
t = linspace(0, length(y)/Fs, length(y));
subplot(2,2,1);
plot(t,y)
subplot(2,2,2);
spectrogram(y(:,1), 'MinThreshold', -55,256,60,512,Fs);
[m,high_freq]=max(y(:,1));

[y1,Fs1] = audioread('lowFreq.wav');
t1 = linspace(0, length(y1)/Fs1, length(y1));
subplot(2,2,3);
plot(t1,y1)
subplot(2,2,4);
spectrogram(y1(:,1), 'MinThreshold', -55,256,60,512,Fs);
[m1,low_freq]=max(y1(:,1));
ax = gca;
ax.YDir = 'reverse';
