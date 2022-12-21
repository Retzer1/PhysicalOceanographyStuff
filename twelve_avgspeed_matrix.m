function matrix_output = twelve_avgspeed_matrix(struc) %Use this for 2022, 2018, 2019 analyses
    matrix_output = avgspeed_matrix(struc, 12, 5); %Because our structures all have intervals of 5 minutes between data points and we are interested in 12 hr segments.
end