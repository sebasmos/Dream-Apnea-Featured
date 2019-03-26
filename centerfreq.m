function [mediaF,medianF,f,dP] = centerfreq(Fs,x)
% Entrada: Fs -> Frecuencia de muestreo
%          x -> Se�al de voz preprocesada
% Salida: mF: Frecuencia media donde est� el mayor contenido de potencia de
% la voz
%         f -> vector de frecuencias del espectro
%         dP -> vector de Potencia en decibeles
L = max(size(x));               % Calcula el tama�o m�ximo de la se�al
NFFT = 2^nextpow2(L);           % Next power of 2 from length of y
dP = 20*log10(abs(fft(x,NFFT)));% Transformada Fourier para hallar potencia
f = Fs/2*linspace(0,1,NFFT/2+1);% Interfalo para la frecuencia
dP = dP(1:NFFT/2+1);            % Crea vector
dPmax = max(dP);
abovecutoff = dP > dPmax-3;   %3 dB is factor of 2
lowbin = find(abovecutoff, 1, 'first');
higbin = find(abovecutoff, 1, 'last');
mediaF = mean([f(lowbin),f(higbin)]);
medianF = median([f(lowbin),f(higbin)]);


