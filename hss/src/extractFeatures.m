function [signalsFsstTrain, signalsFsstTest] = extractFeatures(frames, Fs)
    signalsFsstTrain = cell(size(frames.framedSignalsTrain));
    meanTrain = cell(1,length(frames.framedSignalsTrain));
    stdTrain = cell(1,length(frames.framedSignalsTrain));
    for idx = 1:length(frames.framedSignalsTrain)
       disp("Feature extraction (training): #" + idx)
       [s,f,t] = fsst(frames.framedSignalsTrain{idx},Fs,kaiser(128));

       f_indices = (f > 25) & (f < 200);
       signalsFsstTrain{idx}= [real(s(f_indices,:)); imag(s(f_indices,:))];

       meanTrain{idx} = mean(signalsFsstTrain{idx},2);
       stdTrain{idx} = std(signalsFsstTrain{idx},[],2);
    end

    standardizeFun = @(x) (x - mean(cell2mat(meanTrain),2))./mean(cell2mat(stdTrain),2);
    signalsFsstTrain = cellfun(standardizeFun,signalsFsstTrain,'UniformOutput',false);

    signalsFsstTest = cell(size(frames.framedSignalsTest));
    for idx = 1:length(frames.framedSignalsTest)
       disp("Feature extraction (evaluation): #" + idx)

       [s,f,t] = fsst(frames.framedSignalsTest{idx},Fs,kaiser(128));
       f_indices =  (f > 25) & (f < 200);
       signalsFsstTest{idx}= [real(s(f_indices,:)); imag(s(f_indices,:))]; 
    end

    signalsFsstTest = cellfun(standardizeFun,signalsFsstTest,'UniformOutput',false);
end
