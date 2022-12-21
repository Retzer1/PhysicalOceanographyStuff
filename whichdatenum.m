function a = whichdatenum(struc, drifter, datenume)
%Tells us the index at which "drifter" drifter in "struc" structure reaches
%"datenume" datenum.
initial = struc(drifter).datenum(1);
a = 0;
%final = struc(drifter).datenum_range(2);
if datenume < initial - 0.002
    a = 0; %Drifter never reaches said datenum
else
    %for i = 1:length(struc(drifter).datenum)
   %     if (datenume <= struc(drifter).datenum(i) + 0.002) && (datenume >= struc(drifter).datenum(i) - 0.002)
   %         a = i;
    %        break;
    %    end
   % end
    
    a = find(struc(drifter).datenum <= (datenume + 0.002) & struc(drifter).datenum >= (datenume - 0.002));
    if isempty(a)
        a = 0;
    end
end

    