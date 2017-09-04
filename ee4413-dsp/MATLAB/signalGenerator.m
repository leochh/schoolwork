function outputSignal = signalGenerator(fs, nop)
x = repmat([5,0,3,zeros(1,fs-7),3,0,5,0], [1,nop]);
f=(1:1:(nop*fs));
tr_func=abs(sinc(f./fs));
outputSignal=x.*tr_func;
stem(tr_func)

