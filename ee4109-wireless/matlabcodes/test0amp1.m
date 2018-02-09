
clear all
close all

c0=round(rand(1,12));

Fc= 1250.0e6;    % carrier frequency
Fs=16*Fc;      % sampling frequency
Fd=Fs/1000;     % Baud rate

M=4;
opt=0;

SNR1 = 10; %SNR for transmitter(dB)
PdBm = -90; % Signal Power
BW = 2000e3; % Bandwidth in Hz

% Generate 3 signals 
[t0, u1] = sigpsk(c0, Fc, Fd, Fs, M, opt);

%add white noise
u2= awn(u1,SNR1,PdBm);

% Amplifer
Gain=14;    % Gain in dB
NF = 1.6;     % Noise Figure in dB
u3=amp1(u2,Gain,NF,BW);

%K&L BPF
fl=1180e6;
fh=1320e6;
u4=filterbp(u3,3,fl,fh,Fs,0.9);

%LO
Fo = 10;
Fs = 16*Fo;
t = 0:1/Fs:2/Fo;
Pout = 1;
TOL = 0;
y=siglo(t, Pout, Fo, TOL);
plot(t, y, 'b-', t, y, 'r*')
%mixer
u5=mixer(u4,siglo)
%vectron saw
fl2
fh2

u6=filterbp(u5)

%amp
u7=amp(u6)
%mixer
u8=mixer(u7,siglo)

%amp
u9=amp(u8)

%amp3
%amp4
ut1=[u1;u2;u3;u4];
marker1=['PureSig'; 'Sig+Noi'; 'Aft Amp';'Aft BPF'];
figure(1); scopet(t0,ut1,marker1,1)
figure(2); scopef(Fs,ut1,marker1,1)


% demodulation
u8code = demodpsk(u4,Fc,Fs,Fd,M);
figure(3); 
plotcodes(c0,u8code)

%eof