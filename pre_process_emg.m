function signal_f = pre_process_emg(signal_emg, fs)
    signal_emg_det = detrend(signal_emg);
    %% notch 60 Hz
    w0 = 60/(fs/2);
    bw = w0/35;
    [num,den] = iirnotch(w0,bw);
    signal_f = filtfilt(num,den, signal_emg_det');

    % notch 60 Hz
    w0 = 120/(fs/2);
    bw = w0/35;
    [num,den] = iirnotch(w0,bw);
    signal_f = filtfilt(num,den, signal_f);

    % bandpass
    f_bp = [10, 400];
    order = 2;
    [b,a] = butter(order, f_bp/(fs/2), "bandpass");

    signal_f = filtfilt(b, a, signal_f);

end