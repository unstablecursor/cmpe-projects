%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   CMPE 362 Homework II-b   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

                                                % Fs is the frequency = number of samples per second
                                                % y is the actual sound data 
hfile = 'laughter.wav';                         % This is a string, corresponding to the filename
clear y Fs                                      % Clear unneded variables

%% PLAYING A WAVE FILE

[y, Fs] = audioread(hfile);      % Read the data back into MATLAB, and listen to audio.
                                                % nbits is number of bits per sample
sound(y, Fs);                                   % Play the sound & wait until it finishes

duration = numel(y) / Fs;                       % Calculate the duration
pause(duration + 2)                             % Wait that much + 2 seconds

%% CHANGE THE PITCH

sound(y(1:2:end), Fs);                          % Get rid of even numbered samples and play the file


%% EXERCISE I
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Re-arrange the data so that   %
%   the frequency is quadrupled and play the file   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
sound(y(1:4:end), Fs); 

pause(duration/4 + 1);
                              
%% EXERCISE II
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Re-arrange the data so that   %
%   the frequency is halved and play the file  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
y_new= repelem(y,2);
sound(y_new, Fs);
pause(duration * 2 + 1)
                                                
                                                
%% EXERCISE III 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Double Fs and play the sound  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sound(y, Fs * 2);
pause(duration / v2 + 1);

%% EXERCISE IV
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Divide Fs by two and play the sound  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sound(y, Fs / 2);
pause(duration * 2 + 1);

