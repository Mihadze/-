classdef Equalizer < handle
    properties (Constant)
        freqArray = [31, 62, 125, 250, 500, 1000, 2000, 4000, 8000,16000]
    end
    properties (Access = public)
        gain = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    end
    properties (Access = protected)
        bBank = []
        initB = []
    end
    properties (GetAccess = public, SetAccess = protected)
        fs = 44100
        order = 64
    end
    methods
        function obj = Equalizer(order, fs)
            obj.order = order;
            obj.fs = fs;
            obj.CreateFilters();
        end
        function [signalOut, initB] = Filtering(obj,signal)
            b = sum(obj.gain .* obj.bBank', 1);
            [signalOut, initB] = filter(b, 1, signal, obj.initB);
        end
        function CreateFilters (obj)
            N = length(obj.freqArray);
            freqArrayNorm = obj.freqArray/(obj.fs/2);
            for i = 1:N
                if i == 1
                    mlow = [1, 1, 0, 0];
                    freqLow = [0, freqArrayNorm(1), 2*freqArrayNorm(1), 1];
                    obj.bBank = [obj.bBank; fir2(obj.order, freqLow, mlow)];
                elseif i == N
                    mHigh = [0, 0, 1, 1];
                    freqHigh = [0, freqArrayNorm(end)/2, freqArrayNorm(end), 1];
                    obj.bBank = [obj.bBank; fir2(obj.order, freqHigh, mHigh)];
                else
                    mBand = [0, 0, 1, 0, 0];
                    freqBand = [0, freqArrayNorm(i - 1), freqArrayNorm(i), freqArrayNorm(i + 1), 1];
                    obj.bBank = [obj.bBank; fir2(obj.order, freqBand, mBand)];
                end
            end
        end
        function [Hdb, w] = GetFreqResponse(obj)
            b = sum(obj.gain.*obj.bBank', 2);
            [H, w] = freqz(b, 1, obj.order);
            xdb = @(x)20*log10(x);
            Hdb = xdb(abs(H));
            w = (w/pi) * (obj.fs/2);
        end
    end
end