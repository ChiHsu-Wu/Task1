function response = getParticipantResponse(keys, resp_keys, scrn, offScrn, responseTime)
    resp_keys = [resp_keys keys.escape];
    response = -1;
    KbReleaseWait;
    isTimeOut = false;
    tic;

    while (response < 0) && (~isTimeOut)
        [~, ~, keyCode] = KbCheck;
        keysPressed = find(keyCode==1);  
        if ~isempty(keysPressed)
            keyPressed = keysPressed(end);
            KbReleaseWait;
            if any(resp_keys == keyPressed) 
                response = find(resp_keys==keyPressed);                      
            end
            disp(response)
            %%%for press any key to continue
            if length(resp_keys) == 1
                
                if response == 1 %if escape key pressed
                    response =3;
                else %if any key is pressed
                    response =10;
                end
            end
            %%%for press any key to continue
        end
        if response ==3 %escape key is pressed                      
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
                if length(resp_keys) == 1
                    Screen('CopyWindow', offScrn.blankScreen,...
                        scrn.mainScreen);
                else
                    Screen('CopyWindow', offScrn.mainExpQuestionScrn,...
                        scrn.mainScreen);
                end
                scrn.Flip();
            end
        end %%if response ==3
        if ~isempty(responseTime)
            isTimeOut = toc > responseTime;
        end
    end            
end %GetParticipantResponse