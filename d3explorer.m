function mat3d = d3explorer(struc1, struc2, areEqual) %Creates a 3d matrix, height is datenum, entry (j, k, i) is the distance between drifter j in struc1 and drifter k in struc2 at i-th shared datenum (the datenum corresponding to row i of find_datenum(struc1)).
%This can be used for graph theoretic analysis, each page can be a weighted
%adjacency matrix.
datenums = find_datenum(struc1); %We don't need to mix this with struc2, because we only care about where they overlap
pages = length(datenums);

if areEqual == 0
    rows = length(struc1);
    cols = length(struc2);
    mat3d = zeros(rows, cols, pages); %Establish our 3d matrix with the right dimensions

    for i = 1:pages
        for j = 1:rows
            struc1datenum = whichdatenum(struc1, j, datenums(i)); %This is the index at which the struc1 drifter is at current datenum
            for k = 1:cols
                struc2datenum = whichdatenum(struc2, k, datenums(i)); %This is the index at which the struc2 drifter is at current datenum
                if struc1datenum && struc2datenum

                    mat3d(j, k, i) = geo_distance_COOK(struc1(j).lon(struc1datenum), struc1(j).lat(struc1datenum), struc2(k).lon(struc2datenum), struc2(k).lat(struc2datenum));
                else
                    mat3d(j, k, i) = NaN;
                end
            end
        end
    end
end

if areEqual ~= 0 %Structures are the same
    rows = length(struc1);
    cols = rows;
    mat3d = zeros(rows, cols, pages); %Establish our 3d matrix with the right dimensions
    indicatorMatrix = ones(rows, rows);
    indicatorMatrix = triu(indicatorMatrix) - diag(diag(indicatorMatrix)); %Avoid duplicates
    
    for i = 1:pages
        for j = 1:rows
            struc1datenum = whichdatenum(struc1, j, datenums(i)); %This is the index at which the struc1 drifter is at current datenum
            for k = 1:cols
                if indicatorMatrix(j, k) == 1
                    struc2datenum = whichdatenum(struc2, k, datenums(i)); %This is the index at which the struc2 drifter is at current datenum
                    if struc1datenum && struc2datenum

                        mat3d(j, k, i) = geo_distance_COOK(struc1(j).lon(struc1datenum), struc1(j).lat(struc1datenum), struc2(k).lon(struc2datenum), struc2(k).lat(struc2datenum));
                    else
                        mat3d(j, k, i) = NaN;
                    end
                end
            end
        end
    end
end


end