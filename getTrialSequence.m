function [targetSequence, distractSequence, pictPos]=getTrialSequence(nBlock, nTrial)
    targetSequence = -1*ones(nBlock, nTrial);
    distractSequence = -1*ones(nBlock, nTrial);
    pictPos = -1*ones(nBlock, nTrial);
    nSeeds = nBlock*nTrial;
    for bi = 1: nBlock
        ts = -1*ones(1, nTrial);
        ds = -1*ones(1, nTrial);
        i = 1;
        while any(ts <0)
            nextTrial = Ranint(1,nTrial);
            if ~any(ts == nextTrial)
                ts(i) = nextTrial;
                i = i+1;
            end
        end    
        j = 1;
        while any(ds < 0)    
            nextTrial = Ranint(1,nTrial/2);
            if ts(j)<=5
                nextTrial = nextTrial + 5;
            end
            if ~any(ds == nextTrial)
                ds(j) = nextTrial;
                j=j+1;
            end
        end
        
        pictPos(bi, :) = mod(Ranint(10,nSeeds),2)';
        targetSequence(bi, :) = ts;
        distractSequence(bi, :) = ds; 
        disp(ts)
        disp(ds)
    end
end