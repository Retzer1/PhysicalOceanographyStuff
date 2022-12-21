function indivLoopSpeedPlotter(struc)
    for i = 1:length(struc)
        speed_12hr_trajectories_single(struc, 0.5, i)
        title(num2str(i))
        hold off
        pause
    end
end