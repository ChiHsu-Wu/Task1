classdef Key
    
    properties
        stop
        confirm
        left
        right
        escape
        high
        low
        repeat    
    end
    
    methods
        function key = Key()
            KbName('UnifyKeyNames');
            key.stop = KbName('Return');
            key.confirm = KbName('DownArrow');
            key.left = KbName('LeftArrow');
            key.right = KbName('RightArrow');
            key.escape = KbName('Escape'); 
            key.high = KbName('UpArrow');
            key.low = KbName('DownArrow');
            key.repeat = KbName('R');
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

