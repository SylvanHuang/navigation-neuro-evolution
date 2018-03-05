classdef MapRobot < handle
    %MAPROBOT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id
        position
        angle
        robot
    end
    
    methods
        function mapRobot = MapRobot(id,robot,position)
            mapRobot.id = id;
            mapRobot.robot = robot;
            mapRobot.position = position;
        end
        
        function position = move(mapRobot, dAngle, stepSize)
           dXY = [cos(dAngle); sin(dAngle)]*stepSize;
           dXYRounded = round(dXY);
           mapRobot.position = mapRobot.position + dXY;
           position = mapRobot.position;
        end
        
        function myMapCoordinates = myMapCoordinates(mapRobot)
           myMapCoordinates = mapRobot.robot.me + mapRobot.position;
        end
        
        function scanMapCoordinates = scanMapCoordinates(mapRobot)
           scanMapCoordinates = mapRobot.robot.scan + mapRobot.position; 
        end
    end
end
