function trialSequence(nTrial)

targetSequence = [];
while length(targetSequence) < nTrial
    nextTrial = Ranint(1,nTrial);
    if ~any(targetSequence == nextTrial)
        targetSequence(end+1) = nextTrial;
    end
end
distractSequence = [];

while length(distractSequence) < nTrial    
    nextTrial = Ranint(1,nTrial/2);
    if targetSequence(length(distractSequence)+1)<=5
        nextTrial = nextTrial + 5;
    end
    if ~any(distractSequence == nextTrial)
        distractSequence(end+1) = nextTrial;
    end
end


disp({audioPath targetFiles(targetSequence) '.m4a'})
disp(distractFiles(distractSequence))


end