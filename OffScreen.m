classdef OffScreen < handle
    properties
        blankScreen
        mainExpInstructionScrn
        mainExpCrossScrn
        mainExpQuestionScrn
        mainExpExitConfirmationScrn
    end % properties
    
    methods
        function offScrn =OffScreen(scrn) 
            %create blank screen
            offScrn.blankScreen = ...
              OffScreen.CreateOffScreen(scrn,[],[],{[],[],[],scrn.mainScreenBackgroundColor});
            %create mainExpInstructionScrn
            offScrn.createTextScreen(scrn, 1);
            %create mainExpCrossScrn
            offScrn.createCrossScreen(scrn);
            %create mainExpQuestionScrn
            offScrn.createTextScreen(scrn, 2);
            %create exitConfirmationScreen
            offScrn.CreateConfirmationOffScreen(scrn);
            
        end
        
        function createTextScreen(offScrn, scrn, type)
            %type = 1: main experiment intruction
            %type = 2: question for the participants
            [wWidth, wHeight]= WindowSize(scrn.mainScreen); 
            xpos = [-wWidth*0.425 0];
            xOffset = cell(1,5);
            xOffset(:) = {xpos};
            yOffset ={[-wHeight*0.2 0],[-wHeight*0.105 0],...
                [-wHeight*0.06 0], [-wHeight*0.015 0],...
                [wHeight*0.1 0]};             
            
            if type == 1
                displayTexts = {{{'In this experiment, each trial starts from \na cross appearing in the middle of the screen'},...
                  {'When the cross appears, please press a key to activate the sound.'}},... %instruction 1
                  {{'After a key is pressed, you will hear a sound.'},...
                  {'After a brief sound, two pictures will appear on the screen,'},...
                  {'one on the Right side and one on the Left side of the Screen.'}}...%end instruction 2
                  {{'You have to judge  \nwhich of the two pictures was matched the sound you heard.'},...
                  {'If you think the LEFT picture matched, you will respond using the left (<) arrow key.'},...
                  {'If you think the RIGHT picture matched, you will respond using the right (>) arrow key.'}}... %instruction 3
                  {{'When you respond to the question by pressing the key, '},...
                  {'Please press the key after the question appears in the screen. '},...
                  {'If you press the key before the question appears,'},...
                  {'the answer won''t be registered.'},...
                  {'Ready for the experiment?'}}}; %end instruction 4
              for i = 1: length(displayTexts)
                  screenTexts = {displayTexts{i}, xOffset, yOffset, []};
                  offScrn.mainExpInstructionScrn(i) = ...
                      OffScreen.CreateTextStackOffScreen(scrn,[],screenTexts,[]);
              end
            elseif type ==2 
                displayTexts = {...
                    {'Which Picture is matched the sound'},...
                    {'< Left Picture                             Right Picture >'}};
                xOffset ={[0 0],[0 0]};
                yOffset ={[-160 0],[60 0]};%,[60 0]};
                screenTexts = {displayTexts, xOffset, yOffset, []};
                  offScrn.mainExpQuestionScrn = ...
                      OffScreen.CreateTextStackOffScreen(scrn,[],screenTexts,[]);
            end            
        end %create Text Screen  
        
        function offScrn = CreateConfirmationOffScreen(offScrn,scrn)
            displayStrings = {...
                {'Are you sure to terminate the experiment'},...
                {'Yes'},...
                {'Cancel'}...
                };
            separateSpace = 300;
            center = [scrn.xCenter, scrn.yCenter];
            for j = 1:2
                offScrn.mainExpExitConfirmationScrn(j) = Screen('OpenOffscreenWindow',...
                    scrn.mainScreen,scrn.mainScreenBackgroundColor,scrn.mainScreenSize);
                for i = 1:3
                    [~,~,bbox]=DrawFormattedText(scrn.mainScreen, char(displayStrings{i}),...
                        0, 0,scrn.mainScreenBackgroundColor);
                    stringLength = bbox(3)-bbox(1); 
                    stringPos = bbox;
                    if i==1
                        DrawFormattedText(offScrn.mainExpExitConfirmationScrn(j), char(displayStrings{i}),...
                            'center', 'center' ,[0 0 0]);
                    else
                        if i==2
                            pt = [center(1)-(separateSpace+stringLength)/2, center(2)+60];
                        else
                            pt = [center(1)+(separateSpace+stringLength)/2, center(2)+60];
                        end
                        DrawFormattedText(offScrn.mainExpExitConfirmationScrn(j), char(displayStrings{i}),...
                            pt(1),pt(2) ,[0 0 0]);
                        pt = pt - [5 stringPos(4)-stringPos(2)+5];
                        rect = [pt, pt(1)+stringLength+20, pt(2)+stringPos(4)-stringPos(2)+10] ;
                        if j==1 && i==2
                            Screen('FrameRect', offScrn.mainExpExitConfirmationScrn(j), ...
                                [0 0 0], rect,3);
                        end
                        if j==2 && i==3
                            Screen('FrameRect', offScrn.mainExpExitConfirmationScrn(j), ...
                                [0 0 0], rect,3);
                        end
                    end
                end %for i = 1:3
            end %for j= 1:2
        end %CreateConfirmationOffScreen
        
        function createCrossScreen(offScrn, scrn)
            
          crossHorizontal = 30; 
          startPts{1} = [scrn.xCenter - crossHorizontal/2 , scrn.yCenter];
          endPts{1} = [scrn.xCenter + crossHorizontal/2, scrn.yCenter];
          %vertical line
          crossVertical = crossHorizontal;
          startPts{2} = [scrn.xCenter scrn.yCenter - crossVertical/2];
          endPts{2} = [scrn.xCenter scrn.yCenter + crossVertical/2];          
          line = {crossHorizontal,...
              startPts,...
              endPts,...
              scrn.mainScreenLineColor};
            
            
            offScrn.mainExpCrossScrn = ...
                OffScreen.CreateTextStackOffScreen(scrn,line,[],[]);
        end
        
    end % methods
    
    methods (Static)
        
        function [obj, xOffset, yOffset, color] = GetComponents(cellObj)
            obj = cellObj{1};
            xOffset = cellObj{2};
            yOffset = cellObj{3};
            color = cellObj{4}; 
        end %GetComponents
        
        function offScrn = CreateOffScreen(scrn, line, screenTexts, rect)
            offScrn = ...
                Screen('OpenOffscreenWindow',...
                scrn.mainScreen,scrn.mainScreenBackgroundColor,scrn.mainScreenSize);
            Screen('TextSize',offScrn, 20);
            Screen('TextFont',offScrn, 'Times')
            if not(isempty(line))
                OffScreen.AddLine(scrn,offScrn, line); %drawline
            end
            if not(isempty(screenTexts))
                OffScreen.AddText(scrn, offScrn, screenTexts); %add text
            end
            if not(isempty(rect))
                OffScreen.AddRect(scrn,offScrn, rect);
            end
        end %CreateOffScreen
        
        function AddLine(offScrn, line)
           [~, startPts, endPts, color] = OffScreen.GetComponents(line);
           %%actual width and hight of the screen in mm
           for i = 1:length(startPts)
               startPt = startPts{i};
               endPt = endPts{i};
               Screen('DrawLine', offScrn,...
                    color, startPt(1), startPt(2),...
                    endPt(1), endPt(2), 3);
           end
        end %AddLine
        
        function AddText(scrn,offScrn, displayString)
           %{text, xpos, ypos, color}
           [display_strings, xOffset, yOffset, color] = OffScreen.GetComponents(displayString);
            for i = 1: length(display_strings)
               display_string = char(display_strings{i});
               xpos = xOffset(1) + (i-1)*xOffset(2);
               ypos = yOffset(1) + (i-1)*yOffset(2);
               xCenter = scrn.xCenter; 
               yCenter = scrn.yCenter;
               nx = xCenter + xpos;
               ny = yCenter + ypos ;
               if xpos==0 
                   nx= 'center';
               end
               if ypos==0
                   ny = 'center';
               end
               DrawFormattedText(offScrn, display_string,...
                    nx, ny ,color);               
           end
        end %AddText
       
       function AddRect(scrn,offScrn, rect)  
           [dim, xpos, ypos, color] = OffScreen.GetComponents(rect);
           if isempty(dim)
               Screen('FillRect', offScrn, color,[]);
           else
               xCenter = scrn.xCenter;
               yCenter = scrn.yCenter;
               wWidth = dim(1);
               wHeight = dim(2);
               if isempty(xpos) && isempty(ypos)
                   rect_pos = [xCenter-wWidth/2 yCenter-wHeight xCenter+wWidth/2 yCenter];
               else
                   xp = xCenter + xpos;
                   yp = yCenter + ypos ;
                   rect_pos = [xp-wWidth/2 yp-wHeight/2 xp+wWidth/2 yp+wHeight/2];
               end
               Screen('FillRect', offScrn, color, rect_pos);
           end
       end %AddRect      
        
        function t = CreateTextStackOffScreen(scrn, line, displayTexts, rect)
            % add text, line and rect
            t = OffScreen.CreateOffScreen(scrn,[],[], []);
            if ~isempty(displayTexts)
                [displayStrings, xOffset, yOffset, color] = OffScreen.GetComponents(displayTexts);
                for i = 1:length(displayStrings)
                    %displayStrings
                    displayText = {displayStrings{i}, xOffset{i}, yOffset{i},color};
                    if i == 1
                        t = OffScreen.CreateOffScreen(scrn,[],displayText, []);
                    else
                        OffScreen.AddText(scrn, t, displayText);
                    end
                end
            end
            
            %add rectangle
            if ~isempty(rect)
                OffScreen.AddRect(scrn,t, rect);
            end
            %add line
            if ~isempty(line)
                OffScreen.AddLine(t, line)
            end
        end %CreateTextStackOffScreen
    
    
    
    
    end %methods (Static)
    
end %classdef
    
    
    
    
    
    
    
  