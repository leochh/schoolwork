Fs = 100;
t = (1:Fs)/Fs;
s1 = sin(2*pi*t*1);
s2 = sin(2*pi*t*2);
% plot(t, s1, 'r', t, s2, 'b');

fpts = [0 4 8 Fs/2]/(Fs/2);
mval = [1 1 0 0];
N = 50;
b = fir2(N, fpts, mval, chebwin(N+1));
freqz(b,1,256,Fs);


sf1 = filter(b, 1, s1);
sf2 = filter(b, 1, s2);

ax1 = subplot(2,1,1);
plot(ax1, t, s1, 'r', t, sf1, 'r', t, s2, 'b', t, sf2, 'b');
xlabel(ax1,'Time (seconds)');
% ax2 = subplot(2,1,2);
% plot(ax2, w/pi,p);
% xlabel(ax2,'Freq (Hz)');

