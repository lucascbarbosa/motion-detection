function signal_f = pre_process_acel(signal_acel, fs)
    %% filtro passa baixo
    f_lp = 20;  % Hz
    order = 4;
    [b,a] = butter(order, f_lp/(fs/2), "low");  
    signal_f = filtfilt(b, a, signal_acel');
end