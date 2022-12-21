function counter = stepQCExplorer(struc, startIndex)
%Lets you step through each drifter in the structure, viewing its
%trajectory in two ways and graphically selecting points of the trajectory to flag for
%error
    len = length(struc);
    counter = 0;
    newStruc = struc;
    for i = startIndex:len %Step through each drifter, identifying and marking errors
        
        x = 1;
        while x == 1 %Error selection loop
            clf
            figure(1)
            
            static_trajectory_error(newStruc, i, 0)
            hold on
            static_trajectory(1, newStruc, 1, i)
            pause
            x = input('1 for continue')
            
        end
        counter = counter + 1;
        flag = input('Enter 100 to stop program '); %Give user option to pick up at a later time, saving their work
        if flag == 100
            
            return
        end
    end
    
   
end