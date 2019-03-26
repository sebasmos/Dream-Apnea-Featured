
clc;
close all;
clear all;
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode');

%% Se usara la base de datos apnea-ecg, bajamos todas las señales de 
%entrenamiento, las cuales son 8. Estas vienen con toda la informacion, y
%tiene los siguientes canales:
%Respiratorios (A,C,N), cardiacos (ECG), y pulsioximetría(SP02)

names=cell(8,1);
for i=1:4
    string=strcat({'a0'},int2str(i),{'er'});
    names{i}=string;
end
for i=1:3
    string=strcat({'c0'},int2str(i),{'er'});
    names{i+4}=string;
end
names{end}='b01er';
N =1440000; %declaro esto para sacar Dos millones de  muestras equivalentes a 8 horas


for i=1:8
    BaseDatos= strcat({'apnea-ecg/'},names{i});
    siginfo = wfdbdesc(BaseDatos{1});
    [signal,fs,tm]= rdsamp(BaseDatos{1}, [1 2 3 4 5], N);
    ECG(:,i)=signal(:,1);
    respA(:,i)=signal(:,2);
    respC(:,i)=signal(:,3);
    respN(:,i)=signal(:,4);
    SPO2(:,i)=signal(:,5);
end

ECG=ECG';
respA=respA';
respC=respC';
respN=respN';
SPO2=SPO2';

%% Bajamos las anotaciones de apnea
[ana01er]=rdann('apnea-ecg/a01er','apn');
[ana02er]=rdann('apnea-ecg/a02er','apn');
[ana03er]=rdann('apnea-ecg/a03er','apn');
[ana04er]=rdann('apnea-ecg/a04er','apn');
[anc01er]=rdann('apnea-ecg/c01er','apn');
[anc02er]=rdann('apnea-ecg/c02er','apn');
[anc03er]=rdann('apnea-ecg/c03er','apn');
[anb01er]=rdann('apnea-ecg/b01er','apn');

ana01er=ana01er(1:480);
ana02er=ana02er(1:480);
ana03er=ana03er(1:480);
ana04er=ana04er(1:480);
anc01er=anc01er(1:480);
anc02er=anc02er(1:480);
anc03er=anc03er(1:453);
anb01er=anb01er(1:480);

%Como bajamos 2M de muestras de cada registro
%% PARA PROPOSITOS DE VISUALIZACION

% t1m=(1:6000)/fs;
% t30s=(1:3000)/fs;
% t30m=(1:30000)/fs;
% t1h=(1:60000)/fs;
% 
% figure(1)
% subplot(3,1,1), plot(t30s,respA(1,(1:3000))'),grid on, axis tight
% subplot(3,1,2), plot(t30s,respC(1,(1:3000))'),grid on, axis tight
% subplot(3,1,3), plot(t30s,respN(1,(1:3000))'),grid on, axis tight
% 
% figure(2)
% subplot(2,1,1), plot(t30s,ECG(1,(1:3000))'),grid on, axis tight
% subplot(2,1,2), plot(t30s,SPO2(1,(1:3000))'),grid on, axis tight

t1m=(1:6000)/fs;
t30s=(1:3000)/fs;
t30m=(1:180000)/fs;
t1h=(1:360000)/fs;

figure(1)
subplot(3,1,1), plot(t30s,respA(1,(1:3000))'),grid on, axis tight
subplot(3,1,2), plot(t30s,respC(1,(1:3000))'),grid on, axis tight
subplot(3,1,3), plot(t30s,respN(1,(1:3000))'),grid on, axis tight

figure(2)
subplot(2,1,1), plot(t30s,ECG(1,(1:3000))'),grid on, axis tight
subplot(2,1,2), plot(t30s,SPO2(1,(1:3000))'),grid on, axis tight

%% 

%Normalizacion minmax
for i=1:8
    FullECG(i,:)= (ECG(i,:)-min(ECG(i,:)))./(max(ECG(i,:))-min(ECG(i,:)));    
    FullrespC(i,:) = (respC(i,:)-min(respC(i,:)))./(max(respC(i,:))-min(respC(i,:)));
    FullrespA(i,:) = (respA(i,:)-min(respA(i,:)))./(max(respA(i,:))-min(respA(i,:)));
    FullrespN(i,:) = (respN(i,:)-min(respN(i,:)))./(max(respN(i,:))-min(respN(i,:)));
    FullSPO2(i,:)  = (SPO2(i,:)-min(SPO2(i,:)))./(max(SPO2(i,:))-min(SPO2(i,:)));
end
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

% [qrsa01er]=rdann('apnea-ecg/a01er','qrs');
% [qrsa02er]=rdann('apnea-ecg/a02er','qrs');
% [qrsa03er]=rdann('apnea-ecg/a03er','qrs');
% [qrsa04er]=rdann('apnea-ecg/a04er','qrs');
% [qrsc01er]=rdann('apnea-ecg/c01er','qrs');
% [qrsc02er]=rdann('apnea-ecg/c02er','qrs');
% [qrsc03er]=rdann('apnea-ecg/c03er','qrs');
% [qrsb01er]=rdann('apnea-ecg/b01er','qrs');

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
%% Processing with wavelets
m=120000;
ecgsig=FullECG(1,(1:m));
wt = modwt(ecgsig,5);
wtrec = zeros(size(wt));
wtrec(4:5,:) = wt(4:5,:);
h = imodwt(wtrec,'sym4');
h = abs(h).^2;
y=hampel(h);
[WAVPKS,WAVLOCS] = GetECGPeakPoints(y,0.7.*max(y));
figure
plot((0:m-1)/fs,h,(0:m-1)/fs,y),grid on, axis tight,
%%
figure
plot(y)
hold on
plot(WAVLOCS,WAVPKS,'ro')
xlabel('Seconds')
title('R Peaks Localized by Wavelet Transform with Automatic Annotations')
RRw=diff(WAVLOCS);
meanRRw=mean(RRw)/fs;


%% PROCESAMIENTO DE SEÑALES RESPIRATORIAS
m=30000;

rsigc=FullrespC(1,(12001:m));
rsiga=FullrespA(1,(12001:m));
t3m=(0:length(rsigc)-1)/fs;
drsigc=detrend(rsigc);
drsiga=detrend(rsiga);
subplot(2,1,1), plot(t3m,drsiga),grid on, axis tight
subplot(2,1,2), plot(t3m,drsigc),grid on, axis tight