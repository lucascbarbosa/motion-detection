clear;
close all;
clc;
%% open file
sinais_brutos_dir = './sinais_brutos/';
sinais_filtrados_dir = './sinais_filtrados/';
sinais_brutos_filenames = dir(sinais_brutos_dir);

all_signals_emg = {};
all_signals_acel = {};
for i = 1:numel(sinais_brutos_filenames)
    if ~sinais_brutos_filenames(i).isdir
        file_path_bruto = fullfile(sinais_brutos_dir, sinais_brutos_filenames(i).name);
        all_data = Open_File_MAdq(file_path_bruto);
        %% read signals
        fs = all_data.Fs; % Hz
        signal_emg = all_data.ARQdigCal(1:3,:); % emg
        
        n_amostras = length(signal_emg);
        t = [0: n_amostras - 1]/fs;
        %% detrend
        signal_emg_det = detrend(signal_emg');
        %% notch 60 Hz
        w0 = 60/(fs/2);
        bw = w0/35;
        [num,den] = iirnotch(w0,bw);
        signal_f = filtfilt(num,den, signal_emg_det);
        
        %% notch 60 Hz
        w0 = 120/(fs/2);
        bw = w0/35;
        [num,den] = iirnotch(w0,bw);
        signal_f = filtfilt(num,den, signal_f);
        
        %% bandpass
        f_bp = [10, 400];
        order = 2;
        [b,a] = butter(order, f_bp/(fs/2), "bandpass");

        signal_f = filtfilt(b, a, signal_f);
        all_signals_emg{i} = signal_f;

                %% acel
        signal_acel = all_data.ARQcanalesADC;   % acel

        %% filtro passa baixo
        f_lp = 20;  % Hz
        order = 4;
        [b,a] = butter(order, f_lp/(fs/2), "low");  
        signal_f_acel = filtfilt(b, a, signal_acel');
        all_signals_acel{i} = signal_f_acel;

%         figure; % 7
%         subplot(2,1,1);
%         plot(t, signal_f);
%         xlabel('Time [s]'); ylabel('V');
%         legend('ch1', 'ch2', 'ch3');
%         subplot(2,1,2);
%         ma_fft_plot(signal_f, fs, 0);
    end 
end
all_signals_emg = cat(1, all_signals_emg{:});
[folder, name, ~] = fileparts(file_path_bruto);
file_path_filtrado = fullfile(sinais_filtrados_dir, 'clara_signals_emg.csv');
csvwrite(file_path_filtrado, all_signals_emg);

all_signals_acel = cat(1, all_signals_acel{:});
file_path_filtrado = fullfile(sinais_filtrados_dir, 'clara_signals_acel.csv');
csvwrite(file_path_filtrado, all_signals_acel);
