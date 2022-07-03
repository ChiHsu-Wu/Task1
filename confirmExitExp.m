function [response] = confirmExitExp(scrn, offScrn, keys, resp)
    response = resp;
    pos = 1;
    isConfirmed = false;
    while not(isConfirmed)
        Screen('CopyWindow', offScrn.mainExpExitConfirmationScrn(pos),...
            scrn.mainScreen);
        scrn.Flip();
        [~, ~, keyCode2] = KbCheck;
        keyPressed2 = find(keyCode2==1);
        if or(keyPressed2 == keys.right, keyPressed == keys.left)
            pos = mod(pos,2) +1;
            KbReleaseWait;
        end 
        if keyPressed2 == keys.stop
            isConfirmed = true;
        end
    end

    if pos ~= 1
        response = -1;
        Screen('CopyWindow', offScrn.mainExpQuestionScrn,...
            scrn.mainScreen);
        scrn.Flip();
    end

end