clc;
close all;
clear all;
addpath('C:\MATLAB2018\MATLAB\mcode\BioMedicine\Dream Abnea\BiomedicasFinal\apnea-ecg');

apnea = load('a01erm.mat');
apnea = apnea.val;
ECG = (apnea(1,:)+30)./200;
RespC = (apnea(2,:)+1903)./20000;
RespA= (apnea(3,:)+1903)./20000;
RespN= (apnea(4,:)+1903)./20000;
SpO2= apnea(5,:);
%  Normalization
ECG = (ECG(1,:)-min(ECG(1,:)))./(max(ECG(1,:))-min(ECG(1,:)));
RespC = (RespC(1,:)-min(RespC(1,:)))./(max(RespC(1,:))-min(RespC(1,:)));
RespA = (RespA(1,:)-min(RespA(1,:)))./(max(RespA(1,:))-min(RespA(1,:)));
RespN = (RespN(1,:)-min(RespN(1,:)))./(max(RespN(1,:))-min(RespN(1,:)));
SpO2 = (SpO2(1,:)-min(SpO2(1,:)))./(max(SpO2(1,:))-min(SpO2(1,:)));
%Fs
fs = 100;
ECGa = abs(ECG).^2;
[PKS1ruido,LOCS1ruido]=findpeaks(ECGa,fs,'MinPeakHeight',max(ECGa)*0.4);
findpeaks(ECGa,fs,'MinPeakHeight',max(ECGa)*0.35)
%% PARA PROPOSITOS DE VISUALIZACION
t1m=(1:6000)/fs;
t30s=(1:3000)/fs;
t30m=(1:30000)/fs;
t1h=(1:60000)/fs;