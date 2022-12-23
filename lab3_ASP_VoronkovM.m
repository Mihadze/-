%% Filters design
freqArray1 = [31, 62, 125, 250, 500, 1000, 2000, 4000, ...
8000,16000];
order1 = 1024;
fS = 44100;
result = CreateFilters(freqArray1, order1, fS);
%% Filtering of signals
[signal, fS2] = audioread('Freddie Dredd - Snake.mp3');
initB = zeros(1,order1);
gain = ones(length(freqArray1), 1);
tic; signalOut0 = FilteringBanks(signal,result, gain, 'filter', initB); toc;
tic; signalOut1 = FilteringBanks(signal,result, gain, 'fftfilter'); toc;
tic; signalOut2 = FilteringBanks(signal,result, gain, 'convfilter'); toc;
%% Stream sound
deviceWriter = audioDeviceWriter('SampleRate', fS);
fileReader = dsp.AudioFileReader('Freddie Dredd - Snake.mp3');
gain = [10 10 10 0.1*ones(1, 7)]'; % bass boosted
while ~isDone(fileReader)
    gain = rand(size(freqArray))';
    audioData = fileReader();
    [signalOut3, initB] = FilteringBanks(signal, result, gain, 'fftfilter', initB);
    deviceWriter(audioData);
end
