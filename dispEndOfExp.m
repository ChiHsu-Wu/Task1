function dispEndOfExp(scrn, isAbort)
    if isAbort
        greetingStr = 'The Experiment has been terminated!!\n Thank you!!'; 
        color = 60*[1 1 1];
    else
        greetingStr = 'The Experiment has been completed!!\n Thank you!!';
        color = [];
    end
    scrn.AddText({greetingStr,0,60,color});
    scrn.Flip();
    WaitSecs(5); 
    sca;
end

