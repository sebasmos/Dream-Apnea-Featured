%% function [ECGPeaks,ECGLocs] = GetPeakPoints(s,Fs,minW,d)
% s: signal name
% Fs: Freq muestreo
% minW: Ancho min
% dist min : d

function [ECGPeaks,ECGLocs] = GetECGPeakPoints(s,minH,minDD)

[ECGPeaks,ECGLocs] = findpeaks(s,'MinPeakHeight',minH,'minPeakDistance',minDD);
figure
findpeaks(s,'MinPeakHeight',minH,'minPeakDistance',minDD);
hold on
plot(ECGLocs,ECGPeaks,'o')   
xlabel('Tiempo');
ylabel('Signal');
hold on
end