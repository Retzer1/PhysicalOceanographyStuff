function default(var_name,value)

%*********************************************************************
%  Function to set the default value of a variable in the caller
%  workspace if either of two conditions exist:
%
%     (1) the variable does not exist there already
%     (2) the variable exists, but it is empty
%*********************************************************************

if evalin('caller',...
        ['~exist(''',var_name,''',''var'') || isempty(' var_name ')'])
    assignin('caller',var_name,value)
end
