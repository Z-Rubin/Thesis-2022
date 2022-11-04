classdef particle < handle
   properties
      mass {mustBeNumeric} 
      volume {mustBeNumeric} 
      size {mustBeNumeric} 
      height {mustBeNumeric}
      density {mustBeNumeric}
      terminalV {mustBeNumeric}
      settled
   end
   methods
      function obj = particle(volume, size, height,density,vis, slurryDensity)
          if nargin == 6
              obj.volume = volume;
              obj.size = size*(10^-6);
              obj.height = height;
              obj.density = density;
              obj.mass = volume*density;
              obj.terminalV = -(2/9)*(obj.density-slurryDensity)*((obj.size/2)^2)*9.81/vis;
              obj.settled = 0;
                            
          end
      end
      
      function setTerminalV(obj, vis, slurryDensity)
          obj.terminalV = -(2/9)*(2*obj.density-slurryDensity)*((obj.size/2)^2)*9.81/vis;
      end
      
      function updateHeight(obj, height, settledHeight)
          if height > settledHeight              
            obj.height = height;
            
          else
            obj.height = settledHeight;  
          end          
      end
      function updateSettled(obj)
          obj.settled = 1;
      end
   end
end