clc;
close all;
clear all;
addpath('C:\MATLAB2018\MATLAB\mcode\BioMedicine\Dream Abnea\BiomedicasFinal\apnea-ecg');
% m represents the size 
m = 3000;
% NUMBER OF DATASETS 
N = 7;
% STRINGS MEMORY BANK
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
for i = 1:N
    signal      =  load(char(names{i}));
    signal      =  signal.val;
    ECG(:,i)    =  (signal(1,:)+30)./200;
    RespA(:,i)  =  (signal(2,:)+1903)./20000;
    RespC(:,i)  =  (signal(3,:)+1903)./20000;
    RespN(:,i)  =  (signal(4,:)+1903)./20000;
    SpO2(:,i)   =  signal(5,:);

end

    % NORMALIZATION MIN MAX
    FullECG   = (ECG-min(ECG))./(max(ECG)-min(ECG));    
    FullRespC = (RespC-min(RespC))./(max(RespC)-min(RespC));
    FullRespA = (RespA-min(RespA))./(max(RespA)-min(RespA));
    FullRespN = (RespN-min(RespN))./(max(RespN)-min(RespN));
    FullSpO2  = (SpO2-min(SpO2))./(max(SpO2)-min(SpO2));

% Sample Frequency
Fs = 100;
% Squared for easier peak detection
for k = 1:N
        ECGSquared(:,k) = abs(FullECG((1:m),k)).^2;  
end
ECGSquared = ECGSquared';
% PEAKS DETECTION
[R1,TR1]=findpeaks(ECGSquared(1,(1:m)),Fs,'MinPeakHeight',0.35);
[R2,TR2]=findpeaks(ECGSquared(2,(1:m)),Fs,'MinPeakHeight',0.35);
[R3,TR3]=findpeaks(ECGSquared(3,(1:m)),Fs,'MinPeakHeight',0.35);
[R4,TR4]=findpeaks(ECGSquared(4,(1:m)),Fs,'MinPeakHeight',0.35);
[R5,TR5]=findpeaks(ECGSquared(5,(1:m)),Fs,'MinPeakHeight',0.35);
[R6,TR6]=findpeaks(ECGSquared(6,(1:m)),Fs,'MinPeakHeight',0.35);
[R7,TR7]=findpeaks(ECGSquared(7,(1:m)),Fs,'MinPeakHeight',0.35);

%% PARA PROPOSITOS DE VISUALIZACION
t    = [0:m-1]/Fs;
t1m=(1:6000)/Fs;
t30s= [0:3000-1]./Fs;
t5min = (1:30000)/Fs;
t30m=(1:180000)/Fs;
t1h=(1:360000)/Fs;
figure
plot(t,ECGSquared(1,:)),grid on, axis tight
hold on
plot(TR1,R1,'^r'),title('Peaks in ECG'),ylabel('Magnitude'), xlabel('Time (s)'),grid on, axis tight
legend('ECG', 'R')
%% INTERVALS RR
figure
title('RR intervals')
RRinterval1 = diff(TR1);
RRinterval2 = diff(TR2);
RRinterval3 = diff(TR3);
RRinterval4 = diff(TR4);
RRinterval5 = diff(TR5);
RRinterval6 = diff(TR6);
RRinterval7 = diff(TR7);
RRintMean1 = mean(RRinterval1);
RRintMean2= mean(RRinterval2);
RRintMean3= mean(RRinterval3);
RRintMean4= mean(RRinterval4);
RRintMean5= mean(RRinterval5);
RRintMean6= mean(RRinterval6);
RRintMean7= mean(RRinterval7);
disp(['1. El intervalo RR promedio es ',num2str(RRintMean1),' segundos'])
disp(['2. El intervalo RR promedio es ',num2str(RRintMean2),' segundos'])
disp(['3. El intervalo RR promedio es ',num2str(RRintMean3),' segundos'])
disp(['4. El intervalo RR promedio es ',num2str(RRintMean4),' segundos'])
disp(['6. El intervalo RR promedio es ',num2str(RRintMean5),' segundos'])
disp(['5. El intervalo RR promedio es ',num2str(RRintMean6),' segundos'])
disp(['7. El intervalo RR promedio es ',num2str(RRintMean7),' segundos'])
plot((1:length(TR1)-1)/60,RRinterval1)
xlabel('Tiempo (min)');
ylabel('RR (sec)');
h_RR = get(gca);

%% PULSACIONES
title('Càlculo de las pulsaciones por minuto')
plot((1:length(TR1)-1)/60,1./RRinterval1*60,...
    (1:length(TR1)-1)/60,mean(1./RRinterval1*60),'ro');
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

DetrendedECG = Detrending(ECGSquared,10);
Medians = ECGSquared-DetrendedECG;
figure
plot(Medians(1:m)),title('Drift baseline'),axis tight,grid on,xlabel('samples'),ylabel('amplitude')
%% Señal Respiratoria

BreathA = FullRespA(1:end,:).^2;

[RRespA,TRRespA]=findpeaks(BreathA(1:end,1),Fs,'MinPeakHeight',0.3,'MinPeakDistance',35);
findpeaks(BreathA(1:end,1),Fs,'MinPeakHeight',0.3,'MinPeakDistance',35);
RRintervalRespA = diff(TRRespA); % 203 x 1, 203 intervalos almacenados
% 10 segundos equivalen a 100 hz * 10 seg = 1000 muestras
meanRRintervalRespA = mean(RRintervalRespA);
aux = 0;
for p = 1:length(RRintervalRespA)
    if RRintervalRespA(p) > meanRRintervalRespA 
        ApneaRespA = 1;
        aux = [aux ApneaRespA];
    else 
        ApneaRespA = 0;
        aux = [aux ApneaRespA];
    end
end
ApneaEventsWithRespA = aux;
plot(ApneaEventsWithRespA),title('Apnea events')
ApneaEventsA = length(ApneaEventsWithRespA(ApneaEventsWithRespA==1));
disp(['Apnea events are: ',num2str(ApneaEventsA),' in this dataset'])
% anotaciones
[ana01er]=rdann('apnea-ecg/a01er','apn');
figure
plot(BreathA((1:end),1))
hold on
%plot(TRRespA,RRespA,'v')
hold on
plot(ana01er,BreathA(ana01er),'k*')