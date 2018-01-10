% -------------------------Q7.1/Q7.6
% fs=40000;
% Wp=4000/fs*2;
% Ws=8000/fs*2;
% Rp=0.5;
% Rs=40;

% -------------------------Q7.2/Q7.7
% fs=3500;
% Wp=1050/fs*2;
% Ws=600/fs*2;
% Rp=1;
% Rs=50;

% -------------------------Q7.3/Q7.8
fs=7000;
Wp=[1400 2100]/fs*2;
Ws=[1050 2450]/fs*2;
Rp=0.4;
Rs=50;

% -------------------------Q7.4
% fs=12000;
% Wp=[2100 4500]/fs*2;
% Ws=[2700 3900]/fs*2;
% Rp=0.6;
% Rs=45;

% [n1,Wn1]=buttord(Wp,Ws,Rp,Rs)
% [n2,Wn2]=cheb1ord(Wp,Ws,Rp,Rs)
% [n3,Wn3]=cheb2ord(Wp,Ws,Rp,Rs)
% [n4,Wn4]=ellipord(Wp,Ws,Rp,Rs)

% -------------------------Q7.5
% Wp=[0.3 0.7];
% Ws=[0.4 0.6];
% Rp=0.4;
% Rs=50;
% 
% [n1, Wn1]=buttord(Wp,Ws,Rp,Rs);
% [num,den]=butter(n1,Wn1,'stop');

% -------------------------Q7.6
% [n2,Wn2]=cheb1ord(Wp,Ws,Rp,Rs);
% [num,den]=cheby1(n2,Rp,Wp);

% -------------------------Q7.7
% [n3,Wn3]=cheb2ord(Wp,Ws,Rp,Rs);
% [num,den]=cheby2(n3,Rs,Ws,'high');

% -------------------------Q7.8
[n4,Wn4]=ellipord(Wp,Ws,Rp,Rs);
[num,den]=ellip(n4,Rp,Rs,Wp);

disp('Numerator coefficients are: ');disp(num);
disp('Denominator coefficients are: ');disp(den);

[g,w,p_rad]=gain(num,den);

% -------------------------------------Amplitude Response
plot(w/pi,g);

grid 
axis([0 1 -60 5]);
xlabel('\omega /\pi');
ylabel('Gain, dB');
title('Gain Response of a Butterworth Bandstop Filter');

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