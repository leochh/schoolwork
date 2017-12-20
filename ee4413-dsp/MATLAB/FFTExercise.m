Fs = 44100;
t = (1:1000)/Fs;
s1 = sin(2*pi*t*500);
s2 = sin(2*pi*t*1500);
s3 = sin(2*pi*t*3000);
s = s1 + s2 + s3;
% plot(t,s);

Fsamp = 44100;
fpts = [0 199 200 399 400 799 800 1599 1600 3199 3200 6399 6400 12299 12300 21999 22000 Fsamp/2]/(Fsamp/2); 
v = 10.^([-10 -10 -10 -10 10 10 -10 -10]/20);
mval = [v(1) v(1) v(2) v(2) v(3) v(3) v(4) v(4) v(5) v(5) v(6) v(6) v(7) v(7) v(8) v(8) 0 0]
N = 511;
b = fir2(N, fpts, mval, chebwin(N+1));

% [b, a] = ellip(5, 0.1, 40, [2500 3500]/(Fs/2));
% [H, w] = freqz(b, 1, 512);
% plot(w*Fs/(2*pi), abs(H));

sf = filter(b, 1, s);
% plot(t, sf);
% xlabel('Time (seconds)');
% ylabel('Time waveform');

S = fft(s, 512);
SF = fft(sf, 512);
w = (0:255)/256*(Fs/2);
plot(w, abs(S(1:256)), 'r', w, abs(SF(1:256)), 'b');
xlabel('Frequency (Hz)');
ylabel('Mag. of Fourier Transform');