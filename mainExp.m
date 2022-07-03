function mainExp()
%%main function for the experiment

scrn = PTBScreen() ;
isDebuggingMode = true;
scrn.OpenWindow(isDebuggingMode);
scrn.SetScreenFont('Ariel',20);

%create off screens
offScrn = OffScreen(scrn);

%define buttons/keys
keys = Key();

%set main parameters
nBlock = 2;
nTrial = 10;
responseTime = [];
isAbort = false;

%get trial sequence
audioPath = fullfile('.','audio');
audioExt = '.m4a';
picPath = fullfile('.','pictures');
picExt = '.png';
targetFiles = {'one','two','three','four','five','a','b','c','d','e'};
distractFiles = {'six','seven','eight','nine','zero','f','g','h','i','j'};
[tSeq, dSeq, pictPos]=getTrialSequence(nBlock, nTrial);

%initial results
result.soundPlayOrder = cell(nBlock, nTrial);
result.soundPic = cell(nBlock, nTrial);
result.distractPic = cell(nBlock, nTrial);
result.targetPicPosOrder = -1*ones(nBlock, nTrial);
result.parResponse = -1*ones(nBlock, nTrial);
result.RT = -1*ones(nBlock, nTrial);
result.dispCrossTime = -1*ones(nBlock, nTrial);
%result.playSoundTime = -1*ones(nBlock, nTrial);
result.dispCrossTime = -1*ones(nBlock, nTrial);
result.dispPicsTime = -1*ones(nBlock, nTrial);


%%======================

%showing thank you string for two seconds or wait until any key pressed
%to continue the experiment
 
greetingStr = 'Thank you for paticipanting the experiment';
scrn.AddText({greetingStr,0,60,[]}); 
scrn.Flip();
%duration = 2;
%WaitSecs(duration);
%[isContinue, ~] = PressAnyKeyToContinue(keys);
resp = getParticipantResponse(keys, [], scrn, offScrn, []);
if resp == 3
    dispEndOfExp(scrn, isAbort)
    return
end

%showing the instruction
for i = 1 : length(offScrn.mainExpInstructionScrn)
    Screen('CopyWindow', offScrn.mainExpInstructionScrn(i), scrn.mainScreen);
    scrn.Flip();
    %PressAnyKeyToContinue(keys);
    resp = getParticipantResponse(keys, [], scrn, offScrn, []);
    isAbort = (resp == 3);
    if isAbort
        break;
    end
end
if isAbort
    dispEndOfExp(scrn, isAbort)
    return;
end

%%===================trials start here
for bi = 1: nBlock
    for ti = 1: nTrial
        startTime = tic;

        %display the cross
        dispCrossTime = tic;
        Screen('CopyWindow', offScrn.mainExpCrossScrn, scrn.mainScreen);
        scrn.Flip();
        %PressAnyKeyToContinue(keys);
        resp = getParticipantResponse(keys, [], scrn, offScrn, []);
        isAbort = (resp == 3);
        if isAbort
            break;
        end

        result.dispCrossTime(bi, ti) = toc(dispCrossTime);

        %play sound
        
        audioFile = fullfile(audioPath, [targetFiles{tSeq(bi,ti)}, audioExt]);
        [y,Fs] = audioread(audioFile);
        %playSoundTime = tic;
        sound(y, Fs);
        %result.playSoundTime(bi, ti) = toc(playSoundTime);
        result.soundPlayOrder{bi,ti} = targetFiles{tSeq(bi,ti)};
        dispBlankScrnTime = tic;
        Screen('CopyWindow', offScrn.blankScreen, scrn.mainScreen);
        scrn.Flip();
        WaitSecs(2);
        result.dispCrossTime(bi, ti) = toc(dispBlankScrnTime);

        %display two pictures
        dispPicsTime = tic;
        dim = 100;
        ypos = scrn.yCenter - dim*0.5;
        xpos = scrn.xCenter + scrn.dims(1)*0.25*[-1, 1]; 
        picFiles = {fullfile(picPath, [targetFiles{tSeq(bi, ti)}, picExt]),...
            fullfile(picPath, [distractFiles{dSeq(bi, ti)}, picExt])};
        result.soundPic{bi,ti} = targetFiles{tSeq(bi, ti)};
        result.distractPic{bi,ti} = distractFiles{dSeq(bi, ti)};
        
        for p = 1:2        
            rect = [xpos(p), ypos, xpos(p)+dim, ypos+dim] ;
            if pictPos(bi,ti)==0 %target on the left, distract on the right
                pos = p;
            else %distract on the left, target on the right
                pos = mod(p,2)+1;
            end
            result.targetPicPosOrder(bi,ti) = pictPos(bi,ti) +1; %1:left, 2:right
            img=imread(picFiles{pos},'png');
            imgTex = Screen('MakeTexture', scrn.mainScreen, img);
            Screen('DrawTexture', scrn.mainScreen, imgTex, [], rect);
        end
        scrn.Flip();
        WaitSecs(1);
        result.dispPicsTime(bi,ti) = toc(dispPicsTime);
        
        rt=tic;
        Screen('CopyWindow', offScrn.mainExpQuestionScrn, scrn.mainScreen);
        scrn.Flip();
        respKeys = [keys.left keys.right]; %1:left, 2:right
%         response = ...
%             GetParticipantResponse(keys, respKeys, scrn, offScrn, responseTime);
        response = ...
              getParticipantResponse(keys, respKeys, scrn, offScrn, responseTime);
        isAbort = (response ==3);
        result.RT(bi,ti) = toc(rt); 
        result.parResponse(bi,ti) = response;
        disp(response)
        result.trialTime(bi,ti) = toc(startTime); 
        if isAbort 
            break;
        end
    end %trial loop, ti = 1: nTrial
    if ~isAbort 
        if bi< nBlock
            endOfBlockStr = ['End of Block ' num2str(bi) '.\n Ready for Next Block??'];
        else
            endOfBlockStr = ['End of Block ' num2str(bi) '.'];
        end
        scrn.AddText({endOfBlockStr,0,60,[]});
        scrn.Flip()
        if bi< nBlock
            resp = getParticipantResponse(keys, [], scrn, offScrn, []);
            isAbort = (resp == 3);
        else
            WaitSecs(2);
        end
    end
    
    if isAbort 
        break;
    end
end %block loop, bi = 1: nBlock

% if isAbort
%     greetingStr = 'The Experiment has been terminated!!\n Thank you!!'; 
%     color = 60*[1 1 1];
% else
%     greetingStr = 'The Experiment has been completed!!\n Thank you!!';
%     color = [];
% end
% scrn.AddText({greetingStr,0,60,color});
% scrn.Flip();
% WaitSecs(1); 
%save the result
saveFolder = [pwd '\results'];
saveFileName =['subject_' 'test' '_'...
                datestr(now,'MMHH') '_' datestr(now,'ddmmyy') '.mat'];
save(fullfile(saveFolder, saveFileName),'result')
%%% showing thank you message
dispEndOfExp(scrn, isAbort)
%Screen('CloseAll');
        
        
%     img1=imread(fullfile('.','pictures','one.png'),'png');
%     img2=imread(fullfile('.','pictures','two.png'),'png');
%     %Screen('PutImage', scrn.mainScreen, img);
%     imgTex1 = Screen('MakeTexture', scrn.mainScreen, img1);
%     imgTex2 = Screen('MakeTexture', scrn.mainScreen, img2);
%     scrn.dims
%     xpos = scrn.xCenter - scrn.dims(1)*0.25;
%     dim = 100;
%     ypos = scrn.yCenter - dim*0.5;
%     leftRect = [xpos, ypos, xpos+dim, ypos+dim] ;
%     xpos = scrn.xCenter + scrn.dims(1)*0.25;
%     rightRect = [xpos, ypos, xpos+dim, ypos+dim] ;
%     Screen('DrawTexture', scrn.mainScreen, imgTex1, [], rightRect); 
%     Screen('DrawTexture', scrn.mainScreen, imgTex2, [], leftRect); 
%     scrn.Flip();
%     WaitSecs(2);
% 
%     %display question
%     Screen('CopyWindow', offScrn.mainExpQuestionScrn, scrn.mainScreen);
%     scrn.Flip();
%     resp
Keys = [keys.left keys.right];
%     response = GetParticipantResponse(keys, respKeys, offScrn.mainExpQuestionScrn);
%     disp(response)




end