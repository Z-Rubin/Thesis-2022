%% Initiating params
Yn =[35.545718,17.790207,11.399898,11.495861,6.960753,5.950001,2.515761,2.191612,1.854718,1.518652]; %GreatDyke
%Yn = [6.41,6.47,6.16,17.14,28.82,19.35,7.87,6.1,4.24,3.58];%UG2
Yn = Yn/100;
proportionOfSizes = Yn;
sieveSizes = [50,100,150,200,250,300,350,400,450,500]; 
particleDensity = 3500;
slurryDensity = 1000;
viscosity = 0.01;
timeStep = 0.1;
testTime = 180;
scalingFactor = 1.032;

centreOfMass = zeros(1, round(testTime/timeStep));

pipeHeight = 0.7;%metres
filledHeight = 0.3;%metres
pipeRadius = 36*(10^-3)/2;%metres
startingHeight = filledHeight/3; %metres
slurryConcentration = 0.4;
filledVolume = filledHeight*pi*(pipeRadius^2)*1000; %litres
waterMass =(1-slurryConcentration)*filledVolume;

%% instanciation of particles
particles(1,length(sieveSizes)) = particle();

for i = 1:length(sieveSizes)
    
    vol = slurryConcentration*filledVolume*proportionOfSizes(i);
    particles(i) = particle(vol, sieveSizes(i), startingHeight, particleDensity, viscosity, slurryDensity);    
    %particles(i).terminalV = particle.setTerminalV(viscosity, slurryDensity);
    
end

%% Simulating

settledHeight = 0;
iterations = round(testTime/timeStep);
for i = 1:(iterations)
    num = 0;
    den = 0;
    %Calculating centre of mass
    for j = 1:length(particles)
        num = num + particles(j).mass*(particles(j).height);
        den = den + particles(j).mass;       
    end
 
    %Taking water mass into account: has a negligable effect.
    num = num + waterMass*(filledHeight - (filledHeight-settledHeight)/2);
    den = den + waterMass;
   
    centreOfMass(i) = num/den;
    %updating settling heights
    for j = 1:length(particles)
        if particles(j).settled == 0
            height = particles(j).height;
            tV = particles(j).terminalV;
            particles(j).updateHeight(height+tV*timeStep, settledHeight);  
            if particles(j).height == settledHeight
                particles(j).updateSettled;
                settledHeight = settledHeight + pipeHeight*filledHeight*(particles(j).volume/filledVolume);
            end
        end
    end
    
end

settledHeight

%% Outputting to CSV
n = 1:testTime;
period = round(2*pi*sqrt((pipeHeight - centreOfMass)/9.81),5)*scalingFactor;
periodScaled = period(1/timeStep:1/timeStep:end);

output = periodScaled;
writematrix(output,'data\test1.csv');





%% Plotting
centreOfMass = pipeHeight-centreOfMass;
xAxis = 1:(testTime/timeStep);
xAxis = xAxis/10;
x = 1:180;
yx = (1657 + 5.82*log(xAxis))/1000; %GD
%yx = (1646 + 6.72*log(xAxis))/1000; %UG2
figure()
plot(xAxis,period)
hold on

plot(xAxis,yx)
legend('Simulated Period', 'Recorded Period', 'Location', 'southeast')
axis([0 length(xAxis)/10 1.5 1.7])
hold off
