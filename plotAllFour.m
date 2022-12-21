function [diV, vorT, shear, normal] = plotAllFour(struc, drifter1, drifter2, drifter3, errorQ, startTitle)
    [~, diV] = singleDivergence(struc, drifter1, drifter2, drifter3, errorQ);
    [~, vorT] = singleVORTICITY(struc, drifter1, drifter2, drifter3, errorQ);
    [~, shear] = singleSHEAR(struc, drifter1, drifter2, drifter3, errorQ);
    [~, normal] = singleNORMAL(struc, drifter1, drifter2, drifter3, errorQ);
    hold on
    plot(diV)
    plot(vorT)
    plot(shear)
    plot(normal)
    name1 = int2str(struc(drifter1).node);
    name2 = int2str(struc(drifter2).node);
    name3 = int2str(struc(drifter3).node);
    title(strcat(startTitle, '-Triplet-', name1, name2, name3))
    xlabel('# of 5-min intervals')
    ylabel('Coriolis-normalized Value')
    legend('Divergence', 'Vorticity', 'Shear Deformation', 'Normal Deformation')
end