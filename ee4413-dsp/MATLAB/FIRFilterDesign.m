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

% --------------Q7.17
% fcuts = [1200 1800 3600 4200];
% mags = [0 1 0];
% devs = [0.02 0.1 0.02];
% fsamp = 12000;
% N = kaiord([1800 3600], [1200 4200], 0.1, 0.02, fsamp)
% [N, Wn, beta, ftype] = kaiserord(fcuts, mags, devs, fsamp)
% [N, fts, mval, wgts] = remezord(fcuts, mags, devs, fsamp)
