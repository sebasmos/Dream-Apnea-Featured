%% POR MEDIO DEL METODO DE ELEVAR LA SEÑAL AL CUADRADO

% Señal ECG al cuadrado
dECG=detrend(FullECG');
dECG=dECG';
ECGSquared=abs(dECG).^2;
m= 120000;  %windows size 5 minutos es decir 300000 muestra
[PKSECG,LOCSECG]=GetECGPeakPoints(ECGSquared(1,(1:m)),0.06,6);
RR=diff(LOCSECG);
meanRR=mean(RR)/fs;
% Bajamos las anotaciones qrs que tiene el dataset, aunque esten sujetas a
% fallos pueden ayudarnos a fijar mejor los picos R

[qrsa01er]=rdann('apnea-ecg/a01er','qrs');
[qrsa02er]=rdann('apnea-ecg/a02er','qrs');
[qrsa03er]=rdann('apnea-ecg/a03er','qrs');
[qrsa04er]=rdann('apnea-ecg/a04er','qrs');
[qrsc01er]=rdann('apnea-ecg/c01er','qrs');
[qrsc02er]=rdann('apnea-ecg/c02er','qrs');
[qrsc03er]=rdann('apnea-ecg/c03er','qrs');
[qrsb01er]=rdann('apnea-ecg/b01er','qrs');

%1 minuto corresponde hasta 5974, este numero se cambia en caso de que se
%deseen anotaciones de mas de un minuto

qrs=qrsa01er(qrsa01er<=119941);
figure
plot(ECGSquared(1,(1:m)))
hold on
plot(LOCSECG,PKSECG,'v')
hold on
plot(qrs,ECGSquared(qrs),'k*')
xlabel('Seconds')
title('R Peaks Localized by Wavelet Transform with Automatic Annotations')
