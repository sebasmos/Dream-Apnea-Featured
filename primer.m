clc;
close all;
clear all;
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode');

%% Se usara la base de datos challenge/2010/set-a, la se�al a00
% el comando physionetdb proporciona un listado de las bases de datos
% disponibles y el enlace a la base de datos

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
          %aproximadamente 1 minuto de la señal
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


