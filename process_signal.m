% clear;
% close all;
% clc;

% sinais_brutos_dir = './sinais_brutos/';
% sinais_filtrados_dir = './sinais_filtrados/';
% sinais_brutos_filenames = dir(sinais_brutos_dir);

function [signal_emg, signal_emg_f, signal_emg_en, signal_acel, signal_acel_f, signal_acel_en, fs] = process_signal(filepath)
%% open file
    all_data = Open_File_MAdq(filepath);
    fs = all_data.Fs; % Hz
    signal_emg = all_data.ARQdigCal(1:3,:); % emg 
    
    n_amostras = length(signal_emg);
    t = [0: n_amostras - 1]/fs;
    
    signal_acel = all_data.ARQcanalesADC;   % acel
    
    signal_emg_f = pre_process_emg(signal_emg, fs);
    signal_acel_f = pre_process_acel(signal_acel, fs);
    
    signal_emg_en = signal_energy(signal_emg_f);
    signal_acel_en = signal_energy(signal_acel_f);
end
% all_signals_emg = {};
% all_signals_acel = {};
% for i = 3:numel(sinais_brutos_filenames)
%     file_path_bruto = fullfile(sinais_brutos_dir, sinais_brutos_filenames(i).name);
%  
% end
% all_signals_emg = cat(1, all_signals_emg{:});
% [folder, name, ~] = fileparts(file_path_bruto);
% file_path_filtrado = fullfile(sinais_filtrados_dir, 'clara_signals_emg.csv');
% csvwrite(file_path_filtrado, all_signals_emg);
% 
% all_signals_acel = cat(1, all_signals_acel{:});
% file_path_filtrado = fullfile(sinais_filtrados_dir, 'clara_signals_acel.csv');
% csvwrite(file_path_filtrado, all_signals_acel);
