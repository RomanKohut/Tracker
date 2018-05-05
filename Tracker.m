classdef Tracker < handle
    properties(SetAccess=public)
        URL = ''
    end
    properties(SetAccess=private)
        ID % ID of the robobug
        RequestID=0 
        ReturnID
    end
    properties(SetAccess=private, Hidden)
        Client % WSClient instance
    end
    
    methods

        function obj = Tracker(addr)
            
            base_url = ['ws://' addr ':8888/w/'];
            obj.URL = base_url;
            obj.ID = base_url(length(base_url)-8);
            decoder = @(raw) obj.decode(raw);
            obj.Client = WSClient(base_url, 'Decoder', decoder);
        end

        function connect(obj)
            obj.Client.connect();
            if isequal(obj.Client.getState(), 'OPEN')
               disp('Connection established.');
            end
        end
        
        function close(obj)
            obj.Client.close();
        end
        
        function index = whoami(obj)
            index = obj.ID;
            disp(obj.Client.Server);
        end
        
        function setData(obj, data)
            % Sets the bug's speed as an integer from 0 to 255
            
            assert(isequal(obj.Client.getState(), 'OPEN'), 'Client is not connected.');
            
            msg = sprintf('{"x":%.2f,"y":%.2f,"ax":%.2f,"ay":%.2f,"dx":%.2f,"dy":%.2f}', ...
                data(1),data(2),data(3),data(4),data(5),data(6));
            obj.Client.sendRaw(msg);
        end
    end
    
    methods (Access = private)
        
        function returnID = decode(obj, raw)
            % Takes JSON
            
%             pattern = '"([\w_])+":[ ]*(-?\d+\.?\d*)[,"\}]?';
%             r = regexp(raw, pattern, 'tokens');
%             for i = 1:length(r)
%                 id = r{i}{1};
%                 value = r{i}{2};
%                 if isequal(id, 'retId')
%                     retId = str2double(value);
%                 end
%             end 
            returnID = 0;
        end
        
    end
    
end
