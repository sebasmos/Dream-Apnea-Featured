clc;
close all;
clear all;
addpath('C:\MATLAB2018\MATLAB\mcode\BioMedicine\Dream Abnea\BiomedicasFinal\apnea-ecg');
% Partition
m = 3000;
% STRING MEMORY BANK
names=cell(8,1);
for i = 1:4
    dbNames = strcat({'a0'},int2str(i),{'erm.mat'});
    names{i}=dbNames;
end
for i=1:3
    string=strcat({'c0'},int2str(i),{'erm.mat'});
    names{i+4}=string;
end
% SAVE IN PHYSICAL UNITS
for i = 1:7
    signal      =  load(char(names{i}));
    signal      =  signal.val;
    ECG(:,i)    =  (signal(1,:)+30)./200;
    RespA(:,i)  =  (signal(2,:)+1903)./20000;
    RespC(:,i)  =  (signal(3,:)+1903)./20000;
    RespN(:,i)  =  (signal(4,:)+1903)./20000;
    SpO2(:,i)   =  signal(5,:);
end
% NORMALIZATION MIN MAX
FullECG = (ECG(:,1)-min(ECG(:,1)))./(max(ECG(:,1))-min(ECG(:,1)));
FullRespC = (RespC(:,2)-min(RespC(:,2)))./(max(RespC(:,2))-min(RespC(:,2)));
FullRespA = (RespA(:,3)-min(RespA(:,3)))./(max(RespA(:,3))-min(RespA(:,3)));
FullRespN = (RespN(:,4)-min(RespN(:,4)))./(max(RespN(:,4))-min(RespN(:,4)));
FullSpO2 = (SpO2(:,5)-min(SpO2(:,5)))./(max(SpO2(:,5))-min(SpO2(:,5)));
%  Normalization
% Sample Frequency
fs = 100;
% Square for easier peak detection
ECGa = abs(FullECG((1:3000),1)).^2;

% [R1,TR1]=findpeaks(ECGa(1:3000),fs,'MinPeakHeight',max(ECGa)*0.4);

[R1,TR1]=findpeaks(ECGa,fs,'MinPeakHeight',0.35);

%% PARA PROPOSITOS DE VISUALIZACION
t    = [0:m-1]/fs;
t1m=(1:6000)/fs;
t30s= [0:3000-1]./fs;
t5min = (1:30000)/fs;
t30m=(1:180000)/fs;
t1h=(1:360000)/fs;
 figure
plot(t,ECGa),grid on, axis tight
hold on
plot(TR1,R1,'^r'),title('Peaks in ECG'),ylabel('Magnitude'), xlabel('Time (s)'),grid on, axis tight
legend('ECG', 'R')
%% INTERVALS RR
figure
title('RR intervals')
RRinterval = diff(TR1);
plot((1:length(TR1)-1)/60,RRinterval)
xlabel('Tiempo (min)');
ylabel('RR (sec)');
h_RR = get(gca);

%% PULSACIONES
title('Càlculo de las pulsaciones por minuto')
plot((1:length(TR1)-1)/60,1./RRinterval*60,...
    (1:length(TR1)-1)/60,mean(1./RRinterval*60),'ro');
ylabel('Pulsaciones por minuto')

%% Peaks detecion with wvs
% There are two keys for using wavelets as general feature detectors:
% The wavelet transform separates signal components into different frequency 
% bands enabling a sparser representation of the signal. You can often find 
% a wavelet which resembles the feature you are trying to detect. The 'sym4'
% wavelet resembles the QRS complex, which makes it a good choice for QRS
% detection. To illustrate this more clearly, extract a QRS complex and plot
% the result with a dilated and translated 'sym4' wavelet for comparison.
%[mpdict,~,~,longs] = wmpdictionary(numel(ECGa(1:m)),'lstcpt',{{'sym4',3}});

DetrendedECG = Detrending(ECGa,10);
Medians = ECGa-DetrendedECG;
figure
plot(Medians),title('Drift baseline'),axis tight,grid on,xlabel('samples'),ylabel('amplitude')
