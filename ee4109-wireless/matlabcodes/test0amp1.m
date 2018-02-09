
clear all
close all

c0=round(rand(1,12));

Fc= 1250.0e6;    % carrier frequency
Fs=16*Fc;      % sampling frequency
Fd=Fs/10000;     % Baud rate

M=4;
opt=0;

SNR1 = -10; %SNR for transmitter(dB)
PdBm = -90; % Signal Power
BW = 2e6; % Bandwidth in Hz

Fif1 = 70e6; %First IF Frequency
Fif2 = 2e6; %Second IF Frequency

% Generate 3 signals 
[t0, u1] = sigpsk(c0, Fc, Fd, Fs, M, opt);

%add white noise
u2= awn(u1,SNR1,PdBm);

% Amplifer
Gain= 14;    % Gain in dB
NF = 1.6;     % Noise Figure in dB
u3=amp1(u2,Gain,NF,BW);

% K&L BPF
fl=1200e6;
fh=1300e6;
u4=filterbp(u3,1,fl,fh,Fs,0.9);

% Mixer1 & LO1
Fo_lo1 = Fc - Fif1; % Using low-side injection
Pout_lo1 = 1;
TOL_lo1 = 0;
lo1 = siglo(t0,Pout_lo1,Fo_lo1,TOL_lo1);
u5 = mixer1(u4,lo1,11,11,BW); % Gain and NF are 11db

% Vectron SAW
fl2 = (70-9.7/2)*10^6; %low cut-off freq
fh2 = (70+9.7/2)*10^6; %high cut-off freq
u6 = filterbp(u5,3,fl2,fh2,Fs,22);

% Active Amplifier
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
Fcutoff = 3.1e6;
u9 = filterlp(u8,3,Fcutoff,Fs,1);

% Video Amp
Gain3 = 22.5;
NF3 = 0;
u10 = amp1(u9, Gain3, NF3,BW);

% Display
ut1=[u1;u2;u3;u4;lo1;u5;u6;u7;lo2;u8;u9;u10];
marker1=['PureSig'; 'Sig+Noi'; 'Aft Amp'; 'Aft BPF'; 'LocalO1'; 'AftMix1';'Aft SAW';'Aft AGC';'LocalO2';'AftMix2';'Aft LPF';'AfVideo'];
figure(1); scopet(t0,ut1,marker1,1)
figure(2); scopef(Fs,ut1,marker1,1)


% demodulation
u8code = demodpsk(u9,Fc,Fs,Fd,M);
figure(3); 
plotcodes(c0,u8code)

%eof