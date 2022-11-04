%% Initiating params
sieveSizes = [50,100,150,200,250,300,350,400,450,500];% in microns
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
slurryConcentration = 0.7;
filledVolume = filledHeight*pi*(pipeRadius^2)*1000; %litres
waterMass =(1-slurryConcentration)*filledVolume;
particles(1,length(sieveSizes)) = particle();

mu = 2;
sigma = 4;
samples = 10;
maxShiftAmount = 4;
requiredSamples = 1;
dataY = [];
dataX = [];
for k = 1:requiredSamples

    sampleDistribution = normrnd(mu, sigma, 1, 10);
    sampleDistribution = sort(sampleDistribution);
    if sampleDistribution(1) < 0
       sampleDistribution = sampleDistribution - 1.1*sampleDistribution(1); 
    end

    randInt = randi([1,maxShiftAmount]);

    sampleDistribution = sampleDistribution/sum(sampleDistribution);
    Yn = cat(2, sampleDistribution((10-randInt):10), flip(sampleDistribution(1:(9-randInt))));

    coinFlip  = rand();
    if coinFlip >= 0.5
       Yn = flip(Yn);
       Yn = circshift(Yn,5);
       Yn = cat(2, Yn(1:5), flip(Yn(6:10))); 
    end
    
    
    for i = 1:length(sieveSizes)

        vol = slurryConcentration*filledVolume*Yn(i);
        particles(i) = particle(vol, sieveSizes(i), startingHeight, particleDensity, viscosity, slurryDensity);    
    end

    % Simulating

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
                    %particles(j).updateHeight(settledHeight, settledHeight);
                end
            end
        end

    end

  

    % Outputting to CSV
    n = 1:testTime;
    period = round(2*pi*sqrt((pipeHeight - centreOfMass)/9.81),5)*scalingFactor;
    periodScaled = period(1/timeStep:1/timeStep:end);

    dataX = [dataX; periodScaled];
    dataY = [dataY; Yn];
    
    
    
    
    
    
    
    
    
    
    
    
    
end
%% Write output to .CSV
pathString = append('data\X','.csv');
writematrix(dataX,pathString);
pathString = append('data\Y','.csv');
writematrix(dataY,pathString);

