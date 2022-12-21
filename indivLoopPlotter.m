function indivLoopPlotter(struc)
    for i = 1:length(struc)
        static_trajectory(1, struc, 0, i)
        title(num2str(i))
        hold off
        pause
    end
end