classdef PTBScreen <handle  
    properties
        mainScreen
        mainScreenNumber
        mainScreenSize 
        mainScreenBackgroundColor
        mainScreenTextColor
        mainScreenLineColor
        mainScreenFont
        mainScreenFontSize
        greetingString
        runningMode
        xCenter
        yCenter
        dims
    end
    
    methods
        function ptbScrn = PTBScreen()
            ptbScrn.SetDefaultValue();
        end
        
        function ptbScrn = SetDefaultValue(ptbScrn)
            ptbScrn.mainScreenBackgroundColor = [225, 225, 225]; 
            ptbScrn.mainScreenTextColor = [125 125 125];
            ptbScrn.mainScreenLineColor = [125 125 125];
            ptbScrn.mainScreenNumber = 0;
        end
        
        function ptbScrn = SetScreenSize(ptbScrn,mode)
            if strcmpi(ptbScrn.runningMode,mode)
                ptbScrn.mainScreenSize = [0 0 800 600];
                ShowCursor;
            else
                ptbScrn.mainScreenSize = [];
                HideCursor;                
            end
            
            
        end
        
        function ptbScrn = OpenWindow(ptbScrn,isDebugging)
            %show the cuesor and 800x600 screen size in debugging mode
            %hide the cursor and use full screen in experiment mode
            if isDebugging
                ptbScrn.mainScreenSize = [0 0 800 600];
                ShowCursor;
            else
                ptbScrn.mainScreenSize = [];
                HideCursor;                
            end
            
            ptbScrn.mainScreen = ...
                Screen('OpenWindow', ...
                ptbScrn.mainScreenNumber, ...
                ptbScrn.mainScreenBackgroundColor, ...
                ptbScrn.mainScreenSize);
            [ptbScrn.xCenter, ptbScrn.yCenter] = ...
                RectCenter(Screen('Rect', ptbScrn.mainScreen));
            [ptbScrn.dims(1), ptbScrn.dims(2)] = WindowSize(ptbScrn.mainScreen);
            
        end
        
        function ptbScrn = SetScreenFont(ptbScrn, fontType, fontSize)
            ptbScrn.mainScreenFont = fontType;
            ptbScrn.mainScreenFontSize = fontSize;
            Screen('TextFont', ptbScrn.mainScreen, ...
                ptbScrn.mainScreenFont);
            Screen('TextSize', ptbScrn.mainScreen, ...
                ptbScrn.mainScreenFontSize);
        end
        function ptbScrn = AddText(ptbScrn, text) 
            [display_text, xOffset, yOffset, color] = PTBScreen.GetComponents(text);
            if xOffset==0
                xPos = 'center';
            else
                xPos = ptbScrn.xCenter + xOffset;
            end
            if yOffset ==0
                yPos = 'center';
            else
                yPos = ptbScrn.yCenter + yOffset;
            end           
            if isempty(color)
                color = ptbScrn.mainScreenTextColor;
            end
            DrawFormattedText(ptbScrn.mainScreen, ...
                display_text, xPos, yPos, ...
                color);   
        end
        
        function ptbScrn = Flip(ptbScrn)
            Screen('Flip', ptbScrn.mainScreen);
        end
        function ptbScrn = AddRect(ptbScrn, rect)
            %{[w,h],xpos,ypos,color }
            [dim, xoffser, yoffset, color] = PTBScreen.GetComponents(rect);
            wWidth = dim(1);
            wHeight = dim(2);
            xp = ptbScrn.xCenter + xoffser;
            yp = ptbScrn.yCenter + yoffset ;
            rect_pos = [xp-wWidth/2 yp-wHeight xp+wWidth/2 yp];
            Screen('FillRect', ptbScrn.mainScreen, color, rect_pos);
        end
        %
        function AddLine(scrn,line)
           [line_length, xOffset, yOffset, color] = PTBScreen.GetComponents(line);
           %%actual width and hight of the screen in mm
           [actual_width, ~] = Screen('DisplaySize', scrn.mainScreen);
           rect = Screen('Rect', scrn.mainScreen);
           pixel_width = rect(3);
           pixels_per_length = pixel_width/actual_width; 
           line_in_pixel = line_length/2*pixels_per_length;
           xp = scrn.xCenter + xOffset;
           yp = scrn.yCenter + yOffset ;
           Screen('DrawLine', scrn.mainScreen,...
                color, xp-line_in_pixel, yp,...
                xp+line_in_pixel , yp, 3);
       end
        %
        

    end
%%%==============================================================================    
    methods(Static)
        function [obj, xoffset, yoffset, color] = GetComponents(cellObj)
            obj = cellObj{1};
            xoffset = cellObj{2};
            yoffset = cellObj{3};
            color = cellObj{4};           
        end

    end
end

