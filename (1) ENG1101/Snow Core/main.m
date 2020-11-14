clc, clear

%gets the xlsx
raw_data = xlsread('Snow Core Data.xlsx');

%puts the columns into vectors
snow_weight_1 = raw_data(1:27, 2);
snow_weight_2 = raw_data(28:end, 2);
core_length_1 = raw_data(1:27, 3);
core_length_2 = raw_data(28:end, 3);

%makes a vector the same length
same_length = [1:27]';

%gets statstics
weight_min_1 = min(snow_weight_1);
weight_min_2 = min(snow_weight_2);
weight_max_1 = max(snow_weight_1);
weight_max_2 = max(snow_weight_2);
weight_mean_1 = mean(snow_weight_1, 'omitnan');
weight_mean_2 = mean(snow_weight_2);
weight_std_1 = std(snow_weight_1, 'omitnan');
weight_std_2 = std(snow_weight_2);

