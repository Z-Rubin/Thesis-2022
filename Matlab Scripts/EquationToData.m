x = 1:180;
yx = 1668 + 3.18*log(x); %line of best fit equation

output = round(yx/1000,5);
writematrix(output,'tests\test1.csv'); %writing to specified location