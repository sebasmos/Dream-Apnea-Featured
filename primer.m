
clc;
close all;
clear all;
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode');

<<<<<<< HEAD
%% Se usara la base de datos apnea-ecg, bajamos todas las señales de 
%entrenamiento, las cuales son 8. Estas vienen con toda la informacion, y
%tiene los siguientes canales:
%Respiratorios (A,C,N), cardiacos (ECG), y pulsioximetría(SP02)
=======
%% Se usara la base de datos apnea-ecg, bajamos todas las seÃ±ales de 
%entrenamiento, las cuales son 8. Estas vienen con toda la informacion, y
%tiene los siguientes canales:
%Respiratorios (A,C,N), cardiacos (ECG), y pulsioximetrÃ­a(SP02)
>>>>>>> ceca34c8b6231ed847c66ece6b20a39e2b0ec7ce


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

N =60000; %declaro esto para sacar 60000 muestras equivalentes a 
<<<<<<< HEAD
          %aproximadamente 1 minuto de la señal, pues: 100 Hz es la
=======
          %aproximadamente 1 minuto de la seÃ±al, pues: 100 Hz es la
>>>>>>> ceca34c8b6231ed847c66ece6b20a39e2b0ec7ce
          %frecuencia de muestreo, cada segundo tomo 100 muestras entonces
          %en un minuto tomo 100*60=6000, si sacamos 60000 es una hora
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
%% PARA PROPOSITOS DE VISUALIZACION
t1m=(1:6000)/fs;
t30s=(1:3000)/fs;
t30m=(1:30000)/fs;
t1h=(1:60000)/fs;

figure(1)
subplot(3,1,1), plot(t30s,respA(1,(1:3000))'),grid on, axis tight
subplot(3,1,2), plot(t30s,respC(1,(1:3000))'),grid on, axis tight
subplot(3,1,3), plot(t30s,respN(1,(1:3000))'),grid on, axis tight

figure(2)
subplot(2,1,1), plot(t30s,ECG(1,(1:3000))'),grid on, axis tight
subplot(2,1,2), plot(t30s,SPO2(1,(1:3000))'),grid on, axis tight
<<<<<<< HEAD
=======



>>>>>>> ceca34c8b6231ed847c66ece6b20a39e2b0ec7ce

% 
% figure(1)
% subplot(3,1,1), plot(t30s,RespA(1,(1:3000))'),grid on, axis tight
% subplot(3,1,2), plot(t30s,RespC(1,(1:3000))'),grid on, axis tight
% subplot(3,1,3), plot(t30s,RespN(1,(1:3000))'),grid on, axis tight
% 
% figure(2)
% subplot(2,1,1), plot(t30s,ECG(1,(1:3000))'),grid on, axis tight
% subplot(2,1,2), plot(t30s,SpO2(1,(1:3000))'),grid on, axis tight
