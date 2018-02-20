function receiver(c0, t0, inSignal, Fc, Fs, Fd, M, BW)
%RECEIVER Summary of this function goes here
%   Detailed explanation goes here
Fif1 = 70e6; %First IF Frequency
Fif2 = 2e6; %Second IF Frequency

% Amplifer1
Gain= 14;    % Gain in dB
NF = 1.6;     % Noise Figure in dB
u3=amp1(inSignal,Gain,NF,BW);

% K&L BPF
fl=1200e6;
fh=1300e6;
u4=filterbp(u3,3,fl,fh,Fs,0.9);

% Mixer1 & LO1
Fo_lo1 = Fc - Fif1; % Using low-side injection
Pout_lo1 = 1;
TOL_lo1 = 0;
lo1 = siglo(t0,Pout_lo1,Fo_lo1,TOL_lo1);
u5 = mixer1(u4,lo1,11,11,BW); % Gain and NF are 11db

% Vectron SAW
fl2 = (70-4.4/2)*10^6; %low cut-off freq
fh2 = (70+4.4/2)*10^6; %high cut-off freq
u6 = filterbp(u5,3,fl2,fh2,Fs,27);

% Active Amplifier (uPC2798GR)
Gain2 = 10;
NF2 = 9;
u7 = amp1(u6,Gain2,NF2,BW);

% Mixer2 & LO2
Fo_lo2 = Fif1 - Fif2;
Pout_lo2 = -10;
TOL_lo2 = 0;
lo2 = siglo(t0,Pout_lo2,Fo_lo2,TOL_lo2);
u8 = mixer1(u7,lo2,10,9,BW);

% LPF
Fcutoff1 = 3.1e6;
u9 = filterlp(u8,3,Fcutoff1,Fs,1);

% Video Amp (uPC2798GR)
Gain3 = 22.5;
NF3 = 0;
u10 = amp1(u9, Gain3, NF3, BW);

% Active Amp (uPC3206GR)
Gain4 = 38.5;
NF4 = 5.5;
u11 = amp1(u10, Gain4, NF4, BW);

% LPF
Fcutoff2 = 3.1e6;
u12 = filterlp(u11,3,Fcutoff2,Fs,1);

% Video Amp (uPC3206GR)
Gain5 = 20*log10(11);
NF5 = 0;
u13 = amp1(u12, Gain5, NF5, BW);


% Display
ut1=[inSignal;u3;u4;lo1;u5;u6];
marker1=['In Sig '; 'Aft Amp'; 'Aft BPF'; 'LocalO1'; 'AftMix1';'Aft SAW'];
ut2=[u7;lo2;u8;u9;u10;u11;u12;u13];
marker2=['AftAGC1';'LocalO2';'AftMix2';'AftLPF2';'Aft Vd1';'AftAGC2';'AftLPF2';'Aft Vd2'];
figure(1); scopet(t0,ut1,marker1,1)
figure(2); scopef(Fs,ut1,marker1,1)
figure(3); scopet(t0,ut2,marker2,1)
figure(4); scopef(Fs,ut2,marker2,1)


% demodulation
u8code1 = demodpsk(u4,Fc,Fs,Fd,M);
u8code2 = demodpsk(u6,Fif1,Fs,Fd,M);
u8code3 = demodpsk(u13,Fif2,Fs,Fd,M);
figure(5); plotcodes(c0,u8code1)
figure(6); plotcodes(c0,u8code2)
figure(7); plotcodes(c0,u8code3)

end
