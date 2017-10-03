Fs = 100;
t = (1:100)/Fs;
s1 = sin(2*pi*t*5);
s2 = sin(2*pi*t*15);
s3 = sin(2*pi*t*30);
s = s1 + s2 + s3;
% plot(t,s);

[b, a] = ellip(4, 0.1, 40, [10 20]/(Fs/2));
% [H, w] = freqz(b, a, 512);
% plot(w*Fs/(2*pi), abs(H));

sf = filter(b, a, s);
% plot(t, sf);
% xlabel('Time (seconds)');
% ylabel('Time waveform');
% axis([0 1 -1 1]);

S = fft(s, 512);
SF = fft(sf, 512);
w = (0:255)/256*(Fs/2);
plot(w, abs(S(1:256)), w, abs(SF(1:256)));
xlabel('Frequency (Hz)');
ylabel('Mag. of Fourier Transform');