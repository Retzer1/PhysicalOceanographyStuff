function individualAnimator(struc, Num, stepSize)
    datenums = struc(Num).datenum;
    len = length(datenums);
    if len == 1
       error('ERROR');
    end
    intervals = len/5;
    for i = 1:len
        