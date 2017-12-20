function N = kaiord(Fp, Fs, dp, ds, FT)
% Computation of the length of a linear-phase
% FIR multiband filter using Kaiser's formula
% dp is the passband ripple
% ds is the stopband ripple
% Fp is the passband edge in Hz
% Fs is the stopband edge in Hz
% FT is the sampling frequency in Hz
% If none specified, default value of FT is 2
% N is the extimated FIR filter order
if nargin == 4,
    FT = 2;
end

if length(Fp) > 1,
%     TBW transmission bandwidth
    TBW = min(abs(Fp(1) - Fs(1)), abs(Fp(2) - Fs(2)));
else
    TBW = abs(Fp - Fs);
end

num = -20*log10(sqrt(dp*ds)) -13;
den = 14.6*TBW/FT;
N = ceil(num/den);

end

