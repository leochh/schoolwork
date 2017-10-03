% -------------Q7.13
% Fp = 2000;
% Fs = 2500;
% dp = 0.005;
% ds = 0.005;
% FT = 10000;
% -------------Q7.14(a)
% Fp = 2000;
% Fs = 2500;
% dp = 0.005;
% ds = 0.005;
% FT = 20000;
% -------------Q7.14(b)
% Fp = 2000;
% Fs = 2500;
% dp = 0.002;
% ds = 0.002;
% FT = 10000;
% -------------Q7.14(c)
% Fp = 2000;
% Fs = 2300;
% dp = 0.005;
% ds = 0.005;
% FT = 10000;
% N = kaiord(Fp, Fs, dp, ds, FT)

% -------------Q7.15/Q7.16
% f = [2000 2500];
% a = [1 0];
% dev = [0.005 0.005];
% FT = 10000;
% [N, Wn, beta, ftype] = kaiserord(f, a, dev, FT)
% [N, fts, mval, wgts] = remezord(f, a, dev, FT)
% [N, fts, mval, wgts] = firpmord(f, a, dev, FT)

% --------------Q7.17/Q7.18/Q7.19
% fcuts = [1200 1800 3600 4200];
% mags = [0 1 0];
% devs = [0.02 0.1 0.02];
% fsamp = 12000;
% N = kaiord([1800 3600], [1200 4200], 0.1, 0.02, fsamp)
% [N, Wn, beta, ftype] = kaiserord(fcuts, mags, devs, fsamp)
% [N, fts, mval, wgts] = remezord(fcuts, mags, devs, fsamp)

% --------------Q7.20/21/22
% b = fir1(N, Wn, ftype)
% b = fir1(N, Wn, hanning(N+1))
% b = fir1(N, Wn, blackman(N+1))
% b = fir1(N, Wn, chebwin(N+1))
% b = remez(N, fts, mval, wgts)

% --------------Q7.25
% fpts = [0 0.25 0.3 0.45 0.5 1];
% mval = [0.4 0.4 1 1 0.8 0.8];
% N = 95;
% b = fir2(N, fpts, mval)

% --------------Q7.26
% fcuts = [1200 1800 3600 4200];
% mags = [0 1 0];
% devs = [0.02 0.1 0.02];
% fsamp = 12000;
% [N, Wn, beta, ftype] = kaiserord(fcuts, mags, devs, fsamp);
% 
% fpts = [0 1200 1800 3600 4200 fsamp/2]/(fsamp/2);
% mval = [0 0 1 1 0 0];
% dp = 0.1;
% ds = 0.02;
% wgts = max(dp, ds)*[1/ds, 1/dp, 1/ds];
% b = remez(N, fpts, mval, wgts)

% --------------Q7.27
fcuts = [1500 1800 3000 3530];
mags = [0 1 0];
devs = [0.02 0.1 0.02];
fsamp = 12000;
[N, Wn, beta, ftype] = kaiserord(fcuts, mags, devs, fsamp);

fpts = [0 1500 1800 3000 3530 fsamp/2]/(fsamp/2);
mval = [0 0 1 1 0 0];
dp = 0.1;
ds = 0.02;
wgts = max(dp, ds)*[1/ds, 1/dp, 1/ds];
b = remez(N, fpts, mval, wgts)
freqz(b)

% [g,w,p_rad]=gain(b,1);
% -------------------------------------Amplitude Response
% plot(w/pi,g);
% 
% grid 
% axis([0 1 -90 5]);
% xlabel('\omega /\pi');
% ylabel('Gain, dB');
% title('Gain Response of a Butterworth Bandstop Filter');

% -------------------------------------Phase Response
% disp(p_rad);
% p=(p_rad/(2*pi))*360;
% plot(w/pi,p);
% 
% grid
% axis([0 1 -720 100]);
% xlabel('\omega /\pi');
% ylabel('Phase, deg');
% title('Phase Response');
