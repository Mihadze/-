%% Filters design
freqArray = [31, 62, 125, 250, 500, 1000, 2000, 4000, 8000,16000];
order = 1024; % должен быть четным
fS = 44100;
bBank = CreateFilters(freqArray, order, fS);
nums = randperm(10, 3);
bTmp = bBank(nums, :);
for i = 1:3
    [H(i, :), w(i,:)] = freqz(bTmp(i,:), 1, order);
end

Xdb = @(x)(20*log10(x));%анон функция
h = abs(H);%модуль
W = w/pi*fS/2;
Hdb = Xdb(h);
%% Graph with standard functions
plot(W(1, :), Hdb(1, :), '-k', 'LineWidth', 1)
hold on;
plot(W(2, :), Hdb(2, :), ':*b', 'LineWidth', 1)
plot(W(3, :), Hdb(3, :), '-.rs', 'LineWidth', 1)
grid on;
xlabel('f, kHz', 'FontSize', 14);
ylabel('|H|, dB', 'FontSize', 16);
title('Filters numbers: №1, №2, №3,', 'FontSize', 16);
legend ('N1', 'N2', 'N3');
xlim([0, 21000]);
ylim([-60, 10]);
xticks([2000, 8000, 16000]);
xticklabels({'2 kHz', '8 kHz', '16 kHz'});
%% Graph with changing object properties
f=figure('DefaultAxesFontSize',14);
ax=axes;
propNames={'xLim','yLim','XTick','XTickLabel'};
propValues={[0,21000],[-60,10],[2000,8000,16000],{'2 KHz','8 KHz','16 KHz'}};
set(ax, propNames, propValues);
f.Position = [0 150 500 400];
ax.XLabel.String='f,kHz';
ax.YLabel.String='|H|,dB';
ax.Title.String='Filters numbers: №1, №2, №3';
p1=plot(W(1,:),h(1,:));
hold on;
p2=plot(W(2,:),h(2,:));
p3=plot(W(3,:),h(3,:));
propNames={'color', 'Linestyle', 'LineWidth', 'Marker'};
propValues={'black', '-', 1,'none'};
set(p1, propNames, propValues);
propValues={'blue', ':', 1,'*'};
set(p2, propNames, propValues);
propValues={'red', '-.', 1,'s'};
set(p3, propNames, propValues);
legend('N1','N2','N3');
grid on;
%% Graph with no formatting
fi=figure;
p12=plot(W(1,:),h(1,:));
hold on;
p22=plot(W(2,:),h(2,:));
p32=plot(W(3,:),h(3,:));
fi.Position = [1030 50 500 400];
%% Graph with autofunc
createfigure(W(1,:),h);
%% Filtering of signals
[signal, fS] = audioread('song.mp3');
tim = (0:length(signal)-1)/fS;
sig = sin(2*pi*15000*tim);
%sig = [sig' sig'];
signal = signal+sig;
[pxx,f] = pspectrum(signal,fS);
gain = [1,1,1,1,1,1,1,1,1,0];
signalOut = filteringBanks(signal, bBank, gain', 'fftfilter');
[pxx1,f1] = pspectrum(signalOut,fS);
figure(5);
subplot(2,1,1), plot(pxx,f), subplot(2,1,2), plot(pxx1,f1);

%% Spectrogram
[s, f, fi] = spectrogram(signal(:, 1), 2^10, [], freqArray, fS);
[F, T] = meshgrid(f, fi);
Graph3d = figure(6);
axe = axes(Graph3d);
mesh(axe, F, T, abs(s'));
title('3D Graph','FontSize',16);
axe.XScale = 'log';
xlabel(axe,'f, kHz','FontSize',16);
ylabel(axe,'time, s','FontSize',16);
zlabel(axe,'s','FontSize',16)